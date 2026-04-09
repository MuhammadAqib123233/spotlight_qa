import 'dart:async';
import 'dart:io';

import 'package:spotlightqa/controller/HomepageController.dart';
import 'package:spotlightqa/controller/WebDataController.dart';
import 'package:spotlightqa/services/CheckInternetService.dart';
import 'package:spotlightqa/services/PermissionService.dart';
import 'package:spotlightqa/views/screens/TourismMag.dart';
import 'package:spotlightqa/views/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotlightqa/views/widgets/CustomAppBar.dart';
import 'package:spotlightqa/views/widgets/CustomBottomBar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';



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
//     void initState() {
//       super.initState();
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//     webCon.setPageLoading(_pageIndex, true);
//     webCon.setInitialUrl(initialUrl);
//   });
//       late final PlatformWebViewControllerCreationParams params;
//   if (Platform.isIOS) {
//     params = WebKitWebViewControllerCreationParams(
//       allowsInlineMediaPlayback: true,        // ← plays video inline
//       mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{}, // ← no user gesture needed
//     );
//     final WebKitWebViewController webKitController =
//       webCon.homecontroller.platform as WebKitWebViewController;
//       webKitController.setInspectable(true);
//   } else {
//     params = const PlatformWebViewControllerCreationParams();
//   }
//       webCon.foodController = WebViewController.fromPlatformCreationParams(params)
//         ..setJavaScriptMode(JavaScriptMode.unrestricted)
//   //       ..setUserAgent(
//   //   'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 '
//   //   '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36'
//   // )
//   ..setUserAgent(
//     'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1'
//   )
//         ..clearCache()  
//         ..setNavigationDelegate(
//           NavigationDelegate(
//   //           onPageStarted: (url) {
//   //             webCon.isLoading.value = true;
//   //             webCon.setPageLoading(_pageIndex, true);
//   //             print("page started ${webCon.isLoading.value}");
//   //              Future.delayed(Duration(seconds: 10), () {
//   //              if (webCon.pageLoadingState[_pageIndex] ?? true) {
//   //              webCon.setPageLoading(_pageIndex, false);
//   //              }
//   // });
//   //           },
//   onPageStarted: (url) {
//   webCon.setPageLoading(_pageIndex, true);
  
//   // Cancel any previous timer first
//   _loadingTimer?.cancel();
  
//   // Start cancellable timer
//   _loadingTimer = Timer(const Duration(seconds: 10), () {
//     webCon.setPageLoading(_pageIndex, false);
//   });
// },
//             // onWebResourceError: (error) {
//             //   print("error ${error}");
//             //   webCon.isLoading.value = false;
//             //   webCon.setPageLoading(_pageIndex, false);
//             // },
//             onWebResourceError: (error) {
//               print("error type ${error.errorType} and ${error.description}");
//   if (error.isForMainFrame ?? true) {
//     _loadingTimer?.cancel();
//     webCon.setPageLoading(_pageIndex, false);
//   }
// },
//             onProgress: (progress) {
//               webCon.progress.value = progress;
//             },
//             onPageFinished: (url)async{
//               print("page finished");
//                _loadingTimer?.cancel(); // ← page loaded fine, cancel the timer
//   webCon.setPageLoading(_pageIndex, false);
//               webCon.canGoBackState.value = await webCon.canGoBack();
//              webCon.foodController.runJavaScript("""
//             var meta = document.querySelector('meta[name="viewport"]');
//             if (!meta) {
//             meta = document.createElement('meta');
//             meta.name = 'viewport';
//             document.head.appendChild(meta);
//            }
//            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
//             window.scrollTo(0, 0);
//             // force inline video
//           document.querySelectorAll('video').forEach(function(v) {
//   v.setAttribute('playsinline', '');
//   v.setAttribute('webkit-playsinline', '');
//   v.muted = false;
//   v.controls = true;
// });
            
//   """);
//   await webCon.foodController.runJavaScript("""
// document.body.style.webkitTransform = 'translate3d(0,0,0)';
// """);
//             },
//             onUrlChange: (url) async{
//               webCon.setCurrentUrl(url.url ?? '');
//               webCon.canGoBackState.value = await webCon.canGoBack(); // ✅ here
//             },
//           ),
//         )
//         ..loadRequest(
//           Uri.parse(initialUrl),
//         );
//         if (webCon.homecontroller.platform is AndroidWebViewController) {
//     AndroidWebViewController.enableDebugging(true);
//     (webCon.homecontroller.platform as AndroidWebViewController)
//         .setMediaPlaybackRequiresUserGesture(false);
//   }
//     }

