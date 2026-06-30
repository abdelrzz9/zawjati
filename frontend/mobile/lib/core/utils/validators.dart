class Validators {
  static final RegExp _emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$');

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Ce champ est requis';
    if (value.length < 8) return 'Minimum 8 caractères';
    if (!value.contains(RegExp(r'[A-Z]'))) return 'Au moins une majuscule';
    if (!value.contains(RegExp(r'[a-z]'))) return 'Au moins une minuscule';
    if (!value.contains(RegExp(r'[0-9]'))) return 'Au moins un chiffre';
    if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return 'Au moins un caractère spécial';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value != password) return 'Les mots de passe ne correspondent pas';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Ce champ est requis';
    if (!_emailRegex.hasMatch(value.trim())) return 'Email invalide';
    return null;
  }

  static String? required(String? value, [String field = 'Ce champ']) {
    if (value == null || value.trim().isEmpty) return '$field est requis';
    return null;
  }
}
