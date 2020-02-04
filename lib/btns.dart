import 'package:flutter/material.dart';

class BorderedBtn extends StatefulWidget{
  final String _text;
  final Function _onPressed;

  BorderedBtn(
    this._text,
    this._onPressed
  );

  @override
  State<BorderedBtn> createState() {
    return _BorderedBtn(_text, _onPressed);
  }
}

class _BorderedBtn extends State<BorderedBtn>{
  Color _bgColor = Colors.transparent;
  Color _textColor = Colors.black;

  String _text;
  Function _onPressed;

  _BorderedBtn(
    String text,
    Function onPressed
  ){
    _text = text;
    _onPressed = onPressed;
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: _onPressed,
      child: Text(
        _text,
        style: TextStyle(
          color: _textColor,
          fontSize: 12.0,
        ),
      ),
      color: _bgColor,
      elevation: 0,
      hoverElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      disabledElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0)
        ),
        side: BorderSide(
          color: Color(0xFFE42313),
          width: 1,
          style: BorderStyle.solid
        )
      ),
      padding: EdgeInsets.fromLTRB(18, 11, 19, 12),
      onHighlightChanged: (bool state){
        if (state)
          setState(() {
            _bgColor = Color(0xFFE42313);
            _textColor = Colors.white;
          });
        else
          setState(() {
            _bgColor = Colors.transparent;
            _textColor = Colors.black;
          });
      }
    );
  }
}