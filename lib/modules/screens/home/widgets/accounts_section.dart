import 'package:flutter/material.dart';
import '../../../../shared/models/account_model.dart';
import '../../../../shared/services/offline/account_service.dart';
import '../../../../shared/notifiers/data_sync_notifier.dart';
import '../../accounts/accounts_screen.dart';

class AccountsSection extends StatefulWidget {
  const AccountsSection({super.key});

  @override
  State<AccountsSection> createState() => _AccountsSectionState();
}

class _AccountsSectionState extends State<AccountsSection> {
  List<Account> _accounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
    dataSyncNotifier.addListener(_loadAccounts);
  }

  @override
  void dispose() {
    dataSyncNotifier.removeListener(_loadAccounts);
    super.dispose();
  }

  Future<void> _loadAccounts() async {
    final accounts = await AccountService.getAccounts();
    if (mounted) {
      setState(() {
        _accounts = accounts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mis Cuentas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (_accounts.isEmpty)
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: const Color(0xFF1E1E1E),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                builder: (context) => AddAccountForm(_loadAccounts),
              );
            },
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white10,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_card, color: Colors.grey[600], size: 40),
                  const SizedBox(height: 12),
                  const Text(
                    'No tienes cuentas registradas',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Crear una cuenta',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _accounts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final account = _accounts[index];
                return _AccountCard(
                  color: account.color,
                  title: account.name,
                  balance:
                      '${account.balance.toStringAsFixed(2)} ${account.currency ?? 'USD'}',
                  currency: account.currency ?? 'USD',
                  isSelected: index == 0,
                );
              },
            ),
          ),
      ],
    );
  }
}

class _AccountCard extends StatefulWidget {
  final Color color;
  final String title;
  final String balance;
  final String currency;
  final bool isSelected;

  const _AccountCard({
    required this.color,
    required this.title,
    required this.balance,
    required this.currency,
    required this.isSelected,
  });

  @override
  State<_AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<_AccountCard> {
  bool _isBalanceVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.currency,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              if (widget.isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Balance disponible',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    _isBalanceVisible ? widget.balance : '******',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isBalanceVisible = !_isBalanceVisible;
                      });
                    },
                    child: Icon(
                      _isBalanceVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
