import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_profile/src/App.dart';
import 'package:kakao_profile/src/Profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '프로필 수정',
      theme: ThemeData.light().copyWith(primaryColor: Colors.white),
      debugShowCheckedModeBanner: false, // Debug 표시 안 보이게 하기

      home: Profile(),
    );
  }
}
