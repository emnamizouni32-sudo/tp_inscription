import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../utils/validators.dart';
import 'step_two_screen.dart';

/// Maquette 01_Etape1_InfosPerso
class StepOneScreen extends StatefulWidget {
  const StepOneScreen({super.key});

  @override
  State<StepOneScreen> createState() => _StepOneScreenState();
}

class _StepOneScreenState extends State<StepOneScreen> {
  final _formKey = GlobalKey<FormState>();

  // Sert à revalider la confirmation quand le mot de passe change.
  final _confirmKey = GlobalKey<FormFieldState<String>>();

  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _next() {
    // On n'avance que si TOUS les champs sont valides.
    if (!_formKey.currentState!.validate()) return;

    final profil = UserProfile(
      nom: _nomCtrl.text.trim(),
      prenom: _prenomCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      motDePasse: _passwordCtrl.text,
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => StepTwoScreen(profil: profil)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription – Étape 1/3'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(value: 1 / 3, minHeight: 4),
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomCtrl,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nom',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: Validators.nom,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _prenomCtrl,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Prénom',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: Validators.prenom,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordCtrl,
              obscureText: _hidePassword,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                helperText: '8 caractères min., 1 majuscule, 1 chiffre',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _hidePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => _hidePassword = !_hidePassword),
                ),
              ),
              validator: Validators.motDePasse,
              // Revalidation croisée de la confirmation
              onChanged: (_) {
                if (_confirmCtrl.text.isNotEmpty) {
                  _confirmKey.currentState?.validate();
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: _confirmKey,
              controller: _confirmCtrl,
              obscureText: _hideConfirm,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _next(),
              decoration: InputDecoration(
                labelText: 'Confirmation du mot de passe',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _hideConfirm ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _hideConfirm = !_hideConfirm),
                ),
              ),
              validator: (v) => Validators.confirmation(v, _passwordCtrl.text),
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