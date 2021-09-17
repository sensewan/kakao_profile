import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_profile/src/controller/ProfileController.dart';
import 'package:kakao_profile/src/pages/LoginPage.dart';
import 'package:kakao_profile/src/pages/Profile.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  // 로그인 처리 하기
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //       ↱ 파이어 베이스에서 로그인 되어 있는 유저 있는지 확인
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot){
        //                                       ↱로그인된 유저 정보 넘겨주기
        ProfileController.to.myAuthStateChanges(snapshot.data);

        if(!snapshot.hasData) {
          print("Home.dart에서 로긴페이지로 이동 (아직 구글 로긴 안됨)");
          return LoginPage();

        }else {
          print("Home.dart에서 프로필 페이지로 이동 (구글 로긴 성공)");
          return Profile();
        }
      }
    );
  }
}
