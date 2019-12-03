import 'package:flutter/material.dart';

class Message {
  final String title;
  final String body;
  String status = "waiting";

  Message({
    @required this.title,
    @required this.body,
    this.status
  });

  factory Message.fromJson(Map<String, dynamic> json){
    return Message(
      title: json["title"], 
      body: json["body"],
      status: json["status"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "body": body,
      "status": status
    };
  }
}