import 'dart:io';

import 'package:get/get.dart';
import 'package:kakao_profile/src/controller/ImageCropController.dart';
import 'package:kakao_profile/src/model/UserModel.dart';

// 배경화면 변경인지 썸네일 변경인지 알기 위한 enum
enum ProfileImageType{
  Thumbnail,
  Background
}

class ProfileController extends GetxController{
  static ProfileController get to => Get.find();

  RxBool isEdituserModel = false.obs;    // 프로필 편집을 클릭을 해서 편집 상태인지 확인
  RxBool editProfileClick = false.obs;   //  프로필 편집에서 Dialog 띄웠을 때 뒤에 header 보이거나 안 보이게 하기

  UserModel originModel = UserModel(
      name: "데드리프트",
      discription: "3대 500 가즈아"
  );

  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    isEdituserModel(false);
    editProfileClick(false);

    userModel(originModel);
    super.onInit();
  }

  // 클릭시 true, false로 변경되게 하기 (footer 부분 보이게 하거나 안 보이게 하고, 가운데를 프로필 편집창으로 바꾸기, headr 아이콘 변경)
  void toggleEditProfile() {
    isEdituserModel(!isEdituserModel.value);
  }

  // 클릭시 true, false로 변경되게 하기 (프로필 편집에서 Dialog 띄웠을 때 뒤에 header 보이거나 안 보이게 하기)
  void clickEditProfile(){
    editProfileClick(!editProfileClick.value);
    print('editProfileClick-> $editProfileClick');
  }


  // 롤백 관련
  void rollback() {
    print("롤백!!~");
    userModel.value.initImageFile();

    userModel(UserModel.clone(originModel));  // 이게 맞나...
    // userModel(originModel);
    toggleEditProfile();
  }

  // 이름 변경
  void updateName(String inputName){
    userModel.update((val) {
      val.name = inputName;
    });
  }

  // 자기소개 변경
  void updateDiscription(String inputDiscription){
    userModel.update((model) {
      model.discription = inputDiscription;
    });
  }

  // 이미지 변경
  void pickImage(ProfileImageType type) async{

    File imageFile = await ImageCropController.to.selectImage();

    if(imageFile == null) return;

    switch(type){
      case ProfileImageType.Thumbnail:
        userModel.update((model) {
          model.avatarFile = imageFile;
        });
        break;
      case ProfileImageType.Background:
        userModel.update((model) {
          model.backgroundFile = imageFile;
        });
        break;
    }
  }

  // 프로필 저장하기 (한 번에 처리 할 수 있지만, 만약 파일저장이 오류로 인해 안 될경우를 대비해 나눠서 함)
  void save() {
    originModel = userModel.value;
    toggleEditProfile();
  }

}