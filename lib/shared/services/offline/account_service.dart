import 'package:flutter/material.dart';
import 'package:nexo_finance/shared/notifiers/data_sync_notifier.dart';
import 'package:nexo_finance/shared/models/account_model.dart';
import 'package:nexo_finance/shared/services/offline/storage_service.dart';

class AccountService {
  static final StorageService _storageService = StorageService.instance;
  static const String _key = "accounts";

  static Future<void> storeAccount(Account account) async {
    account.id = DateTime.now().millisecondsSinceEpoch.toString();
    account.name = account.name.trim().toUpperCase();
    await _storageService.pushToArray(_key, account.toMap());
    dataSyncNotifier.notifyAccountChange();
  }

  static Future<List<Account>> getAccounts() async {
    return await _storageService.getTypedArray<Account>(
      _key,
      (json) => Account.fromMap(json),
    );
  }

  static Future<void> deleteAccount(String? id) async {
    await _storageService.removeFromArray(_key, id!);
    dataSyncNotifier.notifyAccountChange();
  }

  static Future<void> updateAccountBalance(
    String accountName,
    double amount,
    bool isExpense, {
    bool isUndo = false,
    double conversionRate = 1.0,
  }) async {
    final List<Account> accounts = await getAccounts();
    final String targetName = accountName.trim().toUpperCase();

    try {
      final int index = accounts.indexWhere((a) => a.name == targetName);
      if (index != -1) {
        final account = accounts[index];
        double multiplier = isExpense ? -1.0 : 1.0;
        if (isUndo) multiplier *= -1.0;

        // Ensure conversionRate is valid (not 0 or negative)
        double rate = (conversionRate > 0) ? conversionRate : 1.0;
        double finalImpact = amount * multiplier * rate;

        debugPrint('--- [AccountService] Balance Sync Debug ---');
        debugPrint('Account: ${account.name}');
        debugPrint('Prev Balance: ${account.balance}');
        debugPrint('Trans Amount: $amount');
        debugPrint(
          'Multiplier: $multiplier (Expense: $isExpense, Undo: $isUndo)',
        );
        debugPrint('Rate applied: $rate');
        debugPrint('Final Impact: $finalImpact');

        account.balance += finalImpact;

        debugPrint('New Balance: ${account.balance}');
        debugPrint('-------------------------------------------');

        // Update only this account in the database
        await _storageService.updateItem(_key, account.toMap());
        dataSyncNotifier.notifyAccountChange();
      }
    } catch (e) {
      debugPrint('Error updating account balance: $e');
    }
  }

  static Future<String?> getDefaultAccountId() async {
    return await _storageService.read('default_account_id');
  }

  static Future<void> setDefaultAccountId(String accountId) async {
    await _storageService.write('default_account_id', accountId);
    dataSyncNotifier.notifyAccountChange();
  }

  static Future<Account?> getDefaultAccount() async {
    final String? defaultId = await getDefaultAccountId();
    if (defaultId == null) return null;

    final List<Account> accounts = await getAccounts();
    try {
      return accounts.firstWhere((account) => account.id == defaultId);
    } catch (e) {
      return null;
    }
  }
}
