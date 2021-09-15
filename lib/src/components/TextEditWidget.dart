import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_profile/src/controller/ProfileController.dart';

class TextEditWidget extends StatefulWidget {
  const TextEditWidget({Key key, this.inText}) : super(key: key);
  final String inText;

  @override
  _TextEditWidgetState createState() => _TextEditWidgetState();
}

class _TextEditWidgetState extends State<TextEditWidget> {

  TextEditingController _textEditingController;

  @override
  void initState(){
    _textEditingController = TextEditingController();
    // ↱ 초기화 될 때 전달 받은 텍스트 값을 넣어줌
    _textEditingController.text = widget.inText;
    super.initState();
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              ProfileController.to.clickEditProfile();
              Get.back();
            },
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.white, size: 16,),
                Text("취소",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              ProfileController.to.clickEditProfile();
              //       ↱ result라는 이름으로 dialog에 argument전달하기 (입력한 텍스트 값)
              Get.back(result: _textEditingController.text);
            },
            child: Text("완료",
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),

        ],
      ),
    );
  }

  Widget _editTextFiled() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextField(
          controller: _textEditingController,  // 컨트롤러 등록해 놓으면 기본 텍스트 값이 들어간다.
          maxLength: 20,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.white),  // 글자 입력시 스타일

          decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: 18, color: Colors.white),
            counterStyle: TextStyle(fontSize: 14, color: Colors.white),
            enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            ),
            border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(0), // 다이얼 로그는 기본 insetPadding이 잡혀져 있음..
      elevation: 0, // 그림자 사라지게 하기
      backgroundColor: Colors.transparent,
      child: Column(
        children: [
          _header(),
          Expanded(
            child: _editTextFiled(),
          ),
          TextButton(
            onPressed: () {
              ProfileController.to.clickEditProfile();
              Get.back();
            },
            child: Text("close", style: TextStyle(fontSize: 20),),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xffEBAF64)),
            ),
          ),
        ],
      ),
    );
  }
}
