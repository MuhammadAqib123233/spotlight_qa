import 'package:spotlightqa/controller/WebDataController.dart';
import 'package:spotlightqa/services/CheckInternetService.dart';
import 'package:spotlightqa/views/screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotlightqa/views/screens/HomeScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spotlight Qa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      initialBinding: AppBindings(),
    );
  }
}

class AppBindings extends Bindings{
   @override
  void dependencies() {
    Get.put<WebDataController>(WebDataController(), permanent: true);
    Get.put<InternetCheckService>(InternetCheckService(), permanent: true);
  }
}