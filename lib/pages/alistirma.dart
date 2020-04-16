import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remember_words/common_controls/common_controls.dart';
import 'package:remember_words/helper/database_helper.dart';
import 'package:remember_words/models/diller.dart';
import 'package:remember_words/models/diller_listesi.dart';
import 'package:remember_words/models/kelimeler.dart';
import 'package:remember_words/models/ogrendiklerim.dart';

class Alistirma extends StatefulWidget {
  final List<Kelimeler> gelenKelimeler;

  Alistirma({this.gelenKelimeler});

  @override
  _AlistirmaState createState() => _AlistirmaState();
}

class _AlistirmaState extends State<Alistirma> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  DillerListesi dillerListesi;
  List<Diller> diller;
  Controls _controls;
  List<Kelimeler> kelimeler;
  List<Kelimeler> gelenKelimeler;
  DatabaseHelper databaseHelper;
  Color currentRenk = Colors.blue, lastRenk = Colors.blue;
  int kelimeSayac = 0;
  int sayi;


  @override
  void initState() {
    super.initState();
    kelimeler = List<Kelimeler>();
    diller = List<Diller>();
    dillerListesi = DillerListesi();
    _controls = Controls(currentRenk: currentRenk, lastRenk: lastRenk);
    databaseHelper = DatabaseHelper();
    gelenKelimeler = widget.gelenKelimeler;
    databaseHelper.kelimeListesiniGetir().then((gelenListe) {
      setState(() {
        kelimeler = gelenListe;
      });
    });
    sayi = _randomSayiUret();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Alıştırma Yap"),
        backgroundColor: currentRenk,
      ),
      body: gelenKelimeler.length == 0
          ? Center(child: Text("Sözlükte kelime bulunmamaktadır!!"))
          : FlipCard(
              key: cardKey,
              front: _onGorunum(context),
              back: _arkaGorunum(context),
              direction: FlipDirection.HORIZONTAL,
            ),
    );
  }

  //İNGİLİZCE KART GÖRÜNÜMÜ
  Padding _onGorunum(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20)],
            borderRadius: BorderRadius.circular(50)),
        height: 400,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                    _controls.kategoriBelirle(
                        gelenKelimeler[sayi].kategoriID, "eng"),
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              decoration: BoxDecoration(
                  color: currentRenk, borderRadius: BorderRadius.circular(50)),
            ),
            SizedBox(
              height: 100,
            ),
            Center(
              child: Text(
                gelenKelimeler[sayi].kelimeENG.toUpperCase(),
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: currentRenk),
              ),
            )
          ],
        ),
      ),
    );
  }

  //TÜRKÇE KART GÖRÜNÜMÜ
  Padding _arkaGorunum(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20)],
                borderRadius: BorderRadius.circular(50)),
            height: 400,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                        _controls.kategoriBelirle(
                            gelenKelimeler[sayi].kategoriID, "tr"),
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  decoration: BoxDecoration(
                      color: currentRenk,
                      borderRadius: BorderRadius.circular(50)),
                ),
                SizedBox(
                  height: 100,
                ),
                Center(
                  child: Text(
                    gelenKelimeler[sayi].kelimeTR.toUpperCase(),
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: currentRenk),
                  ),
                ),
              ],
            ),
          ),
          //*********************************BUTONLAR****************************************
          _butonlariGetir(),
        ],
      ),
    );
  }

  //BUTONLARIN OLUŞTURULMASI
  Padding _butonlariGetir() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          //*************************BİLMİYORUM BUTONU**********************************
          RawMaterialButton(
            onPressed: () {
              setState(() {
                sayi = _randomSayiUret();
                currentRenk = _controls.renkKontrol();
                cardKey.currentState.toggleCard();
              });
            },
            child: Icon(
              CupertinoIcons.clear,
              color: Colors.white,
              size: 50,
            ),
            elevation: 2,
            shape: CircleBorder(),
            fillColor: Colors.red,
            padding: EdgeInsets.all(5),
          ),
          //****************************BİLİYORUM BUTONU**********************************
          RawMaterialButton(
            onPressed: () {
              kelimeSayac = _sayacArttir(kelimeler[sayi].kelimeSayac);
              print("${gelenKelimeler[sayi].kelimeENG}: " + kelimeSayac.toString());
              databaseHelper
                  .kelimeGuncelle(Kelimeler.withID(
                      kelimeID: kelimeler[sayi].kelimeID,
                      kategoriID: kelimeler[sayi].kategoriID,
                      kelimeTR: kelimeler[sayi].kelimeTR,
                      kelimeENG: kelimeler[sayi].kelimeENG,
                      kelimeSayac: kelimeSayac,
                      languagesID: kelimeler[sayi].languagesID))
                  .then((guncID) {
                databaseHelper.kelimeListesiniGetir().then((val) {
                  setState(() {
                    kelimeler = val;
                    if(kelimeler.length != 0){
                      cardKey.currentState.toggleCard();
                    }
                  });
                  sayi = _randomSayiUret();
                  currentRenk = _controls.renkKontrol();
                });
              });

              if (kelimeSayac >= 10) {
                //Öğrenilen tabloya kelimeyi ekle
                databaseHelper.ogrendiklerimEkle(Ogrendiklerim(
                    kategoriID: kelimeler[sayi].kategoriID,
                    kelimeENG: kelimeler[sayi].kelimeENG,
                    kelimeTR: kelimeler[sayi].kelimeTR,
                    languagesID: kelimeler[sayi].languagesID)).then((value) {
                });
                //Kelimeyi Kelimeler tablosundan sil
                databaseHelper
                    .kelimeSil(kelimeler[sayi].kelimeID)
                    .then((value) {
                  setState(() {
                    gelenKelimeler.removeAt(sayi);
                  });
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(
                        "${kelimeler[sayi].kelimeENG} kelimesi Öğrenilenler listesine eklendi."),
                    duration: Duration(seconds: 3),
                  ));

                });
              }
            },
            child: Icon(
              CupertinoIcons.check_mark,
              color: Colors.white,
              size: 50,
            ),
            elevation: 2,
            shape: CircleBorder(),
            fillColor: Colors.green,
            padding: EdgeInsets.all(5),
          )
        ],
      ),
    );
  }

  int _randomSayiUret() {
    var random = Random();
    var length;
    int currentSayi, lastSayi;
    setState(() {
      length = kelimeler.length;
    });
    if (length == 0 || length == null) {
      sayi = 0;
    } else {
      currentSayi = random.nextInt(length);
      print(currentSayi);
      if (currentSayi == lastSayi) {
        for (int i = 0; currentSayi == lastSayi; i++) {
          lastSayi = currentSayi;
          currentSayi = random.nextInt(length);
        }
        sayi = currentSayi;
        print(sayi);
        return sayi;
      } else {
        lastSayi = currentSayi;
        sayi = currentSayi;
        return sayi;
      }
    }
    return sayi;
  }

  int _sayacArttir(int oAnkiSayac) {
    oAnkiSayac++;
    return oAnkiSayac;
  }
}
