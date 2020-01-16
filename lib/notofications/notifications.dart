// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kb_notificator/database/database.dart';
import 'package:kb_notificator/notofications/notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class Notifications{
  static addMessage(NotificationMessage msg) async {
    final Database _db = await DBProvider.db.database;

    var result = await _db.rawInsert(
      "INSERT INTO Messages (title, body, messageSendTime, messageReceiveTime, status)"
      " VALUES ('${msg.title}', '${msg.body}', '${msg.sendTime}', '${msg.receiveTime}', '${msg.status}')"
    );

	var androidPlatformChannelSpecifics = AndroidNotificationDetails(
			'Оповещение', 'Получение оповещений', 'Оповещение для водителей',
		importance: Importance.Max, priority: Priority.Max, ticker: 'ticker');
	var iOSPlatformChannelSpecifics = IOSNotificationDetails();
	var platformChannelSpecifics = NotificationDetails(
		androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

	final localNotifications = FlutterLocalNotificationsPlugin();

	var lastMessage = await Notifications.getLastMessage();

	await localNotifications.show(
		0, lastMessage.title, lastMessage.body, platformChannelSpecifics,
			payload: '${lastMessage.id}');

    return result;
  }

  static setMessageStatusByID(@required int messageID, @required String newStatus) async{
    final address = "http://gradus-nik.ru/api/?command=driversAppMessageSetStatus";

    switch (newStatus){
      case "accept":

      break;

      case "decline":

      break;
    }
  }

  static Future<List<NotificationMessage>> getMessages() async {
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

  static removeMessageByID(int msgID) async {
    final _db = await DBProvider.db.database;

    var result = await _db.delete(
      "Messages",
      where: "id = ?",
      whereArgs: [msgID]
    );

    return result;
  }

  static Future<NotificationMessage> getMessageByID(int msgID) async{
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

  static Future<NotificationMessage> getLastMessage() async {
	final Database _db = await DBProvider.db.database;

	var result = await _db.query(
		"Messages",
		limit: 1
	);

	return result.isNotEmpty
		? result.map(
			(item) => NotificationMessage.fromJson(item)
		).toList()[0]
		: null;
  }
}