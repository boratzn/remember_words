import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue
            ),
            child: Center(child: Text("Drawer Menü",style: TextStyle(fontSize: 24),))),

          InkWell(
              child: ListTile(
              title: Text("Ana Sayfa"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){},
            ),
          ),
          InkWell(
              child: ListTile(
              title: Text("Kategoriler"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){},
            ),
          ),
          InkWell(
              child: ListTile(
              title: Text("Öğrendiklerim"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){},
            ),
          )
        ],
      ),
    );
  }
}