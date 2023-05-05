import 'package:note_manangement_system/utils/function_utils.dart';

class ValidatorEdit {
  static String? validateFirstname(String? value) {
    if (value == null || value.isEmpty) {
      return "* Please enter your first and last name";
    }

    if (value.trim().length < 2 || value.trim().length > 32) {
      return "* First and last names must be between 2 and 32 characters long";
    }

    if (value.endsWith(' ')) {
      return "* Please do not end with a space";
    }

    return null;
  }

  static String? validateLastname(String? value) {
    if (value == null || value.isEmpty) {
      return "* Please enter ypor name";
    }

    if (value.length < 2 || value.length > 32) {
      return "* Name must be between 2 and 32 characters in length";
    }

    if (value.endsWith(' ')) {
      return "* Please do not end with a space";
    }
    return null;
  }

  static String? validateEmailEdit(String? value) {
    if (value == null || value.isEmpty) {
      return '* Please enter your email address';
    }

    if (!isValidEmail(value)) {
      return '* Email address or password is incorrect';
    }
    return null;
  }
}
