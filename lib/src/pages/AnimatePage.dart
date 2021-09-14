import 'package:flutter/material.dart';

class AnimatePage extends StatefulWidget {
  AnimatePage({Key key}) : super(key: key);

  @override
  _AnimatePageState createState() => _AnimatePageState();
}

class _AnimatePageState extends State<AnimatePage> {
  // state variables                           <-- state
  final _myDuration = Duration(seconds: 1);
  var _col1 = Colors.transparent;
  var _boxColor = Color(0xFF00BB00);
  bool chk = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child:

          // Update this code                  <-- AnimatedContainer
          AnimatedContainer(
            color: _col1,
            duration: _myDuration,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                  border: Border.all(width: 4, color: _boxColor)
              ),
            ),
          ),
        ),
        updateStateButton()
      ],
    );
  }

  Align updateStateButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 100),
        child: RaisedButton(
          child: Text('Update State'),
          onPressed: () {
            chk
            ?setState(() { //                    <-- update state
              _boxColor = Color(0xFF00BB00);
              chk = false;
              print(chk);
            })
            :setState(() { //                    <-- update state
              _boxColor = Colors.transparent;
              chk = true;
              print(chk);
            });
          },
        ),
      ),
    );
  }
}

