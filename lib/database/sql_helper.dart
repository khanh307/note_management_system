import 'package:note_manangement_system/model/category_model.dart';
import 'package:note_manangement_system/model/note_model.dart';
import 'package:note_manangement_system/model/priority_model.dart';
import 'package:note_manangement_system/model/status_model.dart';
import 'package:note_manangement_system/model/user_model.dart';
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static const _dbName = "note.db";

  static const _columnId = "id";
  static const _columnName = "name";
  static const _columnCreateAt = "createdAt";
  static const _columnUserId = "userid";

//  user
  static const _userTable = "user";
  static const _columnEmail = "email";
  static const _columnPassword = "password";
  static const _columnFirstName = "firstname";
  static const _columnLastName = "lastname";

//  category
  static const _categoryTable = "category";

//  prority
  static const _priorityTable = "priority";

//  status
  static const _statusTable = "status";

//  note
  static const _noteTable = "note";
  static const _columnPlanDate = "planDate";
  static const _columnCategoryId = "categoryId";
  static const _columnPriorityId = "priorityId";
  static const _columnStatusId = "statusId";

  static Future<void> createUserTable(Database database) async {
    await database.execute('''CREATE TABLE $_userTable(
    $_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $_columnEmail TEXT,
    $_columnFirstName TEXT,
    $_columnLastName TEXT,
    $_columnPassword TEXT)''');
  }

  static Future<void> createPriorityTable(Database database) async {
    await database.execute('''CREATE TABLE $_priorityTable(
    $_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $_columnName TEXT,
    $_columnUserId INTEGER,
    $_columnCreateAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)''');
  }

  static Future<void> createStatusTable(Database database) async {
    await database.execute('''CREATE TABLE $_statusTable(
    $_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $_columnName TEXT,
    $_columnUserId INTEGER,
    $_columnCreateAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)''');
  }

  static Future<void> createCategoryTable(Database database) async {
    await database.execute('''CREATE TABLE $_categoryTable(
    $_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $_columnName TEXT,
    $_columnUserId INTEGER,
    $_columnCreateAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)''');
  }

  static Future<void> createNoteTable(Database database) async {
    await database.execute('''CREATE TABLE $_noteTable(
    $_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $_columnName TEXT,
    $_columnUserId INTEGER,
    $_columnCategoryId INTEGER,
    $_columnPriorityId INTEGER,
    $_columnStatusId INTEGER,
    $_columnPlanDate TIMESTAMP,
    $_columnCreateAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)''');
  }

  static Future<Database> db() async {
    return openDatabase(
      _dbName,
      version: 1,
      onCreate: (Database database, int version) async {
        await createUserTable(database);
        await createCategoryTable(database);
        await createPriorityTable(database);
        await createStatusTable(database);
        await createNoteTable(database);
      },
    );
  }

  // add a user
  static Future<int> addUser(UserModel user) async {
    final db = await SQLHelper.db();

    final id = await db.insert(_userTable, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  //read all user
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await SQLHelper.db();

    return db.query(_userTable, orderBy: "id");
  }

  //function check login
  static Future<List<Map<String, dynamic>>> checkLogin(
      String email, String password) async {
    final db = await SQLHelper.db();
    return await db.query(_userTable,
        where: '$_columnEmail = ? AND $_columnPassword = ?',
        whereArgs: [email, password]);
  }

  // Email duplicate check function in database
  static Future<bool> checkDuplicateEmail(String email) async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> users = await db
        .query(_userTable, where: '$_columnEmail = ?', whereArgs: [email]);

    if (users.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //add account
  static Future addAccount(String email, String password) async {
    final isDuplicate = await checkDuplicateEmail(email);
    if (isDuplicate) {
      return false;
    } else {
      UserModel user = UserModel(
        email: email,
        password: password,
      );
      SQLHelper.addUser(user);
      return true;
    }
  }

  //load user
  static Future<UserModel?> loadDataUser(int id) async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> maps =
        await db.query(_userTable, where: "id = ?", whereArgs: [id]);

    if (maps.isNotEmpty) {
      Map<String, dynamic> map = maps.first;
      UserModel user = UserModel(
        id: map['id'],
        firstname: map['firstname'],
        lastname: map['lastname'],
        email: map['email'],
      );
      return user;
    }
    return null;
  }

  //function change password
  static Future<void> changePassword(String email, String password) async {
    final db = await SQLHelper.db();
    await db.update(_userTable, {_columnPassword: password},
        where: '$_columnEmail = ?', whereArgs: [email]);
  }

  //function edit profile
  static Future<int> updateUser(
      int id, String? firstname, String? lastname, String? email) async {
    final db = await SQLHelper.db();

    Map<String, dynamic> updateValues = {};

    if (firstname != null) {
      updateValues['firstname'] = firstname;
    }

    if (lastname != null) {
      updateValues['lastname'] = lastname;
    }

    if (email != null) {
      updateValues['email'] = email;
    }

    int result = await db.update(
      _userTable,
      updateValues,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }

  static Future<List<Map<String, Object?>>> getNotes(int userid) async {
    final db = await SQLHelper.db();
    final query = '''SELECT $_noteTable.$_columnId, 
        $_columnPriorityId, $_columnStatusId, $_columnCategoryId,
        $_noteTable.$_columnUserId, $_noteTable.$_columnName, 
        $_categoryTable.$_columnName as categoryName, 
        $_statusTable.$_columnName as statusName, 
        $_priorityTable.$_columnName as priorityName, 
        $_noteTable.$_columnPlanDate, $_noteTable.$_columnCreateAt  
        FROM $_noteTable, $_categoryTable, $_statusTable, 
        $_priorityTable WHERE $_noteTable.$_columnUserId = $userid 
        AND $_noteTable.$_columnCategoryId = 
        $_categoryTable.$_columnId AND $_noteTable.$_columnPriorityId 
        = $_priorityTable.$_columnId AND 
        $_noteTable.$_columnStatusId = $_statusTable.$_columnId''';
    return await db.rawQuery(query);
  }

  static Future<List<Map<String, Object?>>> getCategories(int userid) async {
    final db = await SQLHelper.db();
    return db.query(_categoryTable,
        where: '$_columnUserId = ?', whereArgs: [userid]);
  }

  static Future<List<Map<String, Object?>>> getPriorities(int userid) async {
    final db = await SQLHelper.db();
    return db.query(_priorityTable,
        where: '$_columnUserId = ?', whereArgs: [userid]);
  }

  static Future<List<Map<String, Object?>>> getStatus(int userid) async {
    final db = await SQLHelper.db();
    return db
        .query(_statusTable, where: '$_columnUserId = ?', whereArgs: [userid]);
  }

  static Future<int> insertNote(Note note) async {
    final db = await SQLHelper.db();
    return db.insert(_noteTable, note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteNote(int noteId) async {
    final db = await SQLHelper.db();
    return db.delete(_noteTable, where: '$_columnId = ?', whereArgs: [noteId]);
  }

  static Future<int> updateNote(Note note) async {
    final db = await SQLHelper.db();
    return db.update(_noteTable, note.toMap(),
        where: '$_columnId = ?', whereArgs: [note.id]);
  }

  static Future<bool> checkDuplicateNote(String name) async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> data = await db
        .query(_noteTable, where: '$_columnName = ?', whereArgs: [name]);

    return data.isEmpty;
  }

  static Future<int> insertCategory(Category category) async {
    final db = await SQLHelper.db();
    return db.insert(_categoryTable, category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateCategory(Category category) async {
    final db = await SQLHelper.db();
    return db.update(_categoryTable, category.toMap(),
        where: '$_columnId = ?', whereArgs: [category.id]);
  }

  static Future<int> deleteCategory(int? id) async{
    final db = await SQLHelper.db();
    return db.delete(_categoryTable, where: '$_columnId = ?', whereArgs: [id]);
  }

  static Future<bool> checkDuplicateCategory(String name, int id, int userId) async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> data = await db
        .query(_categoryTable,
        where: '''$_columnName = ? 
        AND $_columnId != ?
        AND $_columnUserId = ?''',
        whereArgs: [name, id, userId]);

    return data.isNotEmpty;
  }

  static Future<bool> checkCategoryInNote(int id) async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> data = await db
        .query(_noteTable, where: '$_columnCategoryId = ?', whereArgs: [id]);
    return data.isNotEmpty;
  }

  static Future<int> insertPriority(Priority priority) async {
    final db = await SQLHelper.db();
    return db.insert(_priorityTable, priority.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updatePriority(Priority priority) async {
    final db = await SQLHelper.db();
    return db.update(_priorityTable, priority.toMap(),
        where: '$_columnId = ?', whereArgs: [priority.id]);
  }

  static Future<int> deletePriority(int? id) async{
    final db = await SQLHelper.db();
    return db.delete(_priorityTable, where: '$_columnId = ?', whereArgs: [id]);
  }

  static Future<bool> checkDuplicatePriority(String name, int id, int userId) async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> data = await db
        .query(_priorityTable,
        where: '''$_columnName = ? 
        AND $_columnId != ?
        AND $_columnUserId = ?''',
        whereArgs: [name, id, userId]);

    return data.isNotEmpty;
  }

  static Future<bool> checkPriorityInNote(int id) async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> data = await db
        .query(_noteTable, where: '$_columnPriorityId = ?', whereArgs: [id]);
    return data.isNotEmpty;
  }

  static Future<int> insertStatus(Status status) async {
    final db = await SQLHelper.db();
    return db.insert(_statusTable, status.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateStatus(Status status) async {
    final db = await SQLHelper.db();
    return db.update(_statusTable, status.toMap(),
        where: '$_columnId = ?', whereArgs: [status.id]);
  }

  static Future<int> deleteStatus(int? id) async{
    final db = await SQLHelper.db();
    return db.delete(_statusTable, where: '$_columnId = ?', whereArgs: [id]);
  }

  static Future<bool> checkDuplicateStatus(String name, int id, int userId) async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> data = await db
        .query(_statusTable,
        where: '''$_columnName = ? 
        AND $_columnId != ?
        AND $_columnUserId = ?''',
        whereArgs: [name, id, userId]);

    return data.isNotEmpty;
  }

  static Future<bool> checkStatusInNote(int id) async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> data = await db
        .query(_noteTable, where: '$_columnStatusId = ?', whereArgs: [id]);
    return data.isNotEmpty;
  }
}
