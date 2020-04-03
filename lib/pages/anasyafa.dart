import 'package:flutter/material.dart';
import 'package:remember_words/helper/database_helper.dart';
import 'package:remember_words/models/kelimeler.dart';
import 'package:remember_words/pages/alistirma.dart';
import 'package:remember_words/pages/kelime_ekle.dart';
import 'package:remember_words/ui/appbar_content.dart';
import 'package:remember_words/ui/bottom_navigation_bar.dart';

class MyHomePage extends StatefulWidget {
  final AppBar myAppBar;
  final int gelenIndex;

  MyHomePage({this.myAppBar, this.gelenIndex});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper _databaseHelper;
  List<Kelimeler> tumKelimeler = List<Kelimeler>();
  int index;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    tumKelimeler = _kelimeListesiniGetir();

    if (widget.gelenIndex == null) {
      index = 0;
    } else {
      index = widget.gelenIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      bottomNavigationBar: MyBottomNavBar(
        gelenIndex: index,
      ),
      appBar: widget.myAppBar == null
          ? myApBar(baslik: "Ana Sayfa")
          : widget.myAppBar,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.cyan.shade200, Colors.white,Colors.cyan.shade200],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                //color: Colors.deepPurple.shade200,
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => KelimeEkle(
                            myAppBar: myApBar(baslik: "Kelime Ekle"),
                          )));
                },
                child: Text(
                  "Yeni Kelime Ekle",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                //color: Colors.deepPurple.shade200,
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => Alistirma()));
                },
                child: Text(
                  "Alıştırma Yap",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Kelimeler> _kelimeListesiniGetir() {
    // ignore: missing_return
    _databaseHelper.kelimeListesiniGetir().then((value) {
      if (value == null) {
        return "Sözlükte kelime bulunmamaktadır.";
      } else {
        setState(() {
          tumKelimeler = value;
        });
        return tumKelimeler;
      }
    });
  }
}
