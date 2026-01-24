library ads_manager;

import 'package:firebase_admob/firebase_admob.dart';
// Import
import 'package:kochava_tracker/kochava_tracker.dart';

const appId = "ca-app-pub-4090044802562423~5532321643";
const String bannerID = 'ca-app-pub-4090044802562423/5112685096';
const String myInterstitialID = 'ca-app-pub-4090044802562423/1163306577';
const String rewardedID = 'ca-app-pub-4090044802562423/9765234217';
const String nativeID = 'ca-app-pub-4090044802562423/3199825861';

/*const f_appId = "252949336225010";
const String f_bannerID = '894398357978041_894637607954116';
const String f_myInterstitialID = '894398357978041_894637967954080';
const String f_nativeID = '894398357978041_894637124620831';
const String f_medRect = '894398357978041_894638231287387';*/

class AdsManager {
  static MobileAdTargetingInfo _targetingInfo;
  static BannerAd _glBanner;
  // static Widget _fbBanner;
  static bool initialized = false;
  static InterstitialAd _glInterstitial;
  static List<BannerAdLoadedListener> _listeners = [];
  static AD_SOURCE _bannerAdSrc;
  static AD_SOURCE _interAdSrc;

  static set interAdSrc(AD_SOURCE value) {
    if (_interAdSrc == null) {
      _interAdSrc = value;
    }
  }

  /*static setBannerAdSrc(AD_SOURCE value) {
    if (_bannerAdSrc == null) {
      _bannerAdSrc = value;
      showBannerAd();
    }
  }*/

  static setInterAdSrc(AD_SOURCE value) {
    if (_interAdSrc == null) {
      _interAdSrc = value;
      showInterAd();
    }
  }

  static void loadInterstitialAd() {
    if (initialized) {
      /*FacebookInterstitialAd.loadInterstitialAd(
        placementId: f_myInterstitialID,
        listener: (result, value) {
          if (result == InterstitialAdResult.LOADED)
            setInterAdSrc(AD_SOURCE.FB);
        },
      );*/
      _glInterstitial = InterstitialAd(
        adUnitId: myInterstitialID,
        targetingInfo: _targetingInfo,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            setInterAdSrc(AD_SOURCE.GL);
          }
        },
      );
      _glInterstitial..load();
      _glInterstitial.show();
    }
  }

  static void loadBannerAd() {
    //if (_bannerAdSrc != null) return;
    if (initialized) {
      /*_fbBanner = FacebookBannerAd(
        placementId: f_bannerID,
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          if (result == BannerAdResult.LOADED) {
            setBannerAdSrc(AD_SOURCE.FB);
          }
        },
      );*/
      _glBanner = BannerAd(
        adUnitId: bannerID,
        size: AdSize.smartBanner,
        targetingInfo: _targetingInfo,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            // setBannerAdSrc(AD_SOURCE.GL);
          }
        },
      );
      _glBanner.load();
      _glBanner.show(anchorType: AnchorType.top);
    }
  }

  /*static void showBannerAd() {
    if (_bannerAdSrc == AD_SOURCE.FB) {
      // _notify(fbWidget: _fbBanner);
    } else if (_bannerAdSrc == AD_SOURCE.GL) {
      _notify(height: _glBanner.size.height.toDouble());
      _glBanner.show(anchorType: AnchorType.top);
    }
  }*/

  static void showInterAd() {
    if (_bannerAdSrc == AD_SOURCE.FB) {
      // FacebookInterstitialAd.showInterstitialAd(delay: 5000);
    } else if (_bannerAdSrc == AD_SOURCE.GL) {
      _glInterstitial.show(anchorType: AnchorType.bottom);
    }
  }

  static void listenBannerAd(BannerAdLoadedListener listener) {
    _listeners.add(listener);
  }

  static void _notify({double height, dynamic fbWidget}) {
    for (BannerAdLoadedListener l in _listeners)
      l.onBannerAdLoadedListener(height: height, fbWidget: fbWidget);
  }

  static void initialize() {
    FirebaseAdMob.instance.initialize(appId: appId);
    _targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      testDevices: <String>[],
    );

    var config = {
      KochavaTracker.PARAM_ANDROID_APP_GUID_STRING_KEY: 'YOUR_ANDROID_APP_GUID',
      KochavaTracker.PARAM_IOS_APP_GUID_STRING_KEY: 'YOUR_IOS_APP_GUID',
    };
    KochavaTracker.instance.configure(config);

    // FacebookAudienceNetwork.init();

    initialized = true;
  }
}

abstract class BannerAdLoadedListener {
  void onBannerAdLoadedListener({double height, dynamic fbWidget});
}

enum AD_SOURCE { FB, GL }
