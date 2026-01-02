import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../helpers/ad_helper.dart';

class AdService {
  static final AdService _instance = AdService._internal();

  factory AdService() {
    return _instance;
  }

  AdService._internal();

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  // Real Ad Unit ID provided by user
  final String _appOpenAdUnitId = AdHelper.appOpenAdUnitId;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    loadAppOpenAd();
  }

  void loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: _appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('App Open Ad loaded');
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('App Open Ad failed to load: $error');
        },
      ),
    );
  }

  void showAppOpenAdIfAvailable() {
    if (_appOpenAd == null || _isShowingAd) {
      debugPrint('Tried to show ad but it was null or already showing.');
      loadAppOpenAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
    );

    _appOpenAd!.show();
  }
}

class AppLifecycleReactor extends WidgetsBindingObserver {
  final AdService adService;

  AppLifecycleReactor(this.adService);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      adService.showAppOpenAdIfAvailable();
    }
  }
}
