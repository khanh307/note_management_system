import 'package:flutter/material.dart';
import 'package:note_manangement_system/Model/user_model.dart';
import 'package:note_manangement_system/model/status_model.dart';
import 'package:sqflite/sqflite.dart';
import '../model/journal_model.dart';

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

//  priority
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

  //function check login
  static Future<List<Map<String, dynamic>>> getUser(
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
  static Future<bool> addAccount(String email, String password) async {
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

  static Future<int> createItem(JournalModel journal) async {
    final db = await SQLHelper.db();
    final id = await db.insert(_categoryTable, journal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query(_categoryTable, orderBy: "id");
  }

  static Future<int> updateItem(JournalModel journal) async {
    final db = await SQLHelper.db();

    final result = await db.update(_categoryTable, journal.toMap(),
        where: "id = ?", whereArgs: [journal.id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(_categoryTable, where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint('Something went wrong when deleting an item: $err');
    }
  }

  static Future<int> createItem2(StatusModel status) async {
    final db = await SQLHelper.db();
    final id = await db.insert(_statusTable, status.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems2() async {
    final db = await SQLHelper.db();
    return db.query(_statusTable, orderBy: "id");
  }

  static Future<int> updateItem2(StatusModel status) async {
    final db = await SQLHelper.db();

    final result = await db.update(_statusTable, status.toMap(),
        where: "id = ?", whereArgs: [status.id]);
    return result;
  }

  static Future<void> deleteItem2(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(_statusTable, where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint('Something went wrong when deleting an item: $err');
    }
  }
}
