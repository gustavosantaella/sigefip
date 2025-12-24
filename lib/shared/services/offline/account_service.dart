import 'package:flutter/material.dart';
import 'package:sigefip/shared/models/account_model.dart';
import 'package:sigefip/shared/services/storage_service.dart';

class AccountService {
  static final StorageService _storageService = StorageService.instance;
  static const String _key = "accounts";

  static Future<void> storeAccount(Account account) async {
    account.id = DateTime.now().millisecondsSinceEpoch.toString();
    account.name = account.name.trim().toUpperCase();
    await _storageService.pushToArray(_key, account.toMap());
  }

  static Future<List<Account>> getAccounts() async {
    List<Account> accounts = await _storageService.getTypedArray<Account>(
      _key,
      (json) => Account.fromMap(json),
    );

    if (accounts.isEmpty) {
      await _seedAccounts();
      accounts = await getAccounts();
    }

    return accounts;
  }

  static Future<void> _seedAccounts() async {
    final defaultAccount = Account(
      name: 'CUENTA PRINCIPAL',
      balance: 0.0,
      currency: 'USD',
      icon: Icons.account_balance_wallet,
      color: const Color(0xFF6C63FF),
    );
    await storeAccount(defaultAccount);
  }
}
