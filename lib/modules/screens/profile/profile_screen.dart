import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexo_finance/l10n/generated/app_localizations.dart';
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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/widgets/universal_image.dart';

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
        title: Text(
          AppLocalizations.of(context)!.deleteDataTitle,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          AppLocalizations.of(context)!.deleteDataContent,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.deleteAll),
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
          SnackBar(
            content: Text(AppLocalizations.of(context)!.dataDeleted),
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
        title: Text(
          AppLocalizations.of(context)!.exportData,
          style: const TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Deseas exportar todos tus datos? Esta función estará disponible próximamente.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
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
        SnackBar(content: Text(AppLocalizations.of(context)!.exportComingSoon)),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await UserService.updateUser(imagePath: image.path);
      await _loadData();
    }
  }

  Future<void> _launchInstagram() async {
    final Uri url = Uri.parse('https://www.instagram.com/nexo.software.ve/');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir Instagram')),
        );
      }
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
                  Text(
                    AppLocalizations.of(context)!.profileTitle,
                    style: const TextStyle(
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
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _user?.imagePath != null
                              ? null
                              : Colors.purple.shade400,
                          gradient: _user?.imagePath != null
                              ? null
                              : LinearGradient(
                                  colors: [
                                    Colors.purple.shade400,
                                    Colors.blue.shade400,
                                  ],
                                ),
                        ),
                        child: _user?.imagePath != null
                            ? ClipOval(
                                child: UniversalImage(
                                  path: _user!.imagePath!,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 50,
                              ),
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
                    child: StatCard(
                      count: _accountsCount,
                      label: AppLocalizations.of(context)!.statAccounts,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      count: _categoriesCount,
                      label: AppLocalizations.of(context)!.statCategories,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      count: _transactionsCount,
                      label: AppLocalizations.of(context)!.statTransactions,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Account Section
              Text(
                AppLocalizations.of(context)!.sectionAccount,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              ProfileMenuItem(
                icon: Icons.person_outline,
                title: AppLocalizations.of(context)!.personalInfo,
                subtitle: _user?.name ?? 'Username',
                onTap: () => Navigator.pushNamed(context, '/personal-info'),
              ),
              const SizedBox(height: 12),
              ProfileMenuItem(
                icon: Icons.account_balance_wallet_outlined,
                title: AppLocalizations.of(context)!.mainAccount,
                subtitle: _defaultAccount?.name ?? 'No configurada',
                onTap: () => Navigator.pushNamed(context, '/accounts'),
              ),
              const SizedBox(height: 30),

              // Preferences Section
              Text(
                AppLocalizations.of(context)!.sectionPreferences,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              ProfileMenuItem(
                icon: Icons.settings_outlined,
                title: AppLocalizations.of(context)!.settingsLabel,
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
              const SizedBox(height: 12),
              ProfileMenuItem(
                icon: Icons.login,
                title: 'Iniciar Sesión', // TODO: Add to l10n
                onTap: () => Navigator.pushNamed(context, '/login'),
              ),
              const SizedBox(height: 30),

              // Information Section
              Text(
                AppLocalizations.of(context)!.sectionInfo,
                style: const TextStyle(
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
                          AppLocalizations.of(context)!.version,
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
                          AppLocalizations.of(context)!.build,
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
                  AppLocalizations.of(context)!.copyright,
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
                  child: Text(
                    AppLocalizations.of(context)!.exportData,
                    style: const TextStyle(
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
              const SizedBox(height: 30),

              // Instagram Link
              Center(
                child: Text(
                  "Contact us",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Center(
                child: IconButton(
                  onPressed: _launchInstagram,
                  icon: const FaIcon(FontAwesomeIcons.instagram),
                  color: Colors.pinkAccent,
                  iconSize: 40,
                  tooltip: 'Síguenos en Instagram',
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
