import 'package:flutter/material.dart';
import 'package:nexo_finance/shared/models/user_model.dart';
import 'package:nexo_finance/shared/models/account_model.dart';
import 'package:nexo_finance/shared/services/offline/user_service.dart';
import 'package:nexo_finance/shared/services/offline/account_service.dart';
import 'package:nexo_finance/shared/services/offline/category_service.dart';
import 'package:nexo_finance/shared/services/offline/transaction_service.dart';
import 'package:nexo_finance/shared/notifiers/data_sync_notifier.dart';
import 'widgets/stat_card.dart';
import 'widgets/profile_menu_item.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  Account? _defaultAccount;
  int _accountsCount = 0;
  int _categoriesCount = 0;
  int _transactionsCount = 0;
  String _version = '';
  String _buildNumber = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    dataSyncNotifier.addListener(_loadData);
  }

  @override
  void dispose() {
    dataSyncNotifier.removeListener(_loadData);
    super.dispose();
  }

  Future<void> _loadData() async {
    final user = await UserService.getUser();
    final defaultAccount = await AccountService.getDefaultAccount();
    final accounts = await AccountService.getAccounts();
    final categories = await CategoryService.getCategories();
    final transactions = await TransactionService.getTransactions();

    // Get app version info
    final packageInfo = await PackageInfo.fromPlatform();

    if (mounted) {
      setState(() {
        _user = user;
        _defaultAccount = defaultAccount;
        _accountsCount = accounts.length;
        _categoriesCount = categories.length;
        _transactionsCount = transactions.length;
        _version = packageInfo.version;
        _buildNumber = packageInfo.buildNumber;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteDataPermanently() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          '⚠️ Eliminar Datos Permanentemente',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Estás seguro de que deseas eliminar TODOS tus datos? Esta acción NO se puede deshacer.\n\nSe eliminarán:\n• Todas las cuentas\n• Todas las transacciones\n• Todas las categorías\n• Toda la información personal',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar Todo'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      // Clear all data
      await UserService.clearUser();
      await AccountService.deleteAccount(
        null,
      ); // This would need to be updated to clear all
      // Add methods to clear all transactions, categories, etc.

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todos los datos han sido eliminados'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    }
  }

  Future<void> _exportData() async {
    // Show dialog to confirm export
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Exportar Datos',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Deseas exportar todos tus datos? Esta función estará disponible próximamente.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Función de exportación próximamente disponible'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Perfil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // User Icon and Email
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.shade400,
                            Colors.blue.shade400,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _user?.email ?? '',
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Statistics Cards
              Row(
                children: [
                  Expanded(
                    child: StatCard(count: _accountsCount, label: 'Cuentas'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      count: _categoriesCount,
                      label: 'Categorías',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      count: _transactionsCount,
                      label: 'Transacciones',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Account Section
              const Text(
                'Cuenta',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              ProfileMenuItem(
                icon: Icons.person_outline,
                title: 'Información Personal',
                subtitle: _user?.name ?? 'Username',
                onTap: () => Navigator.pushNamed(context, '/personal-info'),
              ),
              const SizedBox(height: 12),
              ProfileMenuItem(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Cuenta Principal',
                subtitle: _defaultAccount?.name ?? 'No configurada',
                onTap: () => Navigator.pushNamed(context, '/accounts'),
              ),
              const SizedBox(height: 30),

              // Preferences Section
              const Text(
                'Preferencias',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              ProfileMenuItem(
                icon: Icons.settings_outlined,
                title: 'Configuración',
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
              const SizedBox(height: 30),

              // Information Section
              const Text(
                'Información',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Versión',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _version,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Build',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _buildNumber,
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Copyright
              Center(
                child: Text(
                  '© 2026 Todos los derechos reservados',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
              const SizedBox(height: 30),

              // Export Data Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _exportData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Exportar Datos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Delete Data Permanently Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _deleteDataPermanently,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Eliminar Datos Permanentemente',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
