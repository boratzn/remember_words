import 'package:flutter/material.dart';
import 'package:remember_words/pages/anasyafa.dart';
import 'package:remember_words/pages/kelimelerim.dart';
import 'package:remember_words/pages/ogrenilenler.dart';
import 'package:remember_words/ui/appbar_content.dart';

class MyBottomNavBar extends StatefulWidget {
  final gelenIndex;

  MyBottomNavBar({this.gelenIndex});

  @override
  _MyBottomNavBarState createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    int index = widget.gelenIndex;

    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("Ana Sayfa"),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.book), title: Text("Kelimelerim")),
        BottomNavigationBarItem(
            icon: Icon(Icons.done), title: Text("Öğrendiklerim"))
      ],
      selectedItemColor: Colors.black,
      onTap: (secilenIndex) {
        setState(() {
          //index = secilenIndex;
          _goToPage(secilenIndex);
        });
      },
      currentIndex: index,
    );
  }

  void _goToPage(int secilenIndex) {
    switch (secilenIndex) {
      case 0:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => MyHomePage(
                  myAppBar: myApBar(baslik: "Ana Sayfa"),
                  gelenIndex: secilenIndex,
                )));
        break;
      case 1:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => Kelimelerim(
                  myAppBar: myApBar(baslik: "Kelimelerim"),
                  gelenIndex: secilenIndex,
                )));
        break;
      case 2:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => Ogrenilenler(
                  myAppBar: myApBar(baslik: "Öğrendiklerim"),
                  gelenIndex: secilenIndex,
                )));
        break;
    }
  }
}
