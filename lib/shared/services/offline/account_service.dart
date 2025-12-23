import 'package:sigefip/shared/models/account_model.dart';
import 'package:sigefip/shared/services/storage_service.dart';

class AccountService {
  final StorageService storageService = StorageService.instance;

  Future<void> storeAccount(Account account) async {
    await storageService.pushToArray("accounts", account.toMap());
  }

  Future<List<Account>> getAccounts() async {
    return await storageService.getTypedArray<Account>(
      "accounts",
      (json) => Account.fromMap(json),
    );
  }
}
