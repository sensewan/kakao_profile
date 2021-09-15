import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kakao_profile/src/controller/ProfileController.dart';

class ImageCropController extends GetxController {
  static ImageCropController get to => Get.find();

  Future<File> selectImage(ProfileImageType type) async{
    PickedFile myPickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if(myPickedFile == null) return null;

    return _cropImage(myPickedFile, type);
  }


  // 이미지 크롭 기능
  Future<File> _cropImage(PickedFile imageFile, ProfileImageType type) async{

    // ↱ 썸네일이냐 백그라운이냐에 따라서 크롭 할 수 있는 크기를 따로 지정하기 위한 리스트
    List<CropAspectRatioPreset> presets = [];

    switch(type) {
      case ProfileImageType.Thumbnail:
        presets = [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.original,
        ];
        break;
      case ProfileImageType.Background:
        presets=[
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
        ];
        break;
    }

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: presets,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        )
    );

    return croppedFile;
  }

  
}