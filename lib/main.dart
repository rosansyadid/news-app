import 'package:flutter/material.dart';
import 'package:news_app/controller/news_controller.dart';
import 'package:news_app/screen/news_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NewsController c = Get.put(NewsController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: ApiScreen(),
    );
  }
}
