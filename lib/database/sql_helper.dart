
import 'package:note_manangement_system/Model/userModel.dart';
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

//  category
  static const _categoryTable = "category";

//  prority
  static const _priorityTable = "priority";

//  status
  static const _statusTable = "status";

//  note
  static const _noteTable = "note";
  static const _columnPlanDate = "planDate";
  static const _columnCaterotyId = "categoryId";
  static const _columnPriorityId = "priorityId";
  static const _columnStatusId = "statusId";

  static Future<void> createUserTable(Database database) async {
    await database.execute('''CREATE TABLE $_userTable(
    $_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $_columnEmail TEXT,
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
    $_columnCaterotyId INTEGER,
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

 
}

