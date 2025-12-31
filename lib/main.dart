import 'package:flutter/material.dart';
import 'package:sigefip/modules/screens/accounts/accounts_screen.dart';
import 'package:sigefip/modules/screens/budget/budget_screen.dart';
import 'package:sigefip/modules/screens/calendar/calendar_screen.dart';
import 'package:sigefip/modules/screens/categories/categories_screen.dart';
import 'package:sigefip/modules/screens/metrics/metrics_screen.dart';
import 'package:sigefip/modules/screens/home/home_screen.dart';
import 'package:sigefip/core/constants/theme.dart' as constants;
import 'package:sigefip/modules/screens/transaction/transactions_screen.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIGEFIP',
      theme: constants.Theme.getTheme(),
      routes: {
        '/': (context) => const HomeScreen(),
        '/budget': (context) => const BudgetScreen(),
        '/accounts': (context) => const AccountsScreen(),
        '/transactions': (context) => const TransactionsScreen(),
        '/categories': (context) => const CategoriesScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/metrics': (context) => const MetricsScreen(),
      },
    );
  }
}
