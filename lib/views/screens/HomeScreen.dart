
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spotlightqa/controller/HomepageController.dart';
import 'package:spotlightqa/views/screens/FoodMag.dart';
import 'package:spotlightqa/views/screens/HealthcareMag.dart';
import 'package:spotlightqa/views/screens/HomePage.dart';
import 'package:spotlightqa/views/screens/SportsMag.dart';
import 'package:spotlightqa/views/screens/TourismMag.dart';
import 'package:spotlightqa/views/screens/schoolmag.dart';
import 'package:spotlightqa/views/widgets/CustomAppBar.dart';
import 'package:spotlightqa/views/widgets/CustomBottomBar.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/main-page";
  final HomePageController controller = Get.put(HomePageController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          final pop = await controller.willPop();
          if (pop) {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            appBar: CustomAppBar(),
            body: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: controller.onPageChanged,
                    controller: controller.pageController,
                    itemBuilder: (ctx, index) {
                      if (index == 1) return spotlightqa();
                      if (index == 2) return FoodMag();
                      if (index == 3) return const TourismMag();
                      if (index == 4) return const HealthcareMag();
                      if (index == 5) return const SportsMag();
                      return const HomePage();
                    },
                  ),
                ),
                
              ],
            ),
           bottomNavigationBar: CustomBottomBar(onTabChanged: controller.onTabChanged)
          ),
      );
  }
}