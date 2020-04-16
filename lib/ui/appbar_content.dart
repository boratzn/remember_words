import 'package:flutter/material.dart';

Widget myApBar({String baslik}) {
  return AppBar(
    backgroundColor: Colors.blue,
    title: Center(child: Text(baslik)),
  );
}