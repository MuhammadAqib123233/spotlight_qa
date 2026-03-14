import 'dart:developer';

import 'package:spotlightqa/controller/HomepageController.dart';
import 'package:spotlightqa/controller/WebDataController.dart';
import 'package:spotlightqa/views/screens/FoodMag.dart';
import 'package:spotlightqa/views/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:spotlightqa/views/widgets/CustomAppBar.dart';
import 'package:spotlightqa/views/widgets/CustomBottomBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class spotlightqa extends StatefulWidget {
  const spotlightqa({super.key});

  @override
  State<spotlightqa> createState() => _spotlightqaState();
}

class _spotlightqaState extends State<spotlightqa> with AutomaticKeepAliveClientMixin{
bool _isLoading = true;
   int _progress = 0;
  

  WebDataController webCon = Get.find<WebDataController>();
  @override
  void initState() {
    super.initState();
    log("acccountscreen initializeddd");
    webCon.homecontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
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
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://www.spotlight-qa.com/spotlightqa/?device_type=mobile'),
      );
  }

  @override
  Widget build(BuildContext context) {
   return Stack(
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
      );
  }
  Future<void> _loadWebView() async {
   WebDataController webCon = Get.find<WebDataController>();
   webCon.accountController = await WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..loadRequest(Uri.parse('http://spotlight-qa.com/spotlightqa/?device_type=mobile'));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}