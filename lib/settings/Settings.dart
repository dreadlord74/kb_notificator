import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kb_notificator/settings/SettingsForm.dart';

class Settings extends StatefulWidget{
  @override
  State<Settings> createState(){
    return _Settings();
  }
}

class _Settings extends State<Settings>{
  @override
  void initState() {
    super.initState();
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Настройки"),
      ),
      body: SettingsForm(),
    );
  }
}