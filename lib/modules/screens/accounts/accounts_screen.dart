import 'package:flutter/material.dart';
import 'package:nexo_finance/l10n/generated/app_localizations.dart';
import 'package:nexo_finance/shared/services/offline/account_service.dart';
import '../../../shared/models/account_model.dart';
import '../../../shared/widgets/custom_bottom_sheet.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_dropdown.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../../core/constants/currencies.dart';
import '../../../../shared/widgets/slide_card.dart';
import '../../../../shared/widgets/banner_ad_widget.dart';
import '../../../../shared/helpers/ad_helper.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  List<Account> accounts = [];

  @override
  void initState() {
    super.initState();
    loadAccounts();
  }

  void loadAccounts() async {
    final List<Account> accounts = await AccountService.getAccounts();
    setState(() {
      this.accounts = accounts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mis Cuentas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Banner Ad 1 (Accounts)
            Center(child: BannerAdWidget(adUnitId: AdHelper.accountsBanner1)),
            const SizedBox(height: 10),
            // Banner Ad 2 (Accounts)
            const SizedBox(height: 10),
            Center(child: BannerAdWidget(adUnitId: AdHelper.accountsBanner2)),
            const SizedBox(height: 10),

            // Accounts Grid/List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                itemCount: accounts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  return SlideCard<Account>(
                    key: ValueKey(account.id),
                    item: account,
                    borderRadius: BorderRadius.circular(20),
                    rightOptions: [
                      SlideAction<Account>(
                        icon: Icons.delete,
                        color: Colors.red,
                        onPressed: (account) async {
                          // Optimistic update
                          setState(() {
                            accounts.removeAt(index);
                          });

                          await AccountService.deleteAccount(account.id);
                          loadAccounts();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Cuenta "${account.name}" eliminada',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: account.color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              account.icon,
                              color: account.color,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  account.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (account.currency != null)
                                  Text(
                                    account.currency!,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${account.balance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: const Color(0xFF1E1E1E),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (context) => AddAccountForm(loadAccounts),
          );
        },
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddAccountForm extends StatefulWidget {
  const AddAccountForm(this.loadAccounts, {super.key});

  final Function loadAccounts;

  @override
  State<AddAccountForm> createState() => _AddAccountFormState();
}

class _AddAccountFormState extends State<AddAccountForm> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  String? _selectedCurrency;
  Color _selectedColor = const Color(0xFF6C63FF);

  final List<Color> _availableColors = [
    const Color(0xFF6C63FF),
    const Color(0xFF4CAF50),
    const Color(0xFF2196F3),
    const Color(0xFFFF9800),
    const Color(0xFFF44336),
    const Color(0xFFE91E63),
    const Color(0xFF9C27B0),
    const Color(0xFF00BCD4),
    const Color(0xFF8BC34A),
    const Color(0xFFFFEB3B),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: AppLocalizations.of(context)!.newAccount,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _nameController,
            label: AppLocalizations.of(context)!.accountNameLabel,
            hintText: AppLocalizations.of(context)!.accountNameHint,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _balanceController,
            label: AppLocalizations.of(context)!.initialBalanceLabel,
            keyboardType: TextInputType.number,
            prefixText: '\$ ',
          ),
          const SizedBox(height: 16),
          CustomDropdown<String>(
            label: AppLocalizations.of(context)!.currencyLabel,
            value: _selectedCurrency,
            items: currencies,
            itemLabelBuilder: (item) => item,
            onChanged: (val) => setState(() => _selectedCurrency = val),
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.accountColorLabel,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _availableColors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final color = _availableColors[index];
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          CustomButton(
            text: 'Guardar Cuenta',
            onPressed: () async {
              final account = Account(
                name: _nameController.text,
                balance: double.tryParse(_balanceController.text) ?? 0.0,
                currency: _selectedCurrency!,
                icon: Icons.money,
                color: _selectedColor,
              );

              await AccountService.storeAccount(account);
              widget.loadAccounts();

              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
