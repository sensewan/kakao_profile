import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_profile/src/pages/Home.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Center(
            child: Text(
              "파이어베이스 로드 실패!!"
            ),
          );
        }
        if(snapshot.connectionState == ConnectionState.done){
          return Home(); // 로그인 처
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }
}
