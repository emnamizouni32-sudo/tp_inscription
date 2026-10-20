
class Validators {

  Validators._();


  static final RegExp _nameRegExp = RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ\s'\-]+$");

  
  static final RegExp _emailRegExp =
      RegExp(r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$');

  static final RegExp _upperRegExp = RegExp(r'[A-Z]');
  static final RegExp _digitRegExp = RegExp(r'[0-9]');

  

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

 
  static String? motDePasse(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Le mot de passe est obligatoire';
    if (text.length < 8) return 'Au moins 8 caractères';
    if (!_upperRegExp.hasMatch(text)) return 'Au moins une lettre majuscule';
    if (!_digitRegExp.hasMatch(text)) return 'Au moins un chiffre';
    return null;
  }



  static String? confirmation(String? value, String motDePasse) {
    final text = value ?? '';
    if (text.isEmpty) return 'Veuillez confirmer le mot de passe';
    if (text != motDePasse) return 'Les mots de passe ne correspondent pas';
    return null;
  }

  

  static String? profession(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'La profession est obligatoire';
    if (text.length < 2) {
      return 'La profession doit contenir au moins 2 caractères';
    }
    return null;
  }


  static String? experience(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return "L'expérience est obligatoire";
    final n = int.tryParse(text);
    if (n == null) return 'Entrez un nombre entier';
    if (n < 0 || n > 50) return 'Valeur comprise entre 0 et 50';
    return null;
  }

  static double? parseTjm(String? value) {
    final text = (value ?? '').trim().replaceAll(',', '.');
    return double.tryParse(text);
  }

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

  
  static String? biographie(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null; 
    if (text.length < 20) {
      return 'Au moins 20 caractères (${text.length}/20) ou laissez vide';
    }
    return null;
  }



  static String? conditions(bool? accepted) {
    if (accepted != true) {
      return "Vous devez accepter les conditions d'utilisation";
    }
    return null;
  }
}