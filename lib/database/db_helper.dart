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
        // tabel users
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

        // tabel shopping list
        await db.execute('''
          CREATE TABLE shopping_list (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER NOT NULL,
            name TEXT,
            deskripsi TEXT,
            Toko TEXT,
            quantity INTEGER,
            isDone INTEGER,
            FOREIGN KEY (userId) REFERENCES users (id) 
              ON DELETE CASCADE 
              ON UPDATE CASCADE
          )
        ''');
      },
    );
  }
  //foreign u/ menghubungkan data antar tabel
  //on delete u/ hapus semua item yg terkait user
  //on update berfungsi jika id user diubah , mka akn otomatis berubah

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

  //u/ hal profile
  static Future<UserModel?> getUserById(int id) async {
    final db = await initDB();
    final List<Map<String, dynamic>> data = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (data.isNotEmpty) {
      return UserModel.fromMap(data.first);
    } else {
      return null;
    }
  }

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

  static Future<List<Map<String, dynamic>>> getAllItems() async {
    final db = await initDB();
    return db.query('shopping_list');
  }

  // u/ update item berdasarkan shopping list
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

  //u/ user bisa liat data sendiri
  static Future<List<Map<String, dynamic>>> getItemsByUser(int userId) async {
    final db = await initDB();
    return await db.query(
      'shopping_list',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  // u/ update user
  static Future<int> updateUserModel(UserModel user) async {
    final db = await initDB();
    return await db.update(
      'users',
      {
        'name': user.name, //pakai user karena menggunakn usermodel
        'username': user.username,
        'email': user.email,
        'phone': user.phone,
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}
