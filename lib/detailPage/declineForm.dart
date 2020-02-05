import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kb_notificator/CustomTheme.dart';
import 'package:kb_notificator/btns.dart';
import 'package:kb_notificator/generalDialog/generalDialog.dart';
import 'package:kb_notificator/home/HomePage.dart';
import 'package:kb_notificator/notofications/notifications.dart';

class DeclineForm extends StatefulWidget{
  final int _msgID;

  DeclineForm(this._msgID);

  @override
  State<DeclineForm> createState() {
    return _DeclineForm(_msgID);
  }
}

class _DeclineForm extends State<DeclineForm>{
  final _msgID;
  final _formKey = GlobalKey<FormState>();
  String _comment = "";

  _DeclineForm(this._msgID);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6)
              ),
              width: double.infinity,
              height: 110.0,
              child: _getTextField(),
            ),
            SizedBox(
              height: 25,
            ),
            _getButtons()
          ],
        ),
      ),
    );
  }

  TextField _getTextField(){
    return TextField(
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        // border: BorderSide(
        //   borderRadius: BorderRadius.circular(5.0),
        //   borderSide: BorderSide(
        //     color: Colors.transparent,
        //     style: BorderStyle.solid
        //   )
        // ),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: CurstomTheme().getTheme().primaryColor,
            style: BorderStyle.solid
          )
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 17
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: "Введите причину отказа",
        hintStyle: TextStyle(
          color: Color(0xFFADAEB5)
        )
      ),
      keyboardType: TextInputType.text,
      maxLines: 100,
      onChanged: (String value){
        setState(() {
          _comment = value;
        });
      },
      // validator: (String value){
      //   if (value.isEmpty)
      //     return "Поле обязательно для заполнения.";

      //   return null;
      // },
    );
  }

  _getButtons(){
    return 
      Row(
        children: <Widget>[
          BorderedBtn("Отмена", () {
            Navigator.of(context).pop();
          }),
          SizedBox(
            width: 15,
          ),
          WhiteBtn("Отправить", () async{
            var res = await Notifications.setMessageStatusByID(
              _msgID,
              "decline",
              _comment
            );
            
            Navigator.of(context).push(
              PopupDialog(
                context, 
                "Уведомление", 
                "Вы успешно отказались", 
                "Ок", 
                (){
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false,
                  );
                },
              )
            );
          })
        ],
      );
  }

}