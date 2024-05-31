import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'package:finishedpart/Login.dart';
import 'package:finishedpart/barpage.dart';
import 'package:finishedpart/checkinfo.dart';
import 'package:finishedpart/createuser.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,

    home: LoginPage()

  ));
}