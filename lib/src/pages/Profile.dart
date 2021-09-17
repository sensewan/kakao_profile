import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_profile/src/components/TextEditWidget.dart';
import 'package:kakao_profile/src/controller/ImageCropController.dart';
import 'package:kakao_profile/src/controller/ProfileController.dart';
import 'package:kakao_profile/src/pages/AnimatePage.dart';

class Profile extends GetView<ProfileController> {
  const Profile({Key key}) : super(key: key);


  // ########## 헤더 부분 ###############
  Widget _header(){
    return Positioned(
      // bottom에 사이즈를 지정하지 않는 이유는 알아서 되게 할려고??
      top: Get.mediaQuery.padding.top,  // 아래에서 SafeArea를 해도 되지만 그렇게 되면 백그라운드 이미지가 맨 위에 들어가지지 않음.
      //    ↳ 현재 사용자 기기의 상태바의 크기를 구할 수 있다
      left: 0,
      right: 0,
      child: Obx(()=>
        Container(
          padding: const EdgeInsets.all(15),
          child: controller.isEdituserModel.value
            ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: controller.rollback,
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_ios, color: Colors.white, size: 16,),
                      Text("프로필 편집",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: controller.save,
                  child: Text("완료",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),

              ],
            )
            :Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.close_sharp, color: Colors.white,),
                Row(
                  children: [
                    Icon(Icons.qr_code, color: Colors.white,),
                    SizedBox(width: 10,),
                    Icon(Icons.settings, color: Colors.white,),
                  ],
                )
              ],
            )
        ),),
    );
  }


  // ################## 푸터 부분 ##############
  Widget _footer(){
    return Obx(()=>
      // isEdituserModel의 bool 값에 따라 화면 보이게 히기
      controller.isEdituserModel.value
      ? Container()
      :Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration( // 가로 줄 하나 넣기
            border: Border(
              top: BorderSide(
                width: 1,
                color: Colors.white.withOpacity(0.4)
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _oneButton(Icons.chat_bubble, "나와의 채팅", (){}),
              _oneButton(Icons.edit, "프로필 편집", controller.toggleEditProfile),  // 프로필 편집 클릭하면 -> bool값 변경시켜서 -> 편집가능하게 하기
              _oneButton(Icons.chat_bubble_outline, "카카오 스토리", (){
                Get.to(AnimatePage());
              }),
            ],
          ),
        ),
      ),);
  }

  Widget _oneButton(IconData icon, String title, Function inOntap) {
    return GestureDetector(
      onTap: inOntap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white,),
          SizedBox(height: 10,),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.white,),
          ),
        ],
      ),
    );
  }



  // ############# 프로필 이미지 및 네임, 설명 부분 ###############
  Widget _userModel() {
    return Positioned(
        bottom: 120,
        left: 0,
        right: 0,
        child: Container(
          height: 230,
          child: Obx(()=>
            Column(
              children: [
                _profileImage(),
                controller.isEdituserModel.value ? _editProfileInfo() : _profileInfo(),
              ],
          ),
        ),),
    );
  }

  // ### 프로필 이미지  ###
  Widget _profileImage() {
    return GestureDetector(
      onTap: () {
        if(controller.isEdituserModel.value){
          controller.pickImage(ProfileImageType.Thumbnail);
        }
      },
      child: Container(
        width: 120,
        height: 120,
        child: Stack(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  width: 100,
                  height: 100,
                  child: controller.userModel.value.avatarFile == null
                    ?Image.network(
                      "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg",
                      fit: BoxFit.cover, // 이미지 box에 꽉 채우기
                    )
                    :Image.file(
                      controller.userModel.value.avatarFile,
                      fit: BoxFit.cover,
                    ),
                ),
              ),
            ),
            controller.isEdituserModel.value
            ? Positioned(
                left: 0, right: 0, top: 0, bottom: 0,
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.all(7), // BoxDecoration의 circle을 icon보다 크게 하기 위해 padding 줌
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                    ),
                  ),
                ),
              )
            : Container(),
          ],
        ),
      ),
    );
  }

  // ### 프로필 이름, 설명 ###
  Widget _profileInfo(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(controller.userModel.value.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        Text(controller.userModel.value.discription,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }


  // ########## 프로필 네임, 설명 수정 ###########
  // 프로필 편집 클릭 후 -> 이동시 사용됨(텍스트들 보여줌)
  Widget _editProfileInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(()=>
        Column(
          children: [
            //                ↱보여질 텍스트                   ↱ onTap기능
            _partProfileInfo(controller.userModel.value.name, () async{
              controller.clickEditProfile();
              //                    ↱팝업 띄우기 -> 다른페이지 보여주기
              String value= await Get.dialog(TextEditWidget(inText:controller.userModel.value.name));
              //     ↳Get.back를 통해 데이터 받기              ↳이동하면서 파라미터 넘겨주기
              if(value != null) {
                controller.updateName(value);
              }
            }),
            _partProfileInfo(controller.userModel.value.discription, () async{
              controller.clickEditProfile();
              //                    ↱팝업 띄우기 -> 다른페이지 보여주기
              String value= await Get.dialog(TextEditWidget(inText:controller.userModel.value.discription));
              //     ↳Get.back를 통해 데이터 받기              ↳이동하면서 파라미터 넘겨주기
              if(value != null) {
                controller.updateDiscription(value);
              }
            }),
          ],
      ),),
    );
  }

  // ## 프로필 편집으로 이동 되었을때 보여지는 텍스트들 ##
  Widget _partProfileInfo(String value, Function ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Stack(
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
              right: 0,
              bottom: 15,
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 18,
              )
          ),
        ],
      ),
    );
  }



  // ########### 백그라운드 이미지 #########
  Widget _backgroundImage(){
    return Positioned(
      top: 0, right: 0, bottom: 0, left: 0,   // 이렇게 다 0으로 주면 전체 영역을 잡는다.
      child: GestureDetector(
        onTap: () {
          if(controller.isEdituserModel.value){
            controller.pickImage(ProfileImageType.Background);
          }
        },
        child: Obx(()=>
          Container(
            color: Colors.transparent,
            child: controller.userModel.value.backgroundFile == null
              ?Container()
              :Image.file(
                controller.userModel.value.backgroundFile,
                fit: BoxFit.cover,
              ),
            ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, // 이걸하면 텍스트 수정페이지(TextEditWidget)에서-> 수정할 때 움직이지 않는다.
      backgroundColor: Color(0xff3f3f3f),
      body: Obx(()=>
        Container(
          child: Stack(
            children: [
              _backgroundImage(),
              // ↱ 프로필 편집 버튼 클릭시 -> header 부분 보여지거나 안 보여지게 하기
              !controller.editProfileClick.value
              ?_header()
              :Container(),

              _userModel(),
              _footer(),
          ],),
        ),
      ),
    );
  }
}
