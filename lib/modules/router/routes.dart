import 'package:flutter/material.dart';
import '../screens/home/widgets/home_dashboard.dart';
import '../screens/transaction/transactions_screen.dart';
import '../screens/accounts/accounts_screen.dart';

class AppRoute {
  final String title;
  final IconData icon;
  final Widget screen;

  const AppRoute({
    required this.title,
    required this.icon,
    required this.screen,
  });
}

class MainRouter {
  static final List<AppRoute> routes = [
    AppRoute(
      title: 'Inicio',
      icon: Icons.grid_view,
      screen: const HomeDashboard(),
    ),
    const AppRoute(
      title: 'Cuentas',
      icon: Icons.account_balance_wallet_outlined,
      screen: AccountsScreen(),
    ),
    const AppRoute(
      title: 'Transacciones',
      icon: Icons.receipt_long_outlined,
      screen: TransactionsScreen(),
    ),
  ];
}
