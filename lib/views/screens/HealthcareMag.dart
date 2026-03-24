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
  WebDataController webCon = Get.find<WebDataController>();
    String initialUrl = "https://www.spotlight-qa.com/health-care-mag/?device_type=mobile";
    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
    webCon.setInitialUrl(initialUrl);
  });
      webCon.medicalController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setUserAgent(
    'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 '
    '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36'
  )
        ..clearCache()  
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              webCon.isLoading.value = true;
            },
            onProgress: (progress) {
              webCon.progress.value = progress;
            },
            onPageFinished: (url) {
              webCon.isLoading.value = false;

              // webCon.homecontroller.runJavaScript("""
              //   document.getElementById("masthead").style.display="none";
              //   document.getElementById('colophon').style.display = 'none';
              // """);

              // Fix viewport to ensure full page renders correctly
             webCon.medicalController.runJavaScript("""
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
            onUrlChange: (url) {
              webCon.setCurrentUrl(url.url ?? '');
            },
          ),
        )
        ..loadRequest(
          Uri.parse(initialUrl),
        );
    }

  @override
  Widget build(BuildContext context) {
   return Obx(
     () {
       return Stack(
            children: [
              WebViewWidget(controller: webCon.medicalController),
       
              /// Loader
              if (webCon.isLoading.value)
                Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text("Loading... ${webCon.progress.value}%"),
                      ],
                    ),
                  ),
                ),
            ],
          );
     }
   );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
