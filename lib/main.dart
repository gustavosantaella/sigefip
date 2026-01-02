import 'package:flutter/material.dart';
import 'package:nexo_finance/modules/screens/accounts/accounts_screen.dart';
import 'package:nexo_finance/modules/screens/alerts/alerts_screen.dart';
import 'package:nexo_finance/modules/screens/budget/budget_screen.dart';
import 'package:nexo_finance/modules/screens/calendar/calendar_screen.dart';
import 'package:nexo_finance/modules/screens/categories/categories_screen.dart';
import 'package:nexo_finance/modules/screens/metrics/metrics_screen.dart';
import 'package:nexo_finance/modules/screens/home/home_screen.dart';
import 'package:nexo_finance/modules/screens/new_user/onboarding_screen.dart';
import 'package:nexo_finance/core/constants/theme.dart' as constants;
import 'package:nexo_finance/modules/screens/transaction/transactions_screen.dart';
import 'package:nexo_finance/shared/services/offline/storage_service.dart';
import 'package:nexo_finance/shared/services/notification_service.dart';
import 'package:nexo_finance/modules/screens/profile/profile_screen.dart';
import 'package:nexo_finance/modules/screens/profile/personal_info_screen.dart';
import 'package:nexo_finance/modules/screens/settings/settings_screen.dart';
import 'package:nexo_finance/shared/services/ad_service.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('es_ES', null);
    await NotificationService.initialize();

    final adService = AdService();
    await adService.initialize();

    final String? onboardingCompleted = await StorageService.instance.read(
      'onboarding_completed',
    );
    final bool showOnboarding = onboardingCompleted != 'true';

    runApp(
      AppLifecycleObserver(
        adService: adService,
        child: MyApp(showOnboarding: showOnboarding),
      ),
    );
  } catch (e) {
    debugPrint('Error during initialization: $e');
    // Fallback in case of storage failure, assuming onboarding is needed or safe default
    runApp(const MyApp(showOnboarding: false));
  }
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;
  const MyApp({super.key, required this.showOnboarding});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexo Finance',
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
        '/alerts': (context) => const AlertsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/personal-info': (context) => const PersonalInfoScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

class AppLifecycleObserver extends StatefulWidget {
  final Widget child;
  final AdService adService;

  const AppLifecycleObserver({
    super.key,
    required this.child,
    required this.adService,
  });

  @override
  State<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<AppLifecycleObserver> {
  late AppLifecycleReactor _reactor;

  @override
  void initState() {
    super.initState();
    _reactor = AppLifecycleReactor(widget.adService);
    WidgetsBinding.instance.addObserver(_reactor);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_reactor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
