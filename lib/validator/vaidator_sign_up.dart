class ValidatorSignUp {
  static String? valiEmailSignUp(String? value) {
    if (value == null || value.isEmpty) {
      return '* Please enter your email address';
    }

    if (value.trim().length < 6) {
      return "* Please enter at least 6 characters";
    }

    if (value.trim().length > 256) {
      return "* Please enter up to 256 characters";
    }

    if (value.contains('..') ||
        value.startsWith('.') ||
        value.endsWith('.') ||
        value.endsWith('@') ||
        value.contains('-@') ||
        value.contains('@-') ||
        value.contains('..') ||
        RegExp(r'^[0-9]+$').hasMatch(value)) {
      return '* Email address is incorrect';
    }

    final List<String> parts = value.split('@');
    if (parts.length != 2 || parts[0].isEmpty || parts[1].isEmpty) {
      return '* Email address is incorrect';
    }

    if (RegExp(r'[^\w\s@.-]').hasMatch(value)) {
      return '* Email address is incorrect';
    }

    return null;
  }

  static String? valiPasswordSignUp(String? value) {
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
