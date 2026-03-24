import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotlightqa/controller/WebDataController.dart';
import 'package:spotlightqa/views/utils/Colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final webCon = Get.find<WebDataController>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return AppBar(
         backgroundColor: Colors.white,
         leading: Obx(() {
  return webCon.canGoBackState.value
      ? GestureDetector(
          onTap: () async {
            final wentBack = await webCon.goBack();

            // 🔥 update again after back
            webCon.canGoBackState.value = await webCon.canGoBack();

            if (!wentBack && context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Icon(Icons.arrow_back_ios),
        )
      : SizedBox();
}),
         centerTitle: true, // This centers the title completely
         automaticallyImplyLeading: false, // ✅ removes default back icon
         title: Image.asset(
        'assets/images/logo-1.png',
        width: 120,
        height: 60,
         ),
       );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}