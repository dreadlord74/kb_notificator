import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:kb_notificator/btns.dart';
import 'package:kb_notificator/generalDialog/generalDialog.dart';
import 'package:kb_notificator/home/HomePage.dart';
import 'package:kb_notificator/user/user.dart';

class SettingsForm extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SettingsForm();
  }
}

class _SettingsForm extends State<SettingsForm>{
  final _formKey = GlobalKey<FormState>();
  String phone = " ";
  String token;
  User _curUser;

  @override
  void initState() {
    super.initState();

    final FirebaseMessaging _fcm = FirebaseMessaging();

    _fcm.getToken().then((String token) async{
      await _loadUser();
      setState(() {

        if (_curUser != null)
          phone = _curUser.phone;

        this.token = token;
        print(this.token);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(35),
      child: FutureBuilder(
        future: _loadUser(),
        builder: (ctx, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            if (snapshot.data != null){
              this.phone = snapshot.data.phone;
            }

            return _getForm(context);
          }
          
          return Container();
        },
      ),
    );
  }

  Future<User> _loadUser() async{
    _curUser = await User.getUser();

    return _curUser;
  }

  Form _getForm(context){
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _getPhoneField(),
          SizedBox(
            height: 60.0,
          ),
          BorderedBtn(
            "Сохранить", 
            () async {
              if(_formKey.currentState.validate()){
                print(phone);
                print(token);

                if (_curUser == null)
                  await User.createUser(User(
                    phone: phone,
                    token: token
                  ));
                else{
                  await _curUser.updatePhone(phone);
                  await _curUser.updateToken(token);
                }

                Navigator.of(context).push(
                  PopupDialog(
                    context, 
                    "Уведомление", 
                    "Номер телефона успешно сохранён", 
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

                // showDialog(
                //   barrierDismissible: false,
                //   builder: (ctx){
                //     return AlertDialog(
                //       title: Text(
                //         "Уведомление",
                //         style: TextStyle(
                //           fontSize: 12,
                //           fontWeight: FontWeight.w400,
                //           color: Color(0xFFADAEB5),
                //         ),
                //       ),
                //       content: Text(
                //         "Номер телефона успешно сохранён"
                //       ),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(20.0),
                //           topRight: Radius.circular(20.0),
                //         )
                //       ),
                //       actions: <Widget>[
                //         FlatButton(
                //           child: Text("Ок"),
                //           onPressed: (){
                //             Navigator.pushAndRemoveUntil(
                //               context,
                //               MaterialPageRoute(builder: (context) => HomePage()),
                //               (Route<dynamic> route) => false,
                //             );
                //           },
                //         )
                //       ],
                //     );
                //   },
                //   context: context
                // );
              }
            }
          ),
        ],
      ),
    );
  }

  Widget _getPhoneField(){
		return TextFormField(
			controller: MaskedTextController(
				mask: '(900) 000-00-00'
			),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.0
      ),
			decoration: InputDecoration(
				hintText: "(900) 000-00-00",
				prefixText: "+7 ",
        contentPadding: EdgeInsets.fromLTRB(0, 6, 0, 10),
        labelText: "Введите ваш телефон",
        labelStyle: TextStyle(
          color: Color(0xFFADAEB5),
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
			),
			inputFormatters: <TextInputFormatter>[
				WhitelistingTextInputFormatter.digitsOnly
			],
			maxLength: 15,
      onChanged: (value){
        phone = value;
      },
			keyboardType: TextInputType.phone,
			validator: (String value){
				if (value.isEmpty)
					return "Номер не введён";
				
				// var regExp = RegExp('^\d{3}\d{3}\d{2}\d{2}');

				// if (!regExp.hasMatch(value))
				// 	return "Введён неверный номер телефона";

				return null;
			},
		);
	}
}