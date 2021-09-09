import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  const Profile({Key key}) : super(key: key);


  // ########## 헤더 부분 ###############
  Widget _header(){
    return Positioned(
      // bottom에 사이즈를 지정하지 않는 이유는 알아서 되게 할려고??
      top: Get.mediaQuery.padding.top,  // 아래에서 SafeArea를 해도 되지만 그렇게 되면 백그라운드 이미지가 맨 위에 들어가지지 않음.
      //    ↳ 현재 사용자 기기의 상태바의 크기를 구할 수 있다
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                print("프로필 편집 클릭함");
              },
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
              onTap: () {
                print("완료 클릭함");

              },
              child: Text("완료",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),

          ],
        ),
      ),
    );
  }


  // ################## 푸터 부분 ##############
  Widget _footer(){
    return Positioned(
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
            _oneButton(Icons.edit, "프로필 편집", (){}),
            _oneButton(Icons.chat_bubble_outline, "카카오 스토리", (){}),
          ],
        ),
      ),
    );
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



  // ############# 프로필 이미지 부분 ###############
  Widget _myProfile() {
    return Positioned(
      bottom: 120,
      left: 0,
      right: 0,
      child: Container(
        height: 200,
        child: Column(
          children: [
            _profileImage(),
            _profileInfo(),
          ],
        ),
      )
    );
  }

  // ### 프로필 이미지  ###
  Widget _profileImage() {
    return Container(
      width: 120,
      height: 120,
      child: ClipRRect(  // 이미지 모서리 둥글게 하기 위해 사용
        borderRadius: BorderRadius.circular(40),
        child: Image.network(
          "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg",
          fit: BoxFit.cover, // 이미지 box에 꽉 채우기
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
          child: Text("데드리프트",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        Text("3대 600가즈아",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }



  // ########### 백그라운드 이미지 #########
  Widget _backgroundImage(){
    return Positioned(
      top: 0, right: 0, bottom: 0, left: 0,   // 이렇게 다 0으로 주면 전체 영역을 잡는다.
      child: GestureDetector(
        onTap: () {
          print("백그라운드 클림됨!!");
        },
        child: Container(
          color: Colors.transparent,
        ),
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3f3f3f),
      body: Container(
        child: Stack(children: [
          _backgroundImage(),
          _header(),
          _myProfile(),
          _footer(),
        ],),
      ),
    );
  }
}
