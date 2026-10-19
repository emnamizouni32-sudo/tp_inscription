/// Toutes les règles de validation du formulaire.
///
/// Convention : chaque validateur reçoit la valeur saisie et renvoie
///  - `null`  → la valeur est valide
///  - un texte → le message d'erreur affiché sous le champ
class Validators {
  // Constructeur privé : la classe ne sert qu'à regrouper des fonctions statiques.
  Validators._();

  // Lettres (avec accents), espace, tiret et apostrophe.
  static final RegExp _nameRegExp = RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ\s'\-]+$");

  // Format xxx@domaine.ext
  static final RegExp _emailRegExp =
      RegExp(r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$');

  static final RegExp _upperRegExp = RegExp(r'[A-Z]');
  static final RegExp _digitRegExp = RegExp(r'[0-9]');

  // ---------------------------------------------------------------------------
  // ÉTAPE 1
  // ---------------------------------------------------------------------------

  static String? nom(String? value) => _validateName(value, 'nom');

  static String? prenom(String? value) => _validateName(value, 'prénom');

  static String? _validateName(String? value, String label) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Le $label est obligatoire';
    if (text.length < 2) return 'Le $label doit contenir au moins 2 caractères';
    if (!_nameRegExp.hasMatch(text)) {
      return 'Le $label ne doit contenir que des lettres';
    }
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return "L'e-mail est obligatoire";
    if (!_emailRegExp.hasMatch(text)) return 'Format attendu : nom@domaine.com';
    return null;
  }

  /// Pas de trim() : un espace peut faire partie du mot de passe.
  static String? motDePasse(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Le mot de passe est obligatoire';
    if (text.length < 8) return 'Au moins 8 caractères';
    if (!_upperRegExp.hasMatch(text)) return 'Au moins une lettre majuscule';
    if (!_digitRegExp.hasMatch(text)) return 'Au moins un chiffre';
    return null;
  }

  /// [motDePasse] = valeur actuelle du champ mot de passe
  /// (on la passe depuis l'écran : `_passwordController.text`).
  static String? confirmation(String? value, String motDePasse) {
    final text = value ?? '';
    if (text.isEmpty) return 'Veuillez confirmer le mot de passe';
    if (text != motDePasse) return 'Les mots de passe ne correspondent pas';
    return null;
  }

  // ---------------------------------------------------------------------------
  // ÉTAPE 2
  // ---------------------------------------------------------------------------

  static String? profession(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'La profession est obligatoire';
    if (text.length < 2) {
      return 'La profession doit contenir au moins 2 caractères';
    }
    return null;
  }

  /// Entier entre 0 et 50.
  static String? experience(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return "L'expérience est obligatoire";
    final n = int.tryParse(text);
    if (n == null) return 'Entrez un nombre entier';
    if (n < 0 || n > 50) return 'Valeur comprise entre 0 et 50';
    return null;
  }

  /// Convertit "350,50" ou "350.50" en double (null si invalide).
  static double? parseTjm(String? value) {
    final text = (value ?? '').trim().replaceAll(',', '.');
    return double.tryParse(text);
  }

  /// Nombre entre 50 et 3000 €, la virgule est acceptée.
  static String? tjm(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Le TJM est obligatoire';
    final n = parseTjm(text);
    if (n == null) return 'Entrez un nombre valide';
    if (n < 50 || n > 3000) {
      return 'Le TJM doit être compris entre 50 € et 3000 €';
    }
    return null;
  }

  /// Facultative, mais au moins 20 caractères si elle est remplie.
  static String? biographie(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null; // champ vide = valide
    if (text.length < 20) {
      return 'Au moins 20 caractères (${text.length}/20) ou laissez vide';
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // ÉTAPE 3
  // ---------------------------------------------------------------------------

  /// Validateur du FormField<bool> (case à cocher).
  static String? conditions(bool? accepted) {
    if (accepted != true) {
      return "Vous devez accepter les conditions d'utilisation";
    }
    return null;
  }
}