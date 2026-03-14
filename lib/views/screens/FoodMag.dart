import 'package:spotlightqa/controller/HomepageController.dart';
import 'package:spotlightqa/controller/WebDataController.dart';
import 'package:spotlightqa/views/screens/TourismMag.dart';
import 'package:spotlightqa/views/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:spotlightqa/views/widgets/CustomAppBar.dart';
import 'package:spotlightqa/views/widgets/CustomBottomBar.dart';
import 'package:webview_flutter/webview_flutter.dart';



class FoodMag extends StatefulWidget {
  const FoodMag({super.key});

  @override
  State<FoodMag> createState() => _FoodMagState();
}

class _FoodMagState extends State<FoodMag> with AutomaticKeepAliveClientMixin{

   bool _isLoading = true;
   int _progress = 0;
  

  WebDataController webCon = Get.find<WebDataController>();
  @override
  void initState() {
    super.initState();

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
        Uri.parse('https://www.spotlight-qa.com/food-mag/?device_type=mobile'),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}