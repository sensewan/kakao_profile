import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageCropController extends GetxController {
  static ImageCropController get to => Get.find();

  Future<File> selectImage() async{
    PickedFile myPickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if(myPickedFile == null) return null;

    return File(myPickedFile.path);
  }
  
  
}