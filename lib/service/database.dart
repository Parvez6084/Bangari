import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../data/location_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  final _streamController = StreamController<List<Location>>.broadcast();
  Timer? _timer;

  DatabaseHelper._init() {
    _startPolling();
  }



  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('locations.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const doubleType = 'REAL NOT NULL';
    await db.execute('''
CREATE TABLE locations (
  id $idType,
  latitude $doubleType,
  longitude $doubleType
)
''');
  }

  Future<Location> insertLocation(Location location) async {
    final db = await instance.database;
    final id = await db.insert('locations', location.toMap());
    return location.copy(id: id);
  }

  Future<List<Location>> fetchLocations() async {
    final db = await instance.database;
    final result = await db.query('locations', orderBy: 'id DESC');
    return result.map((json) => Location.fromJson(json)).toList();
  }

  Stream<List<Location>> get locationsStream => _streamController.stream;

  void _startPolling() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final locations = await fetchLocations();
      _streamController.add(locations);
    });
  }

  Stream<List<Location>> fetchLocationsStream() {
    return _streamController.stream;
  }

  void dispose() {
    _streamController.close();
    _timer?.cancel();
  }


  Future<void> deleteAllExceptLast10IfMoreThan10() async {
    final db = await DatabaseHelper.instance.database;

    final countResult = await db.rawQuery('SELECT COUNT(*) as count FROM locations');
    final int count = Sqflite.firstIntValue(countResult) ?? 0;
    if (count > 10) {
      final List<Map<String, dynamic>> idsToKeep = await db.rawQuery('''SELECT id FROM locations ORDER BY id DESC LIMIT 10''');

      final idList = idsToKeep.map((item) => item['id'] as int).toList();
      await db.delete('locations', where: 'id NOT IN (${idList.join(', ')})',);
    }
  }

}

