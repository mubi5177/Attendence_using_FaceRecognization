import 'package:flutter/material.dart';

class User {
  String user;
  String id;

  User({@required this.user, @required String id});

  static User fromDB(String dbuser) {
    return new User(user: dbuser.split(",")[0], id: dbuser.split(",")[1]);
  }
}
