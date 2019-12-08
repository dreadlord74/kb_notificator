import 'package:flutter/material.dart';

class Message {
  final String title;
  final String body;
  final int messageID;
  final DateTime sendTime;
  final DateTime receiveTime;
  String status = "waiting";

  Message({
    @required this.title,
    @required this.body,
    @required this.messageID,
    @required this.sendTime,
    @required this.receiveTime,
    this.status
  });

  factory Message.fromJson(Map<String, dynamic> json){
    return Message(
      title: json["title"], 
      body: json["body"],
      messageID: json["messageID"],
      sendTime: json["sendTime"],
      receiveTime: json["receiveTime"],
      status: json["status"]
    );
  }

  String toJson() {
    return {
      "title": title, 
      "body": body,
      "messageID": messageID,
      "sendTime": sendTime,
      "receiveTime": receiveTime,
      "status": status
    }.toString();
  }
}