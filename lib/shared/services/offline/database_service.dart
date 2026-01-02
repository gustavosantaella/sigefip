import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'nexo_finance.db');
    return await openDatabase(
      path,
      version: 6,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE accounts (
        id TEXT PRIMARY KEY,
        name TEXT,
        balance REAL,
        currency TEXT,
        icon INTEGER,
        fontFamily TEXT,
        fontPackage TEXT,
        color INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT,
        icon INTEGER,
        color INTEGER,
        type TEXT,
        isDefault INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        title TEXT,
        amount REAL,
        date TEXT,
        category TEXT,
        account TEXT,
        isExpense INTEGER,
        icon INTEGER,
        color INTEGER,
        conversionRate REAL,
        note TEXT,
        imagePath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE budgets (
        id TEXT PRIMARY KEY,
        title TEXT,
        amount REAL,
        category TEXT,
        type TEXT,
        concurrency TEXT,
        cutoffDay INTEGER,
        note TEXT,
        icon INTEGER,
        color INTEGER,
        startDate TEXT,
        endDate TEXT,
        status TEXT DEFAULT "active",
        executedAmount REAL DEFAULT 0.0
      )
    ''');

    await db.execute('''
      CREATE TABLE alerts (
        id TEXT PRIMARY KEY,
        category TEXT,
        account TEXT,
        maxAmount REAL,
        period TEXT,
        cutoffDay INTEGER,
        icon INTEGER,
        color INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS budgets (
          id TEXT PRIMARY KEY,
          title TEXT,
          amount REAL,
          category TEXT,
          type TEXT,
          concurrency TEXT,
          cutoffDay INTEGER,
          note TEXT,
          icon INTEGER,
          color INTEGER,
          startDate TEXT,
          endDate TEXT,
          status TEXT DEFAULT "active",
          executedAmount REAL DEFAULT 0.0
        )
      ''');
    } else if (oldVersion == 2 && newVersion >= 3) {
      // Only add status column if upgrading from version 2 to 3
      await db.execute(
        'ALTER TABLE budgets ADD COLUMN status TEXT DEFAULT "active"',
      );
    }

    if (oldVersion < 4) {
      // Add executedAmount column for version 4
      await db.execute(
        'ALTER TABLE budgets ADD COLUMN executedAmount REAL DEFAULT 0.0',
      );
    }

    if (oldVersion < 5) {
      // Add alerts table for version 5
      await db.execute('''
        CREATE TABLE IF NOT EXISTS alerts (
          id TEXT PRIMARY KEY,
          category TEXT,
          account TEXT,
          maxAmount REAL,
          period TEXT,
          cutoffDay INTEGER,
          icon INTEGER,
          color INTEGER
        )
      ''');
    }

    if (oldVersion < 6) {
      // Add account column to alerts for version 6
      await db.execute('ALTER TABLE alerts ADD COLUMN account TEXT DEFAULT ""');
    }
  }
}
