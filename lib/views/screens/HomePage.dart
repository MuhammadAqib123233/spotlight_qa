import 'dart:developer';

import 'package:spotlightqa/controller/HomepageController.dart';
import 'package:spotlightqa/controller/SplashScreenCOntroller.dart';
import 'package:spotlightqa/controller/WebDataController.dart';
import 'package:spotlightqa/views/screens/FoodMag.dart';
import 'package:spotlightqa/views/screens/TourismMag.dart';
import 'package:spotlightqa/views/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:spotlightqa/views/widgets/CustomAppBar.dart';
import 'package:spotlightqa/views/widgets/CustomBottomBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

  class HomePage extends StatefulWidget {
    const HomePage({super.key});

    @override
    State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
    bool _isLoading = true;
    int _progress = 0;
    

    WebDataController webCon = Get.find<WebDataController>();
    @override
    void initState() {
      super.initState();
      log("homepage initializeddd");
      webCon.homecontroller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setUserAgent(
    'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 '
    '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36'
  )
        ..clearCache()  
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              setState(() {
                _isLoading = true;
              });
            },
            onProgress: (progress) {
              setState(() {
                _progress = progress;
              });
            },
            onPageFinished: (url) {
              setState(() {
                _isLoading = false;
              });

              // webCon.homecontroller.runJavaScript("""
              //   document.getElementById("masthead").style.display="none";
              //   document.getElementById('colophon').style.display = 'none';
              // """);

              // Fix viewport to ensure full page renders correctly
             webCon.homecontroller.runJavaScript("""
            var meta = document.querySelector('meta[name="viewport"]');
            if (!meta) {
            meta = document.createElement('meta');
            meta.name = 'viewport';
            document.head.appendChild(meta);
           }
           meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            window.scrollTo(0, 0);
  """);
            },
          ),
        )
        ..loadRequest(
          Uri.parse('https://www.spotlight-qa.com?device_type=mobile'),
        );
    }

    @override
    Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Stack(
            children: [
              WebViewWidget(controller: webCon.homecontroller),
      
              /// Loader
              if (_isLoading)
                Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text("Loading... $_progress%"),
                      ],
                    ),
                  ),
                ),
            ],
          ),
    );
    }

    
    @override
    // TODO: implement wantKeepAlive
    bool get wantKeepAlive => true;
  }