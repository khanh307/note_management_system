import 'package:intl/intl.dart';
import 'package:note_manangement_system/database/sql_helper.dart';
import 'package:time_machine/time_machine.dart';

class NoteValidator {
  static Future<String?> nameValidate(String? value, int? id, int userId) async {
    if (value == null || value.isEmpty) {
      return '* Please enter a name';
    }

    if (value.length < 5) {
      return '* Please enter a minimum of 5 characters';
    }

    bool isDuplicate = await SQLHelper.checkDuplicateNote(value, (id == null) ? - 1 : id, userId);
    if (!isDuplicate) {
      return '* Please enter a different name, this name already exists';
    }
    return null;
  }

  static String? categoryValidate(String? value) {
    if (value == null) {
      return '* Please select a category';
    }
    return null;
  }

  static String? priorityValidate(String? value) {
    if (value == null) {
      return '* Please select a priority';
    }
    return null;
  }

  static String? statusValidate(String? value) {
    if (value == null) {
      return '* Please select a status';
    }
    return null;
  }

  static String? planDateValidate(String? value) {
    if (value == null || value.isEmpty) {
      return '* Please select a completion date';
    }

    if (DateFormat('dd/MM/yyy')
        .parse(value!)
        .isBefore(DateTime.now())) {
      return '* Please select a completion date starting from the current date';
    }

    return null;
  }
}
