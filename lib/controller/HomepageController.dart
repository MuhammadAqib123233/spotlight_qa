import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:spotlightqa/controller/WebDataController.dart';

class HomePageController extends GetxController{
  bool isloading = true;
  String url = "https://www.spotlight-qa.com/";
  int index = 0;
  final pageController = PageController();
  final selectedTab = 0.obs;
  loadview(){
    isloading = false;
    update();
  }
  navigateTo(String Url){
    url = Url;
    print(url);
    isloading=true;
    update();
  }

  void onPageChanged(int value) {
    selectedTab.value = value;
    // Get.find<WebDataController>().isLoading.value = true;
    // Get.find<WebDataController>().progress.value = 0;
  }

  void onTabChanged(int value) {
    print("[HomeController] Tab changed: $value");
    pageController.jumpToPage(value);
  }

  Future<bool> willPop() async {
    if (selectedTab.value != 0) {
      onPageChanged(0);
      onTabChanged(0);
      return false;
    }
    return true;
  }
}