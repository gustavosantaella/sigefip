import 'package:flutter/material.dart';
import 'package:nexo_finance/l10n/generated/app_localizations.dart';
import 'package:nexo_finance/core/managers/locale_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Map of language codes to display names
  final Map<String, String> _languages = {
    'es': 'Español',
    'en': 'English',
    'pt': 'Português',
    'zh': '中文 (Chinese)',
    'ja': '日本語 (Japanese)',
  };

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final currentLocale = LocaleManager().value.languageCode;
        final l10n = AppLocalizations.of(context)!;

        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(
            l10n.selectLanguage,
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _languages.entries.map((entry) {
              return RadioListTile<String>(
                value: entry.key,
                groupValue: currentLocale,
                onChanged: (value) {
                  if (value != null) {
                    LocaleManager().setLocale(value);
                    Navigator.pop(context);
                    setState(
                      () {},
                    ); // Trigger rebuild to show updated selection
                  }
                },
                title: Text(
                  entry.value,
                  style: const TextStyle(color: Colors.white),
                ),
                activeColor: Colors.purple.shade400,
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n.cancel,
                style: const TextStyle(color: Colors.purple),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String currentLanguageCode = LocaleManager().value.languageCode;
    final String currentLanguageName =
        _languages[currentLanguageCode] ?? 'Español';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(l10n.settingsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Card
            InkWell(
              onTap: () {
                _showLanguageDialog();
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.language,
                        color: Colors.blue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.language,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currentLanguageName,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
