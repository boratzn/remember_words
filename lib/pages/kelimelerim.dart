import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remember_words/helper/database_helper.dart';
import 'package:remember_words/models/kategori.dart';
import 'package:remember_words/models/kelimeler.dart';
import 'package:remember_words/ui/bottom_navigation_bar.dart';

class Kelimelerim extends StatefulWidget {
  final AppBar myAppBar;
  final gelenIndex;

  Kelimelerim({this.myAppBar, this.gelenIndex});

  @override
  _KelimelerimState createState() => _KelimelerimState();
}

class _KelimelerimState extends State<Kelimelerim> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Kelimeler> tumKelimeler;
  List<Kategori> tumKategoriler;
  DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    tumKelimeler = List<Kelimeler>();
    databaseHelper.kelimeListesiniGetir().then((gelenListe) {
      setState(() {
        tumKelimeler = gelenListe;
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
      body: tumKelimeler.length == 0
          ? Center(
              child: Text("Sözlükte kelime bulunmamaktadır."),
            )
          : ListView.builder(
              itemCount: tumKelimeler.length,
              itemBuilder: (context, index) =>
                  kelimeListsiniOlustur(context, index),
            ),
    );
  }

  kelimeListsiniOlustur(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
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
                tumKelimeler[index].kelimeENG.substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.black),
              ),
              radius: 35,
              backgroundColor: Colors.grey,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  tumKelimeler[index].kelimeENG.toUpperCase(),
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  tumKelimeler[index].kelimeTR +
                      "(${kategoriBelirle(tumKelimeler[index].kategoriID, "tr")})",
                  style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            IconButton(
              iconSize: 35,
              icon: Icon(Icons.delete),
              onPressed: () {
                databaseHelper
                    .kelimeSil(tumKelimeler[index].kelimeID)
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
                    .kelimeListesiniGetir()
                    .then((gelenListe) {
                  setState(() {
                    tumKelimeler = gelenListe;
                  });
                });
              },
            ),
          ],
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

}
