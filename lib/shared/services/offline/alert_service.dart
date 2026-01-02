import 'package:sqflite/sqflite.dart';
import '../../models/alert_model.dart';
import 'database_service.dart';

class AlertService {
  static const String _tableName = 'alerts';

  // Create
  static Future<void> createAlert(Alert alert) async {
    final db = await DatabaseService.instance.database;
    await db.insert(
      _tableName,
      alert.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read All
  static Future<List<Alert>> getAlerts() async {
    final db = await DatabaseService.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Alert.fromMap(maps[i]);
    });
  }

  // Read One
  static Future<Alert?> getAlertById(String id) async {
    final db = await DatabaseService.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Alert.fromMap(maps.first);
    }
    return null;
  }

  // Update
  static Future<void> updateAlert(Alert alert) async {
    final db = await DatabaseService.instance.database;
    await db.update(
      _tableName,
      alert.toMap(),
      where: 'id = ?',
      whereArgs: [alert.id],
    );
  }

  // Delete
  static Future<void> deleteAlert(String id) async {
    final db = await DatabaseService.instance.database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
