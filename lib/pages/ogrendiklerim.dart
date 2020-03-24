import 'package:flutter/material.dart';
import 'package:remember_words/ui/bottom_navigation_bar.dart';

class Ogrendiklerim extends StatefulWidget {
  final AppBar myAppBar;
  final gelenIndex;

  Ogrendiklerim({this.myAppBar, this.gelenIndex});

  @override
  _OgrendiklerimState createState() => _OgrendiklerimState();
}

class _OgrendiklerimState extends State<Ogrendiklerim> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      bottomNavigationBar: MyBottomNavBar(
        gelenIndex: widget.gelenIndex,
      ),
      appBar: widget.myAppBar,
      body: Center(
        child: Text("Öğrendiklerim"),
      ),
    );
  }
}
