import 'package:sigefip/shared/models/transaction_model.dart';
import 'package:sigefip/shared/models/account_model.dart';
import 'package:sigefip/shared/models/category_model.dart';
import 'package:sigefip/shared/services/offline/account_service.dart';
import 'package:sigefip/shared/services/offline/category_service.dart';

class TransactionParserService {
  static Future<Transaction?> parseVoiceText(String text) async {
    final lowerText = text.toLowerCase();

    // 1. Detect Amount
    final amountRegex = RegExp(r'(\d+([.,]\d+)?)');
    final amountMatch = amountRegex.firstMatch(lowerText);
    if (amountMatch == null) return null;

    double amount = double.parse(amountMatch.group(1)!.replaceAll(',', '.'));

    // 2. Detect Transaction Type (Expense vs Income)
    bool isExpense = true;
    final incomeKeywords = [
      'recibí',
      'ingresé',
      'gané',
      'deposito',
      'recibi',
      'ingrese',
      'gane',
    ];
    for (var keyword in incomeKeywords) {
      if (lowerText.contains(keyword)) {
        isExpense = false;
        break;
      }
    }

    // 3. Detect Account
    final accounts = await AccountService.getAccounts();
    Account? matchedAccount;
    for (var account in accounts) {
      if (lowerText.contains(account.name.toLowerCase())) {
        matchedAccount = account;
        break;
      }
    }

    // 4. Detect Category
    final categories = await CategoryService.getCategories();
    Category? matchedCategory;
    for (var category in categories) {
      if (lowerText.contains(category.name.toLowerCase())) {
        matchedCategory = category;
        break;
      }
    }

    // Fallbacks
    final finalAccount =
        matchedAccount?.name ??
        (accounts.isNotEmpty ? accounts.first.name : 'Efectivo');
    final finalCategory = matchedCategory?.name ?? 'Otros';

    return Transaction(
      title: text, // Use the original recognized text as title
      amount: amount,
      category: finalCategory,
      account: finalAccount,
      isExpense: isExpense,
      date: DateTime.now(),
      note: 'Creado por voz',
    );
  }
}
