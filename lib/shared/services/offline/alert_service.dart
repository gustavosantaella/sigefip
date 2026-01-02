import 'package:sqflite/sqflite.dart';
import '../../services/offline/transaction_service.dart';
import '../../services/notification_service.dart';
import 'database_service.dart';
import '../../models/alert_model.dart';

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

  // Check alerts and trigger notifications
  static Future<void> checkAlerts() async {
    print('Checking alerts...');
    final alerts = await getAlerts();
    print('Found ${alerts.length} alerts');

    for (var alert in alerts) {
      final spent = await _calculateSpentAmount(alert);
      final percentage = spent / alert.maxAmount;
      print(
        'Alert: ${alert.category}, Spent: $spent, Max: ${alert.maxAmount}, %: $percentage',
      );

      if (percentage >= 0.5 && !alert.notified50) {
        await NotificationService.showNotification(
          id: alert.id.hashCode + 50,
          title: 'Alerta de Presupuesto',
          body: 'Has alcanzado el 50% de tu presupuesto en ${alert.category}',
        );
        await updateAlert(
          Alert(
            id: alert.id,
            category: alert.category,
            account: alert.account,
            maxAmount: alert.maxAmount,
            period: alert.period,
            cutoffDay: alert.cutoffDay,
            icon: alert.icon,
            color: alert.color,
            notified50: true,
            notified80: alert.notified80,
            notified100: alert.notified100,
          ),
        );
      } else if (percentage >= 0.8 && !alert.notified80) {
        await NotificationService.showNotification(
          id: alert.id.hashCode + 80,
          title: 'Alerta de Presupuesto',
          body: 'Has alcanzado el 80% de tu presupuesto en ${alert.category}',
        );
        await updateAlert(
          Alert(
            id: alert.id,
            category: alert.category,
            account: alert.account,
            maxAmount: alert.maxAmount,
            period: alert.period,
            cutoffDay: alert.cutoffDay,
            icon: alert.icon,
            color: alert.color,
            notified50: true,
            notified80: true,
            notified100: alert.notified100,
          ),
        );
      } else if (percentage >= 1.0 && !alert.notified100) {
        await NotificationService.showNotification(
          id: alert.id.hashCode + 100,
          title: 'Presupuesto Excedido',
          body: 'Has alcanzado el 100% de tu presupuesto en ${alert.category}',
        );
        await updateAlert(
          Alert(
            id: alert.id,
            category: alert.category,
            account: alert.account,
            maxAmount: alert.maxAmount,
            period: alert.period,
            cutoffDay: alert.cutoffDay,
            icon: alert.icon,
            color: alert.color,
            notified50: true,
            notified80: true,
            notified100: true,
          ),
        );
      }
    }
  }

  static Future<double> _calculateSpentAmount(Alert alert) async {
    final transactions = await TransactionService.getTransactions();
    final now = DateTime.now();

    DateTime startDate;
    DateTime endDate = now;

    if (alert.period == 'Mensual') {
      int year = now.year;
      int month = now.month;

      if (now.day >= alert.cutoffDay) {
        startDate = DateTime(year, month, alert.cutoffDay);
      } else {
        month = month - 1;
        if (month == 0) {
          month = 12;
          year = year - 1;
        }
        startDate = DateTime(year, month, alert.cutoffDay);
      }
    } else {
      int year = now.year;
      int month = now.month;

      if (month > 1 || (month == 1 && now.day >= alert.cutoffDay)) {
        startDate = DateTime(year, 1, alert.cutoffDay);
      } else {
        startDate = DateTime(year - 1, 1, alert.cutoffDay);
      }
    }

    double total = 0;
    for (var transaction in transactions) {
      if (transaction.category == alert.category &&
          transaction.account == alert.account &&
          transaction.isExpense &&
          transaction.date.isAfter(startDate) &&
          transaction.date.isBefore(endDate.add(const Duration(days: 1)))) {
        total += transaction.amount;
      }
    }

    return total;
  }
}
