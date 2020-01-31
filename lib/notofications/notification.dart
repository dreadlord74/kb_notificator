import 'package:flutter/material.dart';

class NotificationMessage {
  final int id;
  final String title;
  final String body;
  final DateTime sendTime;
  final DateTime receiveTime;
  String status = "waiting";

  NotificationMessage({
    this.id,
    @required this.title,
    @required this.body,
    @required this.sendTime,
    @required this.receiveTime,
    this.status
  });

  factory NotificationMessage.fromJson(Map<String, dynamic> json){
    return NotificationMessage(
      id: json["id"],
      title: json["title"], 
      body: json["body"],
      sendTime: json["sendTime"],
      receiveTime: json["receiveTime"],
      status: json["status"]
    );
  }

  String toJson() {
    return {
      "title": title, 
      "body": body,
      "sendTime": sendTime,
      "receiveTime": receiveTime,
      "status": status
    }.toString();
  }
}