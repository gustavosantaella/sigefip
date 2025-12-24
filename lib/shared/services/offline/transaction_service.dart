import 'package:sigefip/shared/models/category_model.dart';
import 'package:sigefip/shared/models/transaction_model.dart';
import 'package:sigefip/shared/services/offline/category_service.dart';
import 'package:sigefip/shared/services/storage_service.dart';

class TransactionService {
  static final StorageService storageService = StorageService.instance;

  static Future<void> store(Transaction transaction) async {
    transaction.id = DateTime.now().millisecondsSinceEpoch.toString();
    Category category = await CategoryService.getByName(transaction.category);
    transaction.icon = category.icon;
    transaction.color = category.color;

    await storageService.pushToArray("transactions", transaction.toMap());
  }

  static Future<List<Transaction>> getTransactions() async {
    return await storageService.getTypedArray<Transaction>(
      "transactions",
      (json) => Transaction.fromMap(json),
    );
  }
}
