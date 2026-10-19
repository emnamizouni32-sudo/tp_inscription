import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/user_profile.dart';
import '../utils/validators.dart';
import 'summary_screen.dart';

/// Maquette 02_Etape2_ProfilPro
class StepTwoScreen extends StatefulWidget {
  final UserProfile profil;

  const StepTwoScreen({super.key, required this.profil});

  @override
  State<StepTwoScreen> createState() => _StepTwoScreenState();
}

class _StepTwoScreenState extends State<StepTwoScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _professionCtrl;
  late final TextEditingController _experienceCtrl;
  late final TextEditingController _tjmCtrl;
  late final TextEditingController _bioCtrl;

  @override
  void initState() {
    super.initState();
    _professionCtrl = TextEditingController(text: widget.profil.profession);
    _experienceCtrl =
        TextEditingController(text: widget.profil.experience?.toString() ?? '');
    _tjmCtrl = TextEditingController(text: widget.profil.tjm?.toString() ?? '');
    _bioCtrl = TextEditingController(text: widget.profil.biographie);
  }

  @override
  void dispose() {
    _professionCtrl.dispose();
    _experienceCtrl.dispose();
    _tjmCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;

    // Fusion des données : on ne modifie pas l'objet reçu, on en crée une copie.
    final updated = widget.profil.copyWith(
      profession: _professionCtrl.text.trim(),
      experience: int.parse(_experienceCtrl.text.trim()),
      tjm: Validators.parseTjm(_tjmCtrl.text),
      biographie: _bioCtrl.text.trim(),
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SummaryScreen(profil: updated)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Professionnel – Étape 2/3'),
        // Bouton retour explicite
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Retour',
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(value: 2 / 3, minHeight: 4),
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _professionCtrl,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Profession',
                prefixIcon: Icon(Icons.work_outline),
              ),
              validator: Validators.profession,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _experienceCtrl,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              // Seuls les chiffres sont acceptés, 2 caractères maximum
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              decoration: const InputDecoration(
                labelText: "Années d'expérience",
                prefixIcon: Icon(Icons.timeline),
              ),
              validator: Validators.experience,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tjmCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              // Chiffres, virgule et point uniquement ("abc" est bloqué)
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                LengthLimitingTextInputFormatter(8),
              ],
              decoration: const InputDecoration(
                labelText: 'TJM (taux journalier)',
                suffixText: '€',
                prefixIcon: Icon(Icons.euro),
              ),
              validator: Validators.tjm,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bioCtrl,
              minLines: 4,
              maxLines: 6,
              maxLength: 300, // affiche le compteur 0/300
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Biographie (facultative)',
                alignLabelWithHint: true,
              ),
              validator: Validators.biographie,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _next,
              child: const Text('Suivant'),
            ),
          ],
        ),
      ),
    );
  }
}