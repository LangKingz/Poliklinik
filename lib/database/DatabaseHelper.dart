import 'package:poliklinik/model/Antrian.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'antrian_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE antrian(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            namaPasien TEXT,
            tanggal TEXT,
            nomorAntrian INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertAntrian(Antrian antrian) async {
    final db = await database;
    return await db.insert('antrian', antrian.toMap());
  }

  Future<List<Antrian>> getAntrianList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('antrian');

    return List.generate(maps.length, (i) {
      return Antrian(
        id: maps[i]['id'],
        namaPasien: maps[i]['namaPasien'],
        tanggal: maps[i]['tanggal'],
        nomorAntrian: maps[i]['nomorAntrian'],
      );
    });
  }

  Future<int> updateAntrian(Antrian antrian) async {
    final db = await database;
    return await db.update(
      'antrian',
      antrian.toMap(),
      where: 'id = ?',
      whereArgs: [antrian.id],
    );
  }

  Future<int> deleteAntrian(int id) async {
    final db = await database;
    return await db.delete(
      'antrian',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
