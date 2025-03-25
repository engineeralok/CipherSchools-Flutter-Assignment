import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'expense_tracker.db');
    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        subtitle TEXT,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        imagePath TEXT,
        iconData INTEGER,
        iconBackgroundColor INTEGER NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE transactions ADD COLUMN note TEXT');
    }
    if (oldVersion < 3) {
      var tableInfo = await db.rawQuery("PRAGMA table_info(transactions)");
      bool noteColumnExists = tableInfo.any(
        (column) => column['name'] == 'note',
      );
      bool imagePathColumnExists = tableInfo.any(
        (column) => column['name'] == 'imagePath',
      );
      bool iconDataColumnExists = tableInfo.any(
        (column) => column['name'] == 'iconData',
      );

      await db.execute('''
        CREATE TABLE transactions_temp (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          subtitle TEXT,
          amount REAL NOT NULL,
          type TEXT NOT NULL,
          category TEXT NOT NULL,
          imagePath TEXT,
          iconData INTEGER,
          iconBackgroundColor INTEGER NOT NULL,
          timestamp INTEGER NOT NULL,
          note TEXT
        )
      ''');

      String insertColumns =
          'id, title, subtitle, amount, type, category, iconBackgroundColor, timestamp';
      String selectColumns =
          'id, title, subtitle, amount, type, category, iconBackgroundColor, timestamp';

      if (noteColumnExists) {
        insertColumns += ', note';
        selectColumns += ', note';
      }

      if (imagePathColumnExists) {
        insertColumns += ', imagePath';
        selectColumns += ', imagePath';
      }

      if (iconDataColumnExists) {
        insertColumns += ', iconData';
        selectColumns += ', iconData';
      }

      await db.execute('''
        INSERT INTO transactions_temp ($insertColumns)
        SELECT $selectColumns FROM transactions
      ''');

      await db.execute('DROP TABLE transactions');

      await db.execute('ALTER TABLE transactions_temp RENAME TO transactions');
    }
  }

  Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    Database db = await database;
    return await db.insert('transactions', transaction);
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    Database db = await database;
    return await db.query('transactions', orderBy: 'timestamp DESC');
  }

  Future<double> getTotalIncome() async {
    Database db = await database;
    var result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE type = ?',
      ['income'],
    );
    return (result.isNotEmpty && result.first['total'] != null)
        ? result.first['total'] as double
        : 0.0;
  }

  Future<double> getTotalExpense() async {
    Database db = await database;
    var result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE type = ?',
      ['expense'],
    );
    return (result.isNotEmpty && result.first['total'] != null)
        ? result.first['total'] as double
        : 0.0;
  }

  Future<int> deleteTransaction(String id) async {
    Database db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllTransactions() async {
    Database db = await database;
    return await db.delete('transactions');
  }
}
