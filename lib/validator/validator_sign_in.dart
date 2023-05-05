import 'package:note_manangement_system/utils/function_utils.dart';

class ValidatorSignIn {
  static String? valiEmailSignIn(String? value) {
    if (value == null || value.isEmpty) {
      return '* Please enter your email';
    }

    if (!isValidEmail(value)) {
      return '* Email address or password is incorrect';
    }
    return null;
  }

  static String? valiPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '* Please enter a password';
    }

    if (!isPasswordValid(value)) {
      return "* Email address or password is incorrect";
    }
    return null;
  }
}
