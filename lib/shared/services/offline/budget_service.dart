import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../models/budget_model.dart';
import 'database_service.dart';

class BudgetService {
  static const String _tableName = 'budgets';

  // Create
  static Future<void> createBudget(Budget budget) async {
    final db = await DatabaseService.instance.database;
    await db.insert(
      _tableName,
      budget.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read All
  static Future<List<Budget>> getBudgets() async {
    final db = await DatabaseService.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    List<Budget> budgets = List.generate(maps.length, (i) {
      return Budget.fromMap(maps[i]);
    });

    return budgets;
  }

  // Read One
  static Future<Budget?> getBudgetById(String id) async {
    final db = await DatabaseService.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      var budget = Budget.fromMap(maps.first);
      return budget;
    }
    return null;
  }

  // Update
  static Future<void> updateBudget(Budget budget) async {
    final db = await DatabaseService.instance.database;
    await db.update(
      _tableName,
      budget.toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  // Delete
  static Future<void> deleteBudget(String id) async {
    final db = await DatabaseService.instance.database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> completeAndCloneBudget(
    Budget budget, {
    double? executedAmount,
  }) async {
    // 1. Mark current as completed
    final completedBudget = Budget(
      id: budget.id,
      title: budget.title,
      amount: budget.amount,
      category: budget.category,
      type: budget.type,
      concurrency: budget.concurrency,
      cutoffDay: budget.cutoffDay,
      note: budget.note,
      icon: budget.icon,
      color: budget.color,
      startDate: budget.startDate,
      endDate: budget.endDate,
      status: 'completed',
      executedAmount: executedAmount ?? budget.amount,
    );
    await updateBudget(completedBudget);

    // 2. Create new active clone
    final newBudget = Budget(
      id: const Uuid().v4(),
      title: budget.title,
      amount: budget.amount,
      category: budget.category,
      type: budget.type,
      concurrency: budget.concurrency,
      cutoffDay: budget.cutoffDay,
      note: budget.note,
      icon: budget.icon,
      color: budget.color,
      startDate: budget.startDate,
      endDate: budget.endDate,
      status: 'active',
    );

    await createBudget(newBudget);
  }
}
