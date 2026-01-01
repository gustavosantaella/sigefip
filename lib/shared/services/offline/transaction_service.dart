import 'package:sigefip/shared/models/category_model.dart';
import 'package:sigefip/shared/models/transaction_model.dart';
import 'package:sigefip/shared/services/offline/category_service.dart';
import 'package:sigefip/shared/services/offline/storage_service.dart';
import 'package:sigefip/shared/notifiers/data_sync_notifier.dart';
import 'package:sigefip/shared/services/offline/account_service.dart';

class TransactionService {
  static final StorageService storageService = StorageService.instance;

  static Future<void> store(Transaction transaction) async {
    transaction.id = DateTime.now().millisecondsSinceEpoch.toString();
    Category category = await CategoryService.getByName(transaction.category);
    transaction.icon = category.icon;
    transaction.color = category.color;

    await storageService.pushToArray("transactions", transaction.toMap());

    // Update account balance
    await AccountService.updateAccountBalance(
      transaction.account,
      transaction.amount,
      transaction.isExpense,
      conversionRate: transaction.conversionRate,
    );

    dataSyncNotifier.notifyTransactionChange();
  }

  static Future<List<Transaction>> getTransactions() async {
    return await storageService.getTypedArray<Transaction>(
      "transactions",
      (json) => Transaction.fromMap(json),
    );
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
