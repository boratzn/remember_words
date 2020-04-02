import 'package:flutter/material.dart';
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
        backgroundColor: Colors.deepPurple.shade50,
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
                ListView.builder(
                    itemCount: tumOgrendiklerim.length,
                    itemBuilder: (context, index) =>
                        _ogrenilenListeyiGetir(context, index),
                  ),
                Positioned(
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.5),
                    child: Text(
                      tumOgrendiklerim.length.toString(),
                      style: TextStyle(fontSize: 18,color: Colors.red,fontWeight: FontWeight.bold),
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
                color: Colors.deepPurple.shade50,
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
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      tumOgrendiklerim[index].kelimeTR +
                          "(${kategoriBelirle(tumOgrendiklerim[index].kategoriID, "tr")})",
                      style: TextStyle(
                          fontSize: 22, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                IconButton(
                  iconSize: 35,
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
                ),
              ],
            ),
          ),
        ],
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

}
