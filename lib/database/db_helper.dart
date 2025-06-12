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
            userId INTEGER NOT NULL,
            name TEXT,
            deskripsi TEXT,
            Toko TEXT,
            quantity INTEGER,
            isDone INTEGER,
            FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE
          )
        ''');
      },
    );
  }

  static Future<int> registerUser({UserModel? data}) async {
    final db = await initDB();

    int id = await db.insert('users', {
      'name': data?.name,
      'username': data?.username,
      'email': data?.email,
      'phone': data?.phone,
      'password': data?.password,
    });

    print('User registered successfully with ID: $id');
    return id;
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

  /// New method to fetch a user by their ID.
  /// This will be used by the ProfileScreen to load specific user details.
  static Future<UserModel?> getUserById(int id) async {
    final db = await initDB();
    final List<Map<String, dynamic>> data = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1, // Only expect one user per ID
    );

    if (data.isNotEmpty) {
      return UserModel.fromMap(data.first);
    } else {
      return null;
    }
  }

  //shopping list

  static Future<void> insertItem(
    int userId,
    String name,
    String deskripsi,
    String toko,
    int quantity,
  ) async {
    final db = await initDB();

    await db.insert('shopping_list', {
      'userId': userId,
      'name': name,
      'deskripsi': deskripsi,
      'Toko': toko,
      'quantity': quantity,
      'isDone': 0,
    });
  }

  // IMPORTANT: getAllItems is kept, but getItemsByUser is preferred for specific user data.
  static Future<List<Map<String, dynamic>>> getAllItems() async {
    final db = await initDB();
    return db.query('shopping_list');
  }

  static Future<void> updateItem(
    int id,
    String name,
    String deskripsi,
    String toko,
    int quantity,
    int isDone,
  ) async {
    final db = await initDB();

    await db.update(
      'shopping_list',
      {
        'name': name,
        'deskripsi': deskripsi,
        'Toko': toko,
        'quantity': quantity,
        'isDone': isDone,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteItem(int id) async {
    final db = await initDB();

    await db.delete('shopping_list', where: 'id = ?', whereArgs: [id]);
  }

  // Get shopping list items by user ID
  static Future<List<Map<String, dynamic>>> getItemsByUser(int userId) async {
    final db = await initDB();
    return await db.query(
      'shopping_list',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
}
