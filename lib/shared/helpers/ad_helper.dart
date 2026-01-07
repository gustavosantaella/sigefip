import 'package:flutter/foundation.dart';

class AdHelper {
  // ==========================================
  // Test Ad Unit IDs (Google Provided)
  // ==========================================
  // Source: https://developers.google.com/admob/android/test-ads
  // Note: iOS Test IDs are different, keeping it simple for now as requested or assuming cross-platform test ID if valid.
  // Google's Test IDs are platform specific usually. I'll use Android ones for now as user environment is likely Android based on context (gradle),
  // but good practice is to check Platform.isAndroid too.

  static const String _testAppOpenManager =
      'ca-app-pub-3940256099942544/3419835294';
  static const String _testBanner = 'ca-app-pub-3940256099942544/6300978111';

  // ==========================================
  // Real Ad Unit IDs (User Provided)
  // ==========================================
  // App Open
  static const String _realAppOpen = 'ca-app-pub-7887143920740339/9398340188';

  // Home
  static const String _realHomeTop = 'ca-app-pub-7887143920740339/2188072182';
  static const String _realHomeBottom =
      'ca-app-pub-7887143920740339/4146013501';

  // Transactions
  static const String _realTransactions1 =
      'ca-app-pub-7887143920740339/6785792740';
  static const String _realTransactions2 =
      'ca-app-pub-7887143920740339/4754541689';

  // Accounts
  static const String _realAccounts1 = 'ca-app-pub-7887143920740339/8869030605';
  static const String _realAccounts2 = 'ca-app-pub-7887143920740339/2212122914';

  // ==========================================
  // Getters
  // ==========================================

  static String get appOpenAdUnitId {
    if (kIsWeb) {
      return "";
    }
    if (kReleaseMode) {
      return _realAppOpen;
    } else {
      return defaultTargetPlatform == TargetPlatform.android
          ? _testAppOpenManager
          : 'ca-app-pub-3940256099942544/5662855259'; // iOS App Open Test ID
    }
  }

  static String get homeTopBanner {
    return _getBannerId(_realHomeTop);
  }

  static String get homeBottomBanner {
    return _getBannerId(_realHomeBottom);
  }

  static String get transactionsBanner1 {
    return _getBannerId(_realTransactions1);
  }

  static String get transactionsBanner2 {
    return _getBannerId(_realTransactions2);
  }

  static String get accountsBanner1 {
    return _getBannerId(_realAccounts1);
  }

  static String get accountsBanner2 {
    return _getBannerId(_realAccounts2);
  }

  static String _getBannerId(String realId) {
    if (kIsWeb) {
      // Return a test ID for web or handle differently
      return "";
    }
    if (kReleaseMode) {
      return realId;
    } else {
      // 2934735716 is banner test id for iOS, 6300978111 for Android
      return defaultTargetPlatform == TargetPlatform.android
          ? _testBanner
          : 'ca-app-pub-3940256099942544/2934735716';
    }
  }
}
