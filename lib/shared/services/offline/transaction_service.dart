import 'package:nexo_finance/shared/models/category_model.dart';
import 'package:nexo_finance/shared/models/transaction_model.dart';
import 'package:nexo_finance/shared/services/offline/category_service.dart';
import 'package:nexo_finance/shared/services/offline/storage_service.dart';
import 'package:nexo_finance/shared/services/offline/database_service.dart'; // Added for direct DB access
import 'package:nexo_finance/shared/notifiers/data_sync_notifier.dart';
import 'package:nexo_finance/shared/services/offline/account_service.dart';
import 'package:nexo_finance/shared/services/offline/alert_service.dart';

class TransactionService {
  static final StorageService storageService = StorageService.instance;

  static Future<void> store(Transaction transaction) async {
    transaction.id = DateTime.now().millisecondsSinceEpoch.toString();
    Category? category = await CategoryService.getByName(transaction.category);
    if (category != null) {
      transaction.icon = category.icon;
      transaction.color = category.color;
    }

    await storageService.pushToArray("transactions", transaction.toMap());

    // Update account balance
    await AccountService.updateAccountBalance(
      transaction.account,
      transaction.amount,
      transaction.isExpense,
      conversionRate: transaction.conversionRate,
    );

    dataSyncNotifier.notifyTransactionChange();

    // Check alerts
    try {
      print('CHECKING_ALERTS: Triggered from TransactionService');
      await AlertService.checkAlerts();
    } catch (e) {
      print('CHECKING_ALERTS ERROR: $e');
    }
  }

  static Future<List<Transaction>> getTransactions() async {
    final db = await DatabaseService.instance.database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT t.*, a.currency as currencySymbol
      FROM transactions t
      LEFT JOIN accounts a ON t.account = a.name
    ''');

    return results.map((map) {
      final Map<String, dynamic> mutableMap = Map.from(map);
      mutableMap['isExpense'] = mutableMap['isExpense'] == 1;
      return Transaction.fromMap(mutableMap);
    }).toList();
  }

  static Future<void> delete(String? id) async {
    if (id == null) return;

    // Fetch transaction to get account and amount for balance reversal
    final transactions = await getTransactions();
    final transaction = transactions.firstWhere((t) => t.id == id);

    await storageService.removeFromArray("transactions", id);

    // Reverse account balance update
    await AccountService.updateAccountBalance(
      transaction.account,
      transaction.amount,
      transaction.isExpense,
      isUndo: true,
      conversionRate: transaction.conversionRate,
    );
    dataSyncNotifier.notifyTransactionChange();
  }
}
