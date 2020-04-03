import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:remember_words/helper/database_helper.dart';
import 'package:remember_words/models/ogrendiklerim.dart';
import 'package:remember_words/ui/bottom_navigation_bar.dart';

class Ogrenilenler extends StatefulWidget {
  final AppBar myAppBar;
  final gelenIndex;

  Ogrenilenler({this.myAppBar, this.gelenIndex});

  @override
  _OgrenilenlerState createState() => _OgrenilenlerState();
}

class _OgrenilenlerState extends State<Ogrenilenler> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Ogrendiklerim> tumOgrendiklerim;
  DatabaseHelper databaseHelper;
  int sayi;
  Color renk;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    tumOgrendiklerim = List<Ogrendiklerim>();
    databaseHelper.ogrendikleriminListesiniGetir().then((gelenListe) {
      setState(() {
        tumOgrendiklerim = gelenListe;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        bottomNavigationBar: MyBottomNavBar(
          gelenIndex: widget.gelenIndex,
        ),
        appBar: widget.myAppBar,
        body: tumOgrendiklerim.length == 0
            ? Center(
                child: Text("Öğrenilen kelime bulunmamaktadır."),
              )
            : Stack(
                children: <Widget>[
                  /*ListView.builder(
                    itemCount: tumOgrendiklerim.length,
                    itemBuilder: (context, index) =>
                        _ogrenilenListeyiGetir(context, index),
                  ),*/
                  PageView.builder(
                    itemCount: tumOgrendiklerim.length,
                    itemBuilder: (context, index) =>
                        _ogrenilenListeyiGetir2(context, index),
                    scrollDirection: Axis.horizontal,
                  ),
                  Positioned(
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Text(
                        tumOgrendiklerim.length.toString(),
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    bottom: 5,
                    left: 5,
                  ),
                ],
              ));
  }

  _ogrenilenListeyiGetir(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20)],
                borderRadius: BorderRadius.circular(50)),
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CircleAvatar(
                  child: Text(
                    tumOgrendiklerim[index]
                        .kelimeENG
                        .substring(0, 1)
                        .toUpperCase(),
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  radius: 35,
                  backgroundColor: Colors.grey,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      tumOgrendiklerim[index].kelimeENG.toUpperCase(),
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      tumOgrendiklerim[index].kelimeTR +
                          "(${kategoriBelirle(tumOgrendiklerim[index].kategoriID, "tr")})",
                      style:
                          TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                IconButton(
                  iconSize: 35,
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    databaseHelper
                        .ogrendiklerimSil(tumOgrendiklerim[index].ogrenilenID)
                        .then((silinenID) {
                      if (silinenID != null) {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text("Kelime silme işlemi başarılı."),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    });
                    databaseHelper
                        .ogrendikleriminListesiniGetir()
                        .then((gelenListe) {
                      setState(() {
                        tumOgrendiklerim = gelenListe;
                      });
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _ogrenilenListeyiGetir2(BuildContext context, int index) {
    renk = _randomRenkUret();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20)],
              borderRadius: BorderRadius.circular(50)),
          height: 350,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: renk,
                  borderRadius: BorderRadius.circular(50)
                ),
              ),
              Text(
                tumOgrendiklerim[index].kelimeENG.toUpperCase(),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
              ),
              Text(
                tumOgrendiklerim[index].kelimeTR +
                    "(${kategoriBelirle(tumOgrendiklerim[index].kategoriID, "tr")})",
                style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic,),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Kelimeyi Sil => ",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold,)),
                    IconButton(
                      iconSize: 35,
                      color: renk,
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        databaseHelper
                            .ogrendiklerimSil(
                                tumOgrendiklerim[index].ogrenilenID)
                            .then((silinenID) {
                          if (silinenID != null) {
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Kelime silme işlemi başarılı."),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        });
                        databaseHelper
                            .ogrendikleriminListesiniGetir()
                            .then((gelenListe) {
                          setState(() {
                            tumOgrendiklerim = gelenListe;
                          });
                        });
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  kategoriBelirle(int kategoriID, String language) {
    if (language == "eng") {
      switch (kategoriID) {
        case 1:
          return "Noun";
          break;
        case 2:
          return "Verb";
          break;
        case 3:
          return "Adjective";
          break;
      }
    }

    if (language == "tr") {
      switch (kategoriID) {
        case 1:
          return "İsim";
          break;
        case 2:
          return "Fiil";
          break;
        case 3:
          return "Sıfat";
          break;
      }
    }
  }

  Color _randomRenkUret() {
    Color color;
    var random = Random();
    int sayi = random.nextInt(10);
    switch (sayi) {
      case 0:
        color = Colors.orange;
        return color;
        break;
      case 1:
        color = Colors.blue;
        return color;
        break;
      case 2:
        color = Colors.cyan;
        return color;
        break;
      case 3:
        color = Colors.amber;
        return color;
        break;
      case 4:
        color = Colors.red;
        return color;
        break;
      case 5:
        color = Colors.brown;
        return color;
        break;
      case 6:
        color = Colors.deepPurple;
        return color;
        break;
      case 7:
        color = Colors.green;
        return color;
        break;
      case 8:
        color = Colors.indigoAccent;
        return color;
        break;
      case 9:
        color = Colors.lightGreen;
        return color;
        break;
      case 10:
        color = Colors.deepOrangeAccent;
        return color;
        break;
    }
    //return color;
  }
}
