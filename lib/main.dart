import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_profile/src/App.dart';
import 'package:kakao_profile/src/Profile.dart';
import 'package:kakao_profile/src/controller/ImageCropController.dart';
import 'package:kakao_profile/src/controller/ProfileController.dart';

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


      // ↱ Profile() 페이지로 이동 되고나서 컨트롤로 생성 됨 ( Profile()에서 GetView<ProfileController> 사용함
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<ProfileController>(() => ProfileController());
        Get.lazyPut<ImageCropController>(() => ImageCropController());
      }),
      home: Profile(),
    );
  }
}
