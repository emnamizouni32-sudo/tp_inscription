import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../utils/validators.dart';
import 'step_one_screen.dart';


class SummaryScreen extends StatefulWidget {
  final UserProfile profil;

  const SummaryScreen({super.key, required this.profil});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final _formKey = GlobalKey<FormState>();

  
  void _goToStart() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const StepOneScreen()),
      (route) => false,
    );
  }

  
  Future<void> _confirmReset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tout effacer ?'),
        content: const Text(
          'Toutes les informations saisies seront perdues. '
          'Vous reviendrez à la première étape.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );

    if (ok == true && mounted) _goToStart();
  }

  Future<void> _confirm() async {
    // Valide notamment la case « J'accepte les conditions »
    if (!_formKey.currentState!.validate()) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false, // non fermable en touchant à côté
      builder: (ctx) => AlertDialog(
        icon: Icon(
          Icons.check_circle,
          size: 48,
          color: Theme.of(ctx).colorScheme.primary,
        ),
        title: const Text('Compte créé !'),
        content: Text(
          'Bienvenue ${widget.profil.prenom} ! '
          'Votre profil a bien été enregistré.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Terminer'),
          ),
        ],
      ),
    );

    if (mounted) _goToStart();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.profil;
    final bio = p.biographie.isEmpty ? 'Non renseignée' : p.biographie;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Récapitulatif de votre profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Réinitialiser',
            onPressed: _confirmReset,
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(value: 1, minHeight: 4),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionCard(
              title: 'Identité',
              rows: [
                _Row(Icons.person_outline, 'Nom', p.nom),
                _Row(Icons.person_outline, 'Prénom', p.prenom),
                _Row(Icons.email_outlined, 'E-mail', p.email),
                // Jamais de mot de passe en clair
                _Row(Icons.lock_outline, 'Mot de passe', p.motDePasseMasque),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Profil professionnel',
              rows: [
                _Row(Icons.work_outline, 'Profession', p.profession),
                _Row(Icons.timeline, 'Expérience', '${p.experience} an(s)'),
                _Row(Icons.euro, 'TJM', '${p.tjm} €'),
                _Row(Icons.notes, 'Biographie', bio),
              ],
            ),
            const SizedBox(height: 16),

            // Champ NON textuel : FormField<bool> avec son propre validateur
            FormField<bool>(
              initialValue: false,
              validator: Validators.conditions,
              builder: (state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      value: state.value ?? false,
                      onChanged: (v) => state.didChange(v),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      title: const Text("J'accepte les conditions d'utilisation"),
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          state.errorText!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _confirm,
              child: const Text('Confirmer et créer le compte'),
            ),
          ],
        ),
      ),
    );
  }
}


class _Row {
  final IconData icon;
  final String label;
  final String value;

  const _Row(this.icon, this.label, this.value);
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<_Row> rows;

  const _SectionCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            for (final r in rows)
              ListTile(
                dense: true,
                leading: Icon(r.icon),
                title: Text(r.label),
                subtitle: Text(r.value),
              ),
          ],
        ),
      ),
    );
  }
}