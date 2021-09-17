import 'dart:io';

class UserModel {
  String uid;         // 파이어베이스 고유 ID
  String docId;       // 파이어스토어에 데이터 저장할 때의 document ID
  String name;
  String discription;
  String avatarUrl;
  String backgroundUrl;
  File avatarFile;
  File backgroundFile;
  DateTime lastLoginTime;
  DateTime createdTime;

  UserModel({
    this.uid,
    this.docId,
    this.name="",
    this.discription="",
    this.avatarUrl,
    this.backgroundUrl,
    this.lastLoginTime,
    this.createdTime,
    this.avatarFile,
    this.backgroundFile
  });


  // userModel을 컨트롤러에서 초기화 할 때 주소 값의 변경으로 인해 초기화가 안되는 것을 방지하기 위해 사용
  UserModel.clone(UserModel user) : this(
    uid : user.uid,
    docId : user.docId,
    discription : user.discription,
    avatarUrl: user.avatarUrl,
    name : user.name,
    backgroundUrl : user.backgroundUrl,
    lastLoginTime : user.lastLoginTime,
    createdTime : user.createdTime,
  );


  // 프로필 편집 취소했을 때 이미지 파일 초기화 하기
  void initImageFile(){
    avatarFile = null;
    backgroundFile = null;
  }


  UserModel.fromJson(Map<String, dynamic> json, String docId):
        uid = json["uid"] as String,
        docId = docId,
        name = json["name"] == null ? "" : json["name"] as String,
        discription = json["discription"] == null ? "" : json["discription"] as String,
        avatarUrl = json["avatar_url"] as String,
        backgroundUrl = json["background_url"] as String,
        lastLoginTime = json["last_login_time"].toDate(),
        createdTime = json["create_time"].toDate();


  // DB저장을 위해..(카멜캐이싱 지원안함)
  Map<String, dynamic> toMap(){
    return {
      "uid": this.uid,
      "name": this.name,
      "discription": this.discription,
      "avatar_url": this.avatarUrl,
      "background_url": this.backgroundUrl,
      "last_login_time": this.lastLoginTime,
      "create_time": this.createdTime,
    };
  }


}