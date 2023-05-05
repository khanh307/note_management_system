import 'package:intl/intl.dart';
import 'package:note_manangement_system/database/sql_helper.dart';
import 'package:time_machine/time_machine.dart';

class NoteValidator {
  static Future<String?> nameValidate(
      String? value, int? id, int userId) async {
    if (value == null || value.isEmpty) {
      return '* Vui lòng nhập tên';
    }

    if (value.length < 5) {
      return '* Vui lòng nhập tối thiểu 5 ký tự';
    }

    bool isDuplicate = await SQLHelper.checkDuplicateNote(
        value, (id == null) ? -1 : id, userId);
    if (!isDuplicate) {
      return '* Vui lòng nhập tên khác, tên này đã tồn tại';
    }
    return null;
  }

  static String? categoryValidate(String? value) {
    if (value == null) {
      return '* Vui chọn danh mục';
    }
    return null;
  }

  static String? priorityValidate(String? value) {
    if (value == null) {
      return '* Vui chọn độ ưu tiên';
    }
    return null;
  }

  static String? statusValidate(String? value) {
    if (value == null) {
      return '* Vui chọn trạng thái';
    }
    return null;
  }

  static String? planDateValidate(String? value) {
    if (value == null || value.isEmpty) {
      return '* Vui lòng chọn ngày hoàn thành';
    }

    if (DateFormat('dd/MM/yyy').parse(value!).isBefore(DateTime.now())) {
      return '* Vui lòng chọn ngày hoàn thành bắt đầu từ ngày hiện tại';
    }

    return null;
  }
}
