import 'dart:convert';

import 'package:kb_notificator/notofications/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications{
  final List<Message> _notificationsList = [];
  SharedPreferences _prefs;

  Notifications(){
    _classInit();
  }

  _classInit() async{
    _prefs = await SharedPreferences.getInstance();

    // await _prefs.get("message")'

    Message msg = Message(
      title: "Тестовый заголовокasdf",
      body: "Тестовый текстsda",
      status: "waiting"
    );

    await _prefs.setString("notifications", msg.toJson().toString());

    var msgData = (json.decode(_prefs.getString("notifications")) as Map) as Map<String, dynamic>;

    // print(msgData);

    var newMessage = Message.fromJson(msgData);
  }
}