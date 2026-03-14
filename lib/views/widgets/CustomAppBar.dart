import 'package:flutter/material.dart';
import 'package:spotlightqa/views/utils/Colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return AppBar(
  backgroundColor: Colors.white,
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