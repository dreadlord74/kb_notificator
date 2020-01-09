import 'package:flutter/material.dart';
import 'package:kb_notificator/database/database.dart';
import 'package:http/http.dart' as http;

class User {
  final String phone;
  final String token;

  User({
    @required this.phone,
    @required this.token
  });

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

  _updateRemoteDate(User userData) async{
    var url = "http://gradus-nik.ru/api/?command=driversAppSetUser";

    var result = await http.post(
      url,
      body: userData.toMap()
    );

    print(result);
  }

  updateToken(String newToken) async{
    final _db = await DBProvider.db.database;

    final User newUserData = User(
      phone: phone,
      token: newToken
    );

    await _updateRemoteDate(newUserData);

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

    await _updateRemoteDate(newUserData);

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
}