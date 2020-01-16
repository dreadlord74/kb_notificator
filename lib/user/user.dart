import 'package:flutter/material.dart';
import 'package:kb_notificator/database/database.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class User {
  final String phone;
  final String token;

  ProgressDialog loadingDialog = ProgressDialog(
    GlobalKey<ScaffoldState>().currentContext,
    type: ProgressDialogType.Normal,
    isDismissible: true,
    showLogs: true
  );

  User({
    @required this.phone,
    @required this.token
  }){
    loadingDialog.style(
      message: 'Подождите',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
  }

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      phone: json["phone"],
      token: json["token"]
    );
  }

  Map<String, dynamic> toMap(){
    return {
      "phone": phone,
      "token": token
    };
  }

  _updateRemoteData(User userData) async{
    var url = "http://gradus-nik.ru/api/?command=driversAppSetUser";

    loadingDialog.show();

    var result = await http.post(
      url,
      body: userData.toMap()
    );

    loadingDialog.hide();

    print(result);
  }

  updateToken(String newToken) async{
    final _db = await DBProvider.db.database;

    final User newUserData = User(
      phone: phone,
      token: newToken
    );

    await _updateRemoteData(newUserData);

    return await _db.update(
      "User",
      newUserData.toMap(),
      where: "phone = ?",
      whereArgs: [phone]
    );
  }

  updatePhone(String newPhone) async{
    final _db = await DBProvider.db.database;

    final User newUserData = User(
      phone: newPhone, 
      token: token
    );

    await _updateRemoteData(newUserData);

    return await _db.update(
      "User",
      User(
        phone: newPhone, 
        token: token
      ).toMap(),
      where: "token = ?",
      whereArgs: [token]
    );
  }




  static createUser(User newUser) async{
    final _db = await DBProvider.db.database;

    return await _db.rawInsert(
      "INSERT INTO User (phone, token)"
      " values ('${newUser.phone}', '${newUser.token}')"
    );
  }

  static Future<User> getUser() async{
    final _db = await DBProvider.db.database;

    var res = await _db.query(
      "User",
      limit: 1
    );

    return res.length > 0 ? User.fromJson(res[0]) : null;
  }
}