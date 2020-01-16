import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
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
      padding: EdgeInsets.all(20),
      child: FutureBuilder(
        future: _loadUser(),
        builder: (ctx, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            if (snapshot.data != null){
              this.phone = snapshot.data.phone;
            }

            return _getForm();
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

  Form _getForm(){
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _getPhoneField(),
          SizedBox(
            height: 25.0,
          ),
          RaisedButton(
            onPressed: () async {
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

                showDialog(
                  barrierDismissible: false,
                  builder: (ctx){
                    return AlertDialog(
                      title: Text("Уведомление"),
                      content: Text(
                        "Номер телефона успешно сохранён"
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Ок"),
                          onPressed: (){
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                              (Route<dynamic> route) => false,
                            );
                          },
                        )
                      ],
                    );
                  },
                  context: context
                );
              }
            },
            child: Text("Сохранить"),
          )
        ],
      ),
    );
  }

  Widget _getPhoneField(){
		return TextFormField(
			controller: MaskedTextController(
				mask: '(900) 000-00-00'
			),
			decoration: InputDecoration(
				hintText: "Введите номер телефона",
				prefixText: "+7 ",
				icon: Icon(
					Icons.phone,
					color: Color(0XFFDBDBDB),
				)
			),
			inputFormatters: <TextInputFormatter>[
				WhitelistingTextInputFormatter.digitsOnly
			],
			maxLength: 15,
			keyboardType: TextInputType.phone,
			validator: (String value){
				if (value.isEmpty)
					return "Номер не введён";
				
				var regExp = RegExp(r'^\d{3}\d{3}\d{2}\d{2}');

				if (!regExp.hasMatch(value))
					return "Введён неверный номер телефона";

        setState(() {
          phone = value;
        });

				return null;
			},
		);
	}
}