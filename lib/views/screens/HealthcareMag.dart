import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spotlightqa/controller/WebDataController.dart';
import 'package:webview_flutter/webview_flutter.dart';
class HealthcareMag extends StatefulWidget {
  const HealthcareMag({super.key});

  @override
  State<HealthcareMag> createState() => _HealthcareMagState();
}

class _HealthcareMagState extends State<HealthcareMag> with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  int _progress = 0;

  late InAppWebViewController webView;
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
        Uri.parse('https://www.spotlight-qa.com/health-care-mag/?device_type=mobile'),
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
