import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';

class InternetCheckService extends GetxController {
  RxBool hasInternet = true.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startMonitoring();
  }

  void startMonitoring() {
    checkInternet(); // initial check

    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      checkInternet();
    });
  }

  Future<void> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(Duration(seconds: 5));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasInternet.value = true;
      } else {
        hasInternet.value = false;
      }
    } catch (_) {
      hasInternet.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}