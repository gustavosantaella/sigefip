import 'package:flutter/material.dart';
import 'package:nexo_finance/shared/widgets/ads/banner_ad_platform.dart'
    if (dart.library.io) 'package:nexo_finance/shared/widgets/ads/banner_ad_mobile.dart'
    if (dart.library.html) 'package:nexo_finance/shared/widgets/ads/banner_ad_web.dart';

class BannerAdWidget extends StatelessWidget {
  final String adUnitId;

  const BannerAdWidget({super.key, required this.adUnitId});

  @override
  Widget build(BuildContext context) {
    return BannerAdPlatform(adUnitId: adUnitId);
  }
}
