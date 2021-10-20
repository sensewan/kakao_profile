import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:kakao_profile/src/controller/ImageCropController.dart';
import 'package:kakao_profile/src/model/UserModel.dart';
import 'package:kakao_profile/src/repository/FirebaseStorageRepository.dart';
import 'package:kakao_profile/src/repository/FirebaseUserRepository.dart';

// 배경화면 변경인지 썸네일 변경인지 알기 위한 enum
enum ProfileImageType{
  Thumbnail,
  Background
}

class ProfileController extends GetxController{
  static ProfileController get to => Get.find();

  RxBool isEdituserModel = false.obs;    // 프로필 편집을 클릭을 해서 편집 상태인지 확인
  RxBool editProfileClick = false.obs;   //  프로필 편집에서 Dialog 띄웠을 때 뒤에 header 보이거나 안 보이게 하기

  UserModel originModel = UserModel();

  Rx<UserModel> userModel = UserModel().obs;

  FirebaseStorageRepository _firebaseStorageRepository = FirebaseStorageRepository();


  //                           ↱ 구글 로그인된 유저정보 받음
  void myAuthStateChanges(User firebaseUser) async {
    print("파이어베이스 유저 확인-> ${firebaseUser.toString()}");

    if(firebaseUser != null) {

      //        ↱ 등록된 유저가 있을 경우 signUp을 1번만 하기위해
      UserModel existUserModel = await FirebaseUserRepository.findUserByUid(firebaseUser.uid);

      if(existUserModel != null) { // 이미 회원가입 되어 있는 경우임
        originModel = existUserModel;
        // ↱ 로그인이 되었으므로 로그인 시간 업데이트 해주기
        FirebaseUserRepository.updateLastLoginData(existUserModel.docId, DateTime.now());
      }else {
        // ↱ 파이어베이스의 구글 로그인 정보를 가지고 UserModel 객체 생성하기
        originModel = UserModel(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName,
          avatarUrl: firebaseUser.photoURL,
          createdTime: DateTime.now(),
          lastLoginTime: DateTime.now(),
        );

        String docId = await FirebaseUserRepository.signUp(originModel);
        originModel.docId = docId;  // 파이어베이스 고유 id 키값 저장하기
      }
    }

    // ↱ userModel은 originModel의 값이 아닌 주소 값을 가지고 있으므로
    //   아래에서 update를 할경우 originModel의 값도 변경이 됨 -> 그러므로 clone 사용
    userModel(UserModel.clone(originModel));
    print("\n나와!!!-> ${userModel.value.avatarUrl.toString()}");

  }

  @override
  void onInit() {
    isEdituserModel(false);
    editProfileClick(false);

    // userModel(originModel);
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

    File imageFile = await ImageCropController.to.selectImage(type);

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

    // ↱프로필 변경에서 ##프로필## 이미지 파일 첨부할 경우-> 프로필 이미지 저장
    if(originModel.avatarFile != null){
      UploadTask task = _firebaseStorageRepository.uploadImageFile(originModel.uid, "profile", originModel.avatarFile);

      // ↱스트림을 받을 수 있음
      task.snapshotEvents.listen((event) async{
        //  ↱ 업로드 할 때 totalBytes가 되면 (즉 완료가 되면 실행)
        if(event.bytesTransferred == event.totalBytes){
          //   ↱ 업로드된 이미지의 주소를 구할 수 있음
          String downloadUrl = await event.ref.getDownloadURL();

          // ↱ 업로드한 이미지 내부 model에 적용하기
          _updateProfileImageUrl(downloadUrl);
          // ↱ 파이어베이스 유저정보에 이미지변경한 것 적용하기
          FirebaseUserRepository.updateImageUrl(originModel.docId, downloadUrl, "avatar_url");
        }

        print("프로필이미지 event.bytesTransferred--> ${event.bytesTransferred}");
      });

    }

    // ↱프로필 변경에서 ##백그라운드## 이미지 파일 첨부할 경우-> 백그라운드 이미지 저장
    if(originModel.backgroundFile != null){
      //
      UploadTask task = _firebaseStorageRepository.uploadImageFile(originModel.uid, "background", originModel.backgroundFile);
      // ↱스트림을 받을 수 있음
      task.snapshotEvents.listen((event) async{
        //  ↱ 업로드 할 때 totalBytes가 되면 (즉 완료가 되면 실행)
        if(event.bytesTransferred == event.totalBytes){
          //   ↱ 업로드된 이미지의 주소를 구할 수 있음
          String downloadUrl = await event.ref.getDownloadURL();

          // ↱ 업로드한 이미지 내부 model에 적용하기
          _updateBackgroundImageUrl(downloadUrl);
          // ↱ 파이어베이스 유저정보에 이미지변경한 것 적용하기
          FirebaseUserRepository.updateImageUrl(originModel.docId, downloadUrl, "background_url");
        }

        print("프로필이미지 event.bytesTransferred--> ${event.bytesTransferred}");
      });
    }



    // ↱ 파이어베이스에 프로필 네임 및 설명 업데이트 (파일 첨부 없는 경우)
    FirebaseUserRepository.updateData(originModel.docId, originModel);
    toggleEditProfile();
  }


  // 업로드한 프로필 이미지의 주소를 적용하기
  void _updateProfileImageUrl(String downloadUrl){
    originModel.avatarUrl = downloadUrl;
    userModel.update((val) {val.avatarUrl = downloadUrl;});
  }

  // 업로드한 백그라운드 이미지의 주소를 적용하기
  void _updateBackgroundImageUrl(String downloadUrl){
    originModel.backgroundUrl = downloadUrl;
    userModel.update((val) {val.backgroundUrl = downloadUrl;});
  }


}