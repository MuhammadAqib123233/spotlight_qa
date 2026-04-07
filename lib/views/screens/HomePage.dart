import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:spotlightqa/controller/HomepageController.dart';
import 'package:spotlightqa/controller/SplashScreenCOntroller.dart';
import 'package:spotlightqa/controller/WebDataController.dart';
import 'package:spotlightqa/services/CheckInternetService.dart';
import 'package:spotlightqa/views/screens/FoodMag.dart';
import 'package:spotlightqa/views/screens/TourismMag.dart';
import 'package:spotlightqa/views/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:spotlightqa/views/widgets/CustomAppBar.dart';
import 'package:spotlightqa/views/widgets/CustomBottomBar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

  class HomePage extends StatefulWidget {
    const HomePage({super.key});

    @override
    State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
    
    

    WebDataController webCon = Get.find<WebDataController>();
    InternetCheckService internetCon = Get.find<InternetCheckService>(); 
    String initialUrl = "https://www.spotlight-qa.com/?device_type=mobile";
    static const int _pageIndex = 0;
    Timer? _loadingTimer;
    @override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    webCon.setPageLoading(_pageIndex, true);
    webCon.setInitialUrl(initialUrl);
  });

  // ─── iOS specific params ───
  // late final PlatformWebViewControllerCreationParams params;
  // if (Platform.isIOS) {
  //   params = WebKitWebViewControllerCreationParams(
  //     allowsInlineMediaPlayback: true,        // ← plays video inline
  //     mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{}, // ← no user gesture needed
  //   );
  // } else {
  //   params = const PlatformWebViewControllerCreationParams();
  // }

  // webCon.homecontroller = WebViewController.fromPlatformCreationParams(params)
  //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //   ..setUserAgent(
  //     'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 '
  //     '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36'
  //   )
  //   ..clearCache()
  //   ..setNavigationDelegate(
  //     NavigationDelegate(
  //       onPageStarted: (url) {
  //         webCon.setPageLoading(_pageIndex, true);
  //         _loadingTimer?.cancel();
  //         _loadingTimer = Timer(const Duration(seconds: 10), () {
  //           webCon.setPageLoading(_pageIndex, false);
  //         });
  //       },
  //       onWebResourceError: (error) {
  //         if (error.isForMainFrame ?? true) {
  //           _loadingTimer?.cancel();
  //           webCon.setPageLoading(_pageIndex, false);
  //         }
  //       },
  //       onProgress: (progress) {
  //         webCon.progress.value = progress;
  //       },
  //       onPageFinished: (url) async {
  //         _loadingTimer?.cancel();
  //         webCon.setPageLoading(_pageIndex, false);
  //         webCon.canGoBackState.value = await webCon.canGoBack();

  //         webCon.homecontroller.runJavaScript("""
  //           var meta = document.querySelector('meta[name="viewport"]');
  //           if (!meta) {
  //             meta = document.createElement('meta');
  //             meta.name = 'viewport';
  //             document.head.appendChild(meta);
  //           }
  //           meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
  //           window.scrollTo(0, 0);

  //           // force inline video
  //           document.querySelectorAll('video').forEach(function(v) {
  //             v.setAttribute('playsinline', '');
  //             v.setAttribute('webkit-playsinline', '');
  //           });
  //         """);
  //       },
  //       onUrlChange: (url) async {
  //         webCon.setCurrentUrl(url.url ?? '');
  //         webCon.canGoBackState.value = await webCon.canGoBack();
  //       },
  //     ),
  //   )
  //   ..loadRequest(Uri.parse(initialUrl));

  // // ─── Android specific settings ───
  // if (webCon.homecontroller.platform is AndroidWebViewController) {
  //   AndroidWebViewController.enableDebugging(true);
  //   (webCon.homecontroller.platform as AndroidWebViewController)
  //       .setMediaPlaybackRequiresUserGesture(false);
  // }

  // ─── iOS specific params ───
  late final PlatformWebViewControllerCreationParams params;
  if (Platform.isIOS) {
    params = WebKitWebViewControllerCreationParams(
      allowsInlineMediaPlayback: true,        // ← plays video inline
      mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{
        PlaybackMediaTypes.audio,
        PlaybackMediaTypes.video
      }, // ← no user gesture needed
    );
    final WebKitWebViewController webKitController =
      webCon.homecontroller.platform as WebKitWebViewController;
      webKitController.setInspectable(true);
  } 
  // else {
  //   params = const PlatformWebViewControllerCreationParams();
  // }

  webCon.homecontroller = WebViewController.fromPlatformCreationParams(params)
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

           await webCon.homecontroller.runJavaScript("""
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
  if (webCon.homecontroller.platform is AndroidWebViewController) {
    AndroidWebViewController.enableDebugging(true);
    (webCon.homecontroller.platform as AndroidWebViewController)
        .setMediaPlaybackRequiresUserGesture(false);
  }
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
          WebViewWidget(controller: webCon.homecontroller),

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