// import 'dart:convert';

import 'package:kb_notificator/database/database.dart';
import 'package:kb_notificator/notofications/notification.dart';
import 'package:sqflite/sqflite.dart';

class Notifications{
  static addMessage(NotificationMessage msg) async {
    final Database _db = await DBProvider.db.database;

    var result = await _db.rawInsert(
      "INSERT INTO Messages (title, body, messageSendTime, messageReceiveTime, status)"
      " VALUES ('${msg.title}', '${msg.body}', '${msg.sendTime}', '${msg.receiveTime}', '${msg.status}')"
    );

    return result;
  }

  static getMessages() async {
    final Database _db = await DBProvider.db.database;

    var result = await _db.query(
      "Messages"
    );

    return result.isNotEmpty 
      ? result.map(
          (item) => NotificationMessage.fromJson(item)
        ).toList()
      : [];
  }

  static getMessageByID(int msgID) async{
    final Database _db = await DBProvider.db.database;

    var result = await _db.query(
      "Messages",
      where: "id = ?",
      whereArgs: [msgID]
    );
    
    return result.isNotEmpty
      ? result.map(
        (item) => NotificationMessage.fromJson(item)
      ).toList()[0]
      : null;
  }
}