@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    webCon.setPageLoading(_pageIndex, true);
    webCon.setInitialUrl(initialUrl);
  });

  // ─── iOS specific params ───
  late final PlatformWebViewControllerCreationParams params;
  if (Platform.isIOS) {
    params = WebKitWebViewControllerCreationParams(
      allowsInlineMediaPlayback: true,        // ← plays video inline
      mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{
        PlaybackMediaTypes.video,
        PlaybackMediaTypes.audio
      }, // ← no user gesture needed
    );
    final WebKitWebViewController webKitController =
      webCon.foodController.platform as WebKitWebViewController;
      webKitController.setInspectable(true);
  } 
  // else {
  //   params = const PlatformWebViewControllerCreationParams();
  // }

  webCon.foodController = WebViewController.fromPlatformCreationParams(params)
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setUserAgent(
      'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36'
    )
    ..clearCache()
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          webCon.setPageLoading(_pageIndex, true);
          _loadingTimer?.cancel();
          _loadingTimer = Timer(const Duration(seconds: 10), () {
            webCon.setPageLoading(_pageIndex, false);
          });
        },
        onWebResourceError: (error) {
          if (error.isForMainFrame ?? true) {
            _loadingTimer?.cancel();
            webCon.setPageLoading(_pageIndex, false);
          }
        },
        onProgress: (progress) {
          webCon.progress.value = progress;
        },
        onPageFinished: (url) async {
          _loadingTimer?.cancel();
          webCon.setPageLoading(_pageIndex, false);
          webCon.canGoBackState.value = await webCon.canGoBack();

          await webCon.foodController.runJavaScript("""
              (function() {
                function fixVideos() {
                  document.querySelectorAll('video').forEach(function(v) {
                    v.setAttribute('playsinline', '');
                    v.setAttribute('webkit-playsinline', '');
                    v.removeAttribute('autoplay');
                    
                    // Fix black box by setting poster if missing
                    if (!v.getAttribute('poster')) {
                      v.style.backgroundColor = '#000';
                    }
                    
                    // Show native controls so user sees play button
                    v.controls = true;
                  });
                }

                // Run immediately and observe for dynamic videos
                fixVideos();
                const observer = new MutationObserver(fixVideos);
                observer.observe(document.body, { childList: true, subtree: true });
              })();
            """);
        },
        onUrlChange: (url) async {
          webCon.setCurrentUrl(url.url ?? '');
          webCon.canGoBackState.value = await webCon.canGoBack();
        },
      ),
    )
    ..loadRequest(Uri.parse(initialUrl));

  // ─── Android specific settings ───
  if (webCon.foodController.platform is AndroidWebViewController) {
    AndroidWebViewController.enableDebugging(true);
    (webCon.foodController.platform as AndroidWebViewController)
        .setMediaPlaybackRequiresUserGesture(false);
  }

  if (Platform.isIOS) {
  final webKitController = webCon.homecontroller.platform as WebKitWebViewController;
  webKitController.setInspectable(true);

  // ✅ Correct way to set permission request handler
  webKitController.setOnPlatformPermissionRequest(
    (PlatformWebViewPermissionRequest request) async {
      debugPrint('WebKit permission types: ${request.types}');
      final permService = Get.find<PermissionService>();
      bool granted = false;

      if (request.types.contains(WebViewPermissionResourceType.camera)) {
        granted = await permService.ensureCameraPermission();
      } else if (request.types.contains(WebViewPermissionResourceType.microphone)) {
        granted = true;
      } else {
        granted = await permService.ensurePhotosPermission();
      }

      if (granted) {
        request.grant();
      } else {
        request.deny();
      }
    },
  );
}
}

     @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Obx(() {
      // *** FIX: observe per-page loading state ***
      final isLoading = webCon.pageLoadingState[_pageIndex] ?? true;
      final hasInternet = internetCon.hasInternet.value;

      return SafeArea(
        child: Stack(
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
        ),
      );
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}