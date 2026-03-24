import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebDataController extends GetxController{
  //RxString homeContent = "".obs;
  var homecontroller = WebViewController();
  var emagzineController = WebViewController();
  var foodController = WebViewController();
  var hospitalityController = WebViewController();
  var medicalController = WebViewController();
  var sportsController = WebViewController();

  Rx<String> currentUrl = ''.obs;
  Rx<String> initialUrl = ''.obs;
  Rx<bool> isLoading = true.obs;
  Rx<int> progress = 0.obs;
  setCurrentUrl(String url){
    currentUrl.value = url;
  }

  // bool checkUrl_ifCurrent(){
  //   if(currentUrl.value == initialUrl.value){
  //     return true;
  //   }else{
  //     return false;
  //   }
  // }

  // Fix Bug 2: normalize before comparing
  String _normalizeUrl(String url) {
    try {
      final uri = Uri.parse(url);
      // Rebuild without fragment, normalize path
      return Uri(
        scheme: uri.scheme,
        host: uri.host,
        path: uri.path.isEmpty ? '/' : uri.path,
        queryParameters: uri.queryParameters.isEmpty ? null : uri.queryParameters,
      ).toString();
    } catch (_) {
      return url;
    }
  }

  bool checkUrl_ifCurrent() {
    if (initialUrl.value.isEmpty) return true; // still loading, treat as home
    return currentUrl.value == initialUrl.value;
  }

//   void setInitialUrl(String url) {
//   initialUrl.value = url;
// }
void setInitialUrl(String url) {
    initialUrl.value = _normalizeUrl(url); // ← normalize on set too
}

Rx<int> currentPageIndex = 0.obs;

void setPageIndex(int index)async{
  currentPageIndex.value = index;
  canGoBackState.value = await Get.find<WebDataController>().canGoBack();
}

// Returns the active controller based on current page
WebViewController get activeController {
  switch (currentPageIndex.value) {
    case 0: return homecontroller;
    case 1: return emagzineController;
    case 2: return foodController;
    case 3: return hospitalityController;
    case 4: return medicalController;
    case 5: return sportsController;
    default: return homecontroller;
  }
}
RxBool canGoBackState = false.obs;
Future<bool> canGoBack()async{
  switch (currentPageIndex.value) {
    case 0: return homecontroller.canGoBack();
    case 1: return emagzineController.canGoBack();
    case 2: return foodController.canGoBack();
    case 3: return hospitalityController.canGoBack();
    case 4: return medicalController.canGoBack();
    case 5: return sportsController.canGoBack();
    default: return homecontroller.canGoBack();
  }
}
Future<bool> goBack() async {
  if (await activeController.canGoBack()) {
    await activeController.goBack();
    return true;
  }
  return false;
}
}