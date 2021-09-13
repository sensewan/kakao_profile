import 'package:get/get.dart';

class ProfileController extends GetxController{

  RxBool isEditMyProfile = false.obs;    // 프로필 편집을 클릭을 해서 편집 상태인지 확인

  @override
  void onInit() {
    isEditMyProfile(false);
    super.onInit();
  }

  void toggleEditProfile() {
    isEditMyProfile(!isEditMyProfile.value);
  }
}