import 'package:flutter/material.dart';

Widget myApBar({String baslik}) {
  return AppBar(
    backgroundColor: Colors.blue.shade200,
    title: Center(child: Text(baslik)),
  );
}