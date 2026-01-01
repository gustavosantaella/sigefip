import 'package:nexo_finance/shared/services/offline/database_service.dart';
import 'package:sqflite/sqflite.dart';

class StorageService {
  StorageService._privateConstructor();
  static final StorageService _instance = StorageService._privateConstructor();
  static StorageService get instance => _instance;

  final DatabaseService _dbService = DatabaseService.instance;

  Future<void> write(String key, String value) async {
    final db = await _dbService.database;
    await db.insert('settings', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> read(String key) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (maps.isEmpty) return null;
    return maps.first['value'] as String?;
  }

  Future<void> pushToArray(String key, Map<String, dynamic> item) async {
    final db = await _dbService.database;
    final String table = _mapTable(key);

    // Convert bool to int for SQLite
    final Map<String, dynamic> mappedItem = Map.from(item);
    mappedItem.forEach((k, v) {
      if (v is bool) {
        mappedItem[k] = v ? 1 : 0;
      }
    });

    await db.insert(
      table,
      mappedItem,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<T>> getTypedArray<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final db = await _dbService.database;
    final String table = _mapTable(key);
    final List<Map<String, dynamic>> maps = await db.query(table);

    return maps.map((map) {
      // Convert int back to bool for models
      final Map<String, dynamic> mutableMap = Map.from(map);
      if (key == 'categories') {
        mutableMap['isDefault'] = mutableMap['isDefault'] == 1;
      } else if (key == 'transactions') {
        mutableMap['isExpense'] = mutableMap['isExpense'] == 1;
      }
      return fromJson(mutableMap);
    }).toList();
  }

  Future<void> removeFromArray(String key, String id) async {
    final db = await _dbService.database;
    final String table = _mapTable(key);
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateItem(String key, Map<String, dynamic> item) async {
    final db = await _dbService.database;
    final String table = _mapTable(key);

    final Map<String, dynamic> mappedItem = Map.from(item);
    mappedItem.forEach((k, v) {
      if (v is bool) {
        mappedItem[k] = v ? 1 : 0;
      }
    });

    await db.update(
      table,
      mappedItem,
      where: 'id = ?',
      whereArgs: [mappedItem['id']],
    );
  }

  Future<void> delete(String key) async {
    final db = await _dbService.database;
    await db.delete('settings', where: 'key = ?', whereArgs: [key]);
  }

  Future<void> deleteAll() async {
    final db = await _dbService.database;
    await db.delete('settings');
    await db.delete('accounts');
    await db.delete('categories');
    await db.delete('transactions');
  }

  String _mapTable(String key) {
    switch (key) {
      case 'accounts':
        return 'accounts';
      case 'categories':
        return 'categories';
      case 'transactions':
        return 'transactions';
      default:
        throw Exception("Unknown table for key: $key");
    }
  }
}
