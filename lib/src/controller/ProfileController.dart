import 'package:get/get.dart';
import 'package:kakao_profile/src/model/UserModel.dart';

class ProfileController extends GetxController{

  RxBool isEditMyProfile = false.obs;    // 프로필 편집을 클릭을 해서 편집 상태인지 확인
  Rx<UserModel> myProfile = UserModel(
    name: "데드리프트",
    discription: "3대 500 가즈아"
  ).obs;

  @override
  void onInit() {
    isEditMyProfile(false);
    super.onInit();
  }

  // 클릭시 true, false로 변경되게 하기 (footer 부분 보이게 하거나 안 보이게 하고, 가운데를 프로필 편집창으로 바꾸기, headr 아이콘 변경)
  void toggleEditProfile() {
    isEditMyProfile(!isEditMyProfile.value);
  }


  // 이름 변경
  void updateName(String inputName){
    myProfile.update((val) {
      val.name = inputName;
    });
  }

  // 자기소개 변경
  void updateDiscription(String inputDiscription){
    myProfile.update((model) {
      model.discription = inputDiscription;
    });
  }

}