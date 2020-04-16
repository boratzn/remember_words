import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:remember_words/common_controls/common_controls.dart';
import 'package:remember_words/helper/database_helper.dart';
import 'package:remember_words/models/ogrendiklerim.dart';
import 'package:remember_words/ui/bottom_navigation_bar.dart';

class Ogrenilenler extends StatefulWidget {
  final AppBar myAppBar;
  final List<Ogrendiklerim> gelenKelime;
  //final gelenIndex;

  Ogrenilenler({this.myAppBar, this.gelenKelime});

  @override
  _OgrenilenlerState createState() => _OgrenilenlerState();
}

class _OgrenilenlerState extends State<Ogrenilenler> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  Controls _controls;
  List<Ogrendiklerim> tumOgrendiklerim;
  List<Ogrendiklerim> gelenKelimeler;
  DatabaseHelper databaseHelper;
  Color currentRenk = Colors.blue, lastRenk = Colors.blue;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    gelenKelimeler = List<Ogrendiklerim>();
    _controls = Controls(currentRenk: currentRenk, lastRenk: lastRenk);
    tumOgrendiklerim = List<Ogrendiklerim>();
    databaseHelper.ogrendikleriminListesiniGetir().then((gelenListe) {
      setState(() {
        tumOgrendiklerim = gelenListe;
        gelenKelimeler = widget.gelenKelime;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: widget.myAppBar,
        body: gelenKelimeler.length == 0
            ? Center(
                child: Text("Öğrenilen kelime bulunmamaktadır."),
              )
            : Stack(
                children: <Widget>[
                  PageView.builder(
                    itemCount: gelenKelimeler.length,
                    itemBuilder: (context, index) =>
                        _ogrenilenListeyiGetir2(context, index),
                    scrollDirection: Axis.horizontal,
                  ),
                  Positioned(
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Text(
                        gelenKelimeler.length.toString(),
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

  _ogrenilenListeyiGetir2(BuildContext context, int index) {

    currentRenk = _controls.renkKontrol();

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
                  color: currentRenk,
                  borderRadius: BorderRadius.circular(50)
                ),
              ),
              Text(
                gelenKelimeler[index].kelimeENG.toUpperCase(),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
              ),
              Text(
                gelenKelimeler[index].kelimeTR +
                    "(${_controls.kategoriBelirle(tumOgrendiklerim[index].kategoriID, "tr")})",
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
                      color: currentRenk,
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        databaseHelper
                            .ogrendiklerimSil(
                                tumOgrendiklerim[index].ogrenilenID)
                            .then((silinenID) {
                          if (silinenID != null) {
                            setState(() {
                              gelenKelimeler.removeAt(index);
                            });
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Kelime silme işlemi başarılı."),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
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

}
