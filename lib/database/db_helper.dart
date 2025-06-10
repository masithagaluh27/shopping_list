import 'package:path/path.dart';
import 'package:shopping_list/models/users_model.dart';
import 'package:sqflite/sqflite.dart';

class DBHELPER13 {
  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tugas13flutter.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tabel user
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            username TEXT,
            email TEXT,
            phone TEXT,
            password TEXT
          )
        ''');

        // Tabel shopping list
        await db.execute('''
          CREATE TABLE shopping_list (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            quantity INTEGER,
            isDone INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> registerUser({UserModel? data}) async {
    final db = await initDB();

    await db.insert('users', {
      'name': data?.name,
      'username': data?.username,
      'email': data?.email,
      'phone': data?.phone,
      'password': data?.password,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    print('User registered successfully');
  }

  static Future<UserModel?> login(String email, String password) async {
    final db = await initDB();

    final List<Map<String, dynamic>> data = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (data.isNotEmpty) {
      return UserModel.fromMap(data.first);
    } else {
      return null;
    }
  }

  //shopping list

  static Future<void> insertItem(String name, int quantity) async {
    final db = await initDB();

    await db.insert('shopping_list', {
      'name': name,
      'quantity': quantity,
      'isDone': 0,
    });
  }

  static Future<List<Map<String, dynamic>>> getAllItems() async {
    final db = await initDB();
    return db.query('shopping_list');
  }

  static Future<void> updateItem(
    int id,
    String name,
    int quantity,
    bool isDone,
  ) async {
    final db = await initDB();

    await db.update(
      'shopping_list',
      {'name': name, 'quantity': quantity, 'isDone': isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteItem(int id) async {
    final db = await initDB();

    await db.delete('shopping_list', where: 'id = ?', whereArgs: [id]);
  }
}
