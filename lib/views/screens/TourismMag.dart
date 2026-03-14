import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
class TourismMag extends StatefulWidget {
  const TourismMag({super.key});

  @override
  State<TourismMag> createState() => _TourismMagState();
}

class _TourismMagState extends State<TourismMag> with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  int _progress = 0;

  late InAppWebViewController webView;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://www.spotlight-qa.com/hospitality-tourism-mag/?device_type=mobile"),
            ),

            initialSettings: InAppWebViewSettings(
              mediaPlaybackRequiresUserGesture: false,
              allowFileAccessFromFileURLs: true,
              allowUniversalAccessFromFileURLs: true,
              javaScriptEnabled: true,
              useOnDownloadStart: true,
            ),

            // Controller Assigned
            onWebViewCreated: (controller) {
              webView = controller;
            },

            // Loader Start
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
              });
            },

            // Progress Update
            onProgressChanged: (controller, progress) {
              setState(() {
                _progress = progress;
                _isLoading = progress != 100;
              });
            },

            // Loader End
            onLoadStop: (controller, url) async {
              setState(() {
                _isLoading = false;
              });
            },
            
            // Camera / Microphone Permissions
            onPermissionRequest: (controller, request) async {
              return PermissionResponse(
                resources: request.resources,
                action: PermissionResponseAction.GRANT,
              );
            },
          ),

          /// Fullscreen Loader
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
