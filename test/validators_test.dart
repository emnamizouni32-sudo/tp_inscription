import 'package:flutter_test/flutter_test.dart';

// ⚠️ Remplace "tp_inscription" par le champ `name:` de ton pubspec.yaml
import 'package:tp_inscription/models/user_profile.dart';
import 'package:tp_inscription/utils/validators.dart';

void main() {
  group('Nom / Prénom', () {
    test('vide ou espaces -> obligatoire', () {
      expect(Validators.nom(''), 'Le nom est obligatoire');
      expect(Validators.nom(null), 'Le nom est obligatoire');
      expect(Validators.prenom('   '), 'Le prénom est obligatoire');
    });

    test('trop court', () {
      expect(Validators.nom('A'), 'Le nom doit contenir au moins 2 caractères');
    });

    test('caractères interdits', () {
      expect(Validators.nom('Ben 3li'), 'Le nom ne doit contenir que des lettres');
      expect(Validators.prenom('Ali!'), 'Le prénom ne doit contenir que des lettres');
    });

    test('valides (accents, tiret, apostrophe, espace)', () {
      expect(Validators.nom('Ben Ali'), isNull);
      expect(Validators.prenom('Jean-Éric'), isNull);
      expect(Validators.nom("O'Connor"), isNull);
      expect(Validators.prenom('Élodie'), isNull);
    });
  });

  group('E-mail', () {
    test('vide', () {
      expect(Validators.email(''), "L'e-mail est obligatoire");
    });

    test('format invalide', () {
      expect(Validators.email('ali@gmail'), 'Format attendu : nom@domaine.com');
      expect(Validators.email('ali.gmail.com'), 'Format attendu : nom@domaine.com');
      expect(Validators.email('@gmail.com'), 'Format attendu : nom@domaine.com');
    });

    test('valide', () {
      expect(Validators.email('ali@gmail.com'), isNull);
      expect(Validators.email('prenom.nom+tag@univ.edu.tn'), isNull);
    });
  });

  group('Mot de passe', () {
    test('vide', () {
      expect(Validators.motDePasse(''), 'Le mot de passe est obligatoire');
    });

    test('trop court', () {
      expect(Validators.motDePasse('Ab1'), 'Au moins 8 caractères');
    });

    test('sans majuscule', () {
      expect(Validators.motDePasse('bonjour12'), 'Au moins une lettre majuscule');
    });

    test('sans chiffre', () {
      expect(Validators.motDePasse('Bonjourtous'), 'Au moins un chiffre');
    });

    test('valide', () {
      expect(Validators.motDePasse('Bonjour12'), isNull);
    });
  });

  group('Confirmation', () {
    test('vide', () {
      expect(Validators.confirmation('', 'Bonjour12'),
          'Veuillez confirmer le mot de passe');
    });

    test('différente', () {
      expect(Validators.confirmation('Bonjour13', 'Bonjour12'),
          'Les mots de passe ne correspondent pas');
    });

    test('identique', () {
      expect(Validators.confirmation('Bonjour12', 'Bonjour12'), isNull);
    });
  });

  group('Profession', () {
    test('vide', () {
      expect(Validators.profession('  '), 'La profession est obligatoire');
    });

    test('trop courte', () {
      expect(Validators.profession('D'),
          'La profession doit contenir au moins 2 caractères');
    });

    test('valide', () {
      expect(Validators.profession('Développeuse'), isNull);
    });
  });

  group('Expérience', () {
    test('vide', () {
      expect(Validators.experience(''), "L'expérience est obligatoire");
    });

    test('pas un entier', () {
      expect(Validators.experience('abc'), 'Entrez un nombre entier');
      expect(Validators.experience('2.5'), 'Entrez un nombre entier');
    });

    test('hors bornes', () {
      expect(Validators.experience('75'), 'Valeur comprise entre 0 et 50');
      expect(Validators.experience('51'), 'Valeur comprise entre 0 et 50');
    });

    test('valides (bornes incluses)', () {
      expect(Validators.experience('0'), isNull);
      expect(Validators.experience('50'), isNull);
      expect(Validators.experience('12'), isNull);
    });
  });

  group('TJM', () {
    test('vide', () {
      expect(Validators.tjm(''), 'Le TJM est obligatoire');
    });

    test('pas un nombre', () {
      expect(Validators.tjm('abc'), 'Entrez un nombre valide');
    });

    test('hors bornes', () {
      expect(Validators.tjm('25'),
          'Le TJM doit être compris entre 50 € et 3000 €');
      expect(Validators.tjm('3001'),
          'Le TJM doit être compris entre 50 € et 3000 €');
    });

    test('valides (virgule acceptée)', () {
      expect(Validators.tjm('350,50'), isNull);
      expect(Validators.tjm('350.50'), isNull);
      expect(Validators.tjm('50'), isNull);
      expect(Validators.tjm('3000'), isNull);
    });

    test('parseTjm convertit la virgule', () {
      expect(Validators.parseTjm('350,50'), 350.5);
      expect(Validators.parseTjm('abc'), isNull);
    });
  });

  group('Biographie', () {
    test('vide = valide', () {
      expect(Validators.biographie(''), isNull);
      expect(Validators.biographie('   '), isNull);
      expect(Validators.biographie(null), isNull);
    });

    test('trop courte', () {
      expect(Validators.biographie('Je code.'),
          'Au moins 20 caractères (8/20) ou laissez vide');
    });

    test('assez longue', () {
      expect(
        Validators.biographie('Je développe des applications mobiles.'),
        isNull,
      );
    });
  });

  group('Conditions', () {
    test('non cochée', () {
      expect(Validators.conditions(false),
          "Vous devez accepter les conditions d'utilisation");
      expect(Validators.conditions(null),
          "Vous devez accepter les conditions d'utilisation");
    });

    test('cochée', () {
      expect(Validators.conditions(true), isNull);
    });
  });

  group('UserProfile.copyWith', () {
    test('crée une copie sans modifier l\'original', () {
      const original = UserProfile(nom: 'Ben Ali', prenom: 'Sara');
      final copie = original.copyWith(profession: 'Dev', experience: 3);

      expect(copie.nom, 'Ben Ali');
      expect(copie.profession, 'Dev');
      expect(copie.experience, 3);
      expect(original.profession, '');
      expect(original.experience, isNull);
    });

    test('mot de passe masqué', () {
      const p = UserProfile(motDePasse: 'Bonjour12');
      expect(p.motDePasseMasque, '•••••••••');
    });
  });
}