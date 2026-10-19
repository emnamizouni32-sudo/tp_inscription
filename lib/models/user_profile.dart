/// Modèle immuable : tous les champs sont `final`.
/// Pour "modifier" un profil, on crée une copie avec [copyWith].
class UserProfile {
  // Étape 1
  final String nom;
  final String prenom;
  final String email;
  final String motDePasse;

  // Étape 2
  final String profession;
  final int? experience; // années d'expérience (0 à 50)
  final double? tjm; // taux journalier moyen en €
  final String biographie;

  const UserProfile({
    this.nom = '',
    this.prenom = '',
    this.email = '',
    this.motDePasse = '',
    this.profession = '',
    this.experience,
    this.tjm,
    this.biographie = '',
  });

  /// Retourne une NOUVELLE instance : seuls les champs fournis changent,
  /// les autres gardent leur valeur actuelle.
  UserProfile copyWith({
    String? nom,
    String? prenom,
    String? email,
    String? motDePasse,
    String? profession,
    int? experience,
    double? tjm,
    String? biographie,
  }) {
    return UserProfile(
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      motDePasse: motDePasse ?? this.motDePasse,
      profession: profession ?? this.profession,
      experience: experience ?? this.experience,
      tjm: tjm ?? this.tjm,
      biographie: biographie ?? this.biographie,
    );
  }

  /// Le mot de passe n'est jamais affiché en clair (écran récapitulatif).
  String get motDePasseMasque => '•' * motDePasse.length;
}