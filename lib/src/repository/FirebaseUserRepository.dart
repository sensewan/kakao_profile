import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_profile/src/model/UserModel.dart';

class FirebaseUserRepository {
  static Future<String> signUp(UserModel user) async {
    //                                                                      ↱ 테이블로 생각하면 됨 (테이블 정보를 갖고옴)
    CollectionReference kakaoUsers = FirebaseFirestore.instance.collection("kakaoUsers");
    //                                 ↱ kakaoUsers 테이블에 추가
    DocumentReference drf = await kakaoUsers.add(user.toMap());

    print("파이어베이스 고유 ID key값--> ${drf.id.toString()}");
    //         ↱ id는 Document의 고유 key값으로 생각하면 됨
    return drf.id;
  }

  // uid를 가지고 유저가 있는지 확인하기
  static Future<UserModel> findUserByUid(String uid) async{

    // ↱ 파이어베이스 kakaoUsers테이블의 정보 갖고오기
    CollectionReference users = FirebaseFirestore.instance.collection("kakaoUsers");
    // users의 uid가 넘어온 uid랑 같은 경우 -> get() 함
    QuerySnapshot data = await users.where("uid", isEqualTo: uid).get();

    if(data.size == 0) {
      return null;
    }else { // 데이터가 있는 경우
      return UserModel.fromJson(data.docs[0].data(), data.docs[0].id);
    }
  }

  // 로그인한 날짜 변경하기
  static void updateLastLoginData(String docId, DateTime changeTime){

    CollectionReference users = FirebaseFirestore.instance.collection("kakaoUsers");
    // ↱ docId 해당하는 것을 select 함
    users.doc(docId).update({"date_last_login": changeTime});

  }


  // 유저정보 업데이트하기
  static void updateData(String docId, UserModel user){

    CollectionReference users = FirebaseFirestore.instance.collection("kakaoUsers");
    // ↱ docId 해당하는 것을 select 함
    users.doc(docId).update(user.toMap());

  }

  // 프로필이미지 변경하기                                             ↱ avatar_url 임
  static void updateImageUrl(String docId, String downloadUrl, String fieldName){

    CollectionReference users = FirebaseFirestore.instance.collection("kakaoUsers");
    // ↱ docId 해당하는 것을 select 함
    users.doc(docId).update({fieldName: downloadUrl});

  }



}