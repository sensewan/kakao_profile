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



}