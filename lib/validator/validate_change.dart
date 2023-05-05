class ValidateChange {
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '* Please enter your password';
    }

    if (value.trim().length < 6 || value.trim().length > 32) {
      return '* Password must be between 6 and 32 characters in length';
    }

    RegExp upperCase = RegExp(r'[A-Z]');
    if (!upperCase.hasMatch(value)) {
      return '* Please enter at least 1 capital letter';
    }

    RegExp digit = RegExp(r'[0-9]');
    if (!digit.hasMatch(value)) {
      return '* Please enter at least 1 number';
    }

    return null;
  }
}
