import 'package:HamilGuide/constants.dart';
import 'package:HamilGuide/screens/website.dart';
import 'package:HamilGuide/utils/weeks_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/elhaml.dart';
import 'screens/links.dart';
import 'screens/website.dart';
import 'screens/weeks.dart';
import 'utils/ads_manager.dart';

void main() {
  runApp(HamilGuide());
}

class HamilGuide extends StatefulWidget {
  @override
  _HamilGuideState createState() => _HamilGuideState();
}

class _HamilGuideState extends State<HamilGuide>
    implements PageChangeListener, BannerAdLoadedListener, TickerProvider {
  var controller;
  Widget _adWidget;
  double screenHeight;

  @override
  void initState() {
    super.initState();
    AdsManager.initialize();
    controller = TabController(length: 4, vsync: this);
    CurrentPageManager.listenPageNumberChange(this);
    AdsManager.listenBannerAd(this);
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      locale: Locale("ar"),
      supportedLocales: const [const Locale("ar", '')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: "دليل المرأه الحامل",
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink.shade900,
          bottom: TabBar(
            controller: controller,
            labelStyle: TextStyle(fontSize: 16.0),
            tabs: [
              Tab(text: ("الحمل")),
              Tab(text: ("الأسابيع ")),
              Tab(text: ("الموقع ")),
              Tab(text: ("مقتطفات")),
            ],
          ),
          title: Text(
            'دليل المرأه الحامل',
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: [
            Elhaml(),
            Weeks(),
            WebSite(),
            Links(),
          ],
        ),
      ),
      builder: (BuildContext context, Widget child) {
        screenHeight = getMargin(MediaQuery.of(context).size.height);
        _adWidget = SizedBox(
          height: screenHeight,
        );
        AdsManager.loadInterstitialAd();
        AdsManager.loadBannerAd();
        return Column(
          children: [
            Container(child: _adWidget),
            Expanded(child: child),
          ],
        );
      },
    );
  }

  @override
  void onPageNumberChangedListener() {
    setState(() {
      if (mounted) controller.animateTo(1);
    });
  }

  @override
  Ticker createTicker(void Function(Duration elapsed) onTick) {
    return Ticker(onTick);
    //throw UnimplementedError();
  }

  @override
  void onBannerAdLoadedListener({double height, dynamic fbWidget}) {
    if (fbWidget != null) {
      setState(() {
        _adWidget = fbWidget;
      });
    } else {
      setState(() {
        _adWidget = SizedBox(
          height: screenHeight,
        );
      });
    }
  }
}
