import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:kb_notificator/user/user.dart';

class SettingsForm extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SettingsForm();
  }
}

class _SettingsForm extends State<SettingsForm>{
  final _formKey = GlobalKey<FormState>();
	// final User _user;

	// _SettingsForm (){
	// 	// user = User();
	// }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _getPhoneField(),
            SizedBox(
							height: 25.0,
						),
						RaisedButton(
							onPressed: (){
								print(_formKey.currentState.validate());
							},
							child: Text("Сохранить"),
						)
          ],
        ),
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

				print(value);
				
				var regExp = RegExp(r'^\d{3}\d{3}\d{2}\d{2}');

				if (!regExp.hasMatch(value))
					return "Введён неверный номер телефона";

				return null;
			},
		);
	}
}