import 'dart:async';

import 'package:spotlightqa/controller/HomepageController.dart';
import 'package:spotlightqa/controller/WebDataController.dart';
import 'package:spotlightqa/services/CheckInternetService.dart';
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

  //  bool webCon.isLoading.value = true;
  //  int webCon.progress.value = 0;
  

  // WebDataController webCon = Get.find<WebDataController>();
  // @override
  // void initState() {
  //   super.initState();

  //   webCon.homecontroller = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
  //         onPageStarted: (url) {
  //           setState(() {
  //             webCon.isLoading.value = true;
  //           });
  //         },
  //         onProgress: (progress) {
  //           setState(() {
  //             webCon.progress.value = progress;
  //           });
  //         },
  //         onPageFinished: (url) {
  //           setState(() {
  //             webCon.isLoading.value = false;
  //           });

  //           // webCon.homecontroller.runJavaScript("""
  //           //   document.getElementById("masthead").style.display="none";
  //           //   document.getElementById('colophon').style.display = 'none';
  //           // """);
  //         },
  //       ),
  //     )
  //     ..loadRequest(
  //       Uri.parse('https://www.spotlight-qa.com/food-mag/?device_type=mobile'),
  //     );
  // }

  WebDataController webCon = Get.find<WebDataController>();
  InternetCheckService internetCon = Get.find<InternetCheckService>();
  String initialUrl = "https://www.spotlight-qa.com/food-mag/?device_type=mobile";
  Timer? _loadingTimer;
   static const int _pageIndex = 2;
    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
    webCon.setPageLoading(_pageIndex, true);
    webCon.setInitialUrl(initialUrl);
  });
      webCon.foodController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setUserAgent(
    'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 '
    '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36'
  )
        ..clearCache()  
        ..setNavigationDelegate(
          NavigationDelegate(
  //           onPageStarted: (url) {
  //             webCon.isLoading.value = true;
  //             webCon.setPageLoading(_pageIndex, true);
  //             print("page started ${webCon.isLoading.value}");
  //              Future.delayed(Duration(seconds: 10), () {
  //              if (webCon.pageLoadingState[_pageIndex] ?? true) {
  //              webCon.setPageLoading(_pageIndex, false);
  //              }
  // });
  //           },
  onPageStarted: (url) {
  webCon.setPageLoading(_pageIndex, true);
  
  // Cancel any previous timer first
  _loadingTimer?.cancel();
  
  // Start cancellable timer
  _loadingTimer = Timer(const Duration(seconds: 10), () {
    webCon.setPageLoading(_pageIndex, false);
  });
},
            // onWebResourceError: (error) {
            //   print("error ${error}");
            //   webCon.isLoading.value = false;
            //   webCon.setPageLoading(_pageIndex, false);
            // },
            onWebResourceError: (error) {
  if (error.isForMainFrame ?? true) {
    _loadingTimer?.cancel();
    webCon.setPageLoading(_pageIndex, false);
  }
},
            onProgress: (progress) {
              webCon.progress.value = progress;
            },
            onPageFinished: (url)async{
              print("page finished");
               _loadingTimer?.cancel(); // ← page loaded fine, cancel the timer
  webCon.setPageLoading(_pageIndex, false);
              webCon.canGoBackState.value = await webCon.canGoBack();
             webCon.foodController.runJavaScript("""
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
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Obx(() {
      // *** FIX: observe per-page loading state ***
      final isLoading = webCon.pageLoadingState[_pageIndex] ?? true;
      final hasInternet = internetCon.hasInternet.value;

      return Stack(
        children: [
          // WebView always in the tree — never remove it
          WebViewWidget(controller: webCon.foodController),

          // Loading overlay — shows immediately on first load and page navigation
          if (isLoading && hasInternet)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text("Loading..."),
                  ],
                ),
              ),
            ),

          // No internet overlay
          if (!hasInternet)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                    const SizedBox(height: 10),
                    const Text("No Internet Connection"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        internetCon.checkInternet();
                        if (internetCon.hasInternet.value) {
                          webCon.emagzineController
                              .loadRequest(Uri.parse(initialUrl));
                        }
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}