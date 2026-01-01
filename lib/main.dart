import 'package:flutter/material.dart';
import 'package:sigefip/modules/screens/accounts/accounts_screen.dart';
import 'package:sigefip/modules/screens/budget/budget_screen.dart';
import 'package:sigefip/modules/screens/calendar/calendar_screen.dart';
import 'package:sigefip/modules/screens/categories/categories_screen.dart';
import 'package:sigefip/modules/screens/metrics/metrics_screen.dart';
import 'package:sigefip/modules/screens/home/home_screen.dart';
import 'package:sigefip/modules/screens/new_user/onboarding_screen.dart';
import 'package:sigefip/core/constants/theme.dart' as constants;
import 'package:sigefip/modules/screens/transaction/transactions_screen.dart';
import 'package:sigefip/shared/services/offline/storage_service.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);

  final String? onboardingCompleted = await StorageService.instance.read(
    'onboarding_completed',
  );
  final bool showOnboarding = onboardingCompleted != 'true';

  runApp(MyApp(showOnboarding: showOnboarding));
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;
  const MyApp({super.key, required this.showOnboarding});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIGEFIP',
      theme: constants.Theme.getTheme(),
      initialRoute: showOnboarding ? '/onboarding' : '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
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
