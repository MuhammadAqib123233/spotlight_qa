import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spotlightqa/controller/WebDataController.dart';
import 'package:webview_flutter/webview_flutter.dart';
class TourismMag extends StatefulWidget {
  const TourismMag({super.key});

  @override
  State<TourismMag> createState() => _TourismMagState();
}

class _TourismMagState extends State<TourismMag> with AutomaticKeepAliveClientMixin {
  WebDataController webCon = Get.find<WebDataController>();
    String initialUrl = "https://www.spotlight-qa.com/hospitality-tourism-mag/?device_type=mobile";
    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
    webCon.setInitialUrl(initialUrl);
  });
      webCon.hospitalityController = WebViewController()
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
            onPageFinished: (url)async{
              print("page finished");
              webCon.isLoading.value = false;
              webCon.canGoBackState.value = await webCon.canGoBack();
             webCon.hospitalityController.runJavaScript("""
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
            onUrlChange: (url) async{
              webCon.setCurrentUrl(url.url ?? '');
              webCon.canGoBackState.value = await webCon.canGoBack(); // ✅ here
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
              WebViewWidget(controller: webCon.hospitalityController),
       
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
