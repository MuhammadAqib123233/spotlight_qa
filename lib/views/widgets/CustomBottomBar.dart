import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:spotlightqa/controller/WebDataController.dart';
import 'package:spotlightqa/views/screens/schoolmag.dart';
import 'package:spotlightqa/views/screens/FoodMag.dart';
import 'package:spotlightqa/views/screens/HomePage.dart';
import 'package:spotlightqa/views/screens/TourismMag.dart';
import 'package:spotlightqa/views/utils/Colors.dart';

class CustomBottomBar extends StatelessWidget{
  Function(int) onTabChanged;
  CustomBottomBar({super.key, required this.onTabChanged});

  WebDataController webCon = Get.find<WebDataController>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BottomAppBar(
      height: 70,
  color: AppColors().primaryColor,
  elevation: 0, // Remove elevation to make icons align at the center
  child: Padding(
    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Horizontally center the icons
      crossAxisAlignment: CrossAxisAlignment.center, // Vertically center the icons
      children: [
    InkWell(
      onTap: (){
       onTabChanged(0);
       webCon.setPageIndex(0); 
      },
      child: Icon(Icons.home,
      color: AppColors().iconColor,
      size: 30,
      ),
    ), // Add spacing between icons
    InkWell(
       onTap: (){
       onTabChanged(1);
        webCon.setPageIndex(1); 
      },
      child: Icon(Icons.menu_book,
      color: AppColors().iconColor,
      size: 30,
      ),
    ),
   InkWell(
    onTap: (){
        onTabChanged(2);
        webCon.setPageIndex(2); 
      },
      child: Icon(Icons.restaurant,
      color: AppColors().iconColor,
      size: 30,
      ),
   ),
   InkWell(
    onTap: (){
        onTabChanged(3);
        webCon.setPageIndex(3); 
      },
      child: Icon(Icons.hotel,
      color: AppColors().iconColor,
      size: 30,
      ),
   ),
   InkWell(
    onTap: (){
        onTabChanged(4);
        webCon.setPageIndex(4); 
      },
      child: Icon(Icons.medical_services,
      color: AppColors().iconColor,
      size: 30,
      ),
   ),
   InkWell(
    onTap: (){
        onTabChanged(5);
        webCon.setPageIndex(5 ); 
      },
      child: Icon(Icons.sports,
      color: AppColors().iconColor,
      size: 30,
      ),
   )
      ],
    ),
  ),
);
  }

}