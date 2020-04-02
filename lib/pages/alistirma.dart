import 'dart:math';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remember_words/helper/database_helper.dart';
import 'package:remember_words/models/kelimeler.dart';
import 'package:remember_words/models/ogrendiklerim.dart';

class Alistirma extends StatefulWidget {

  @override
  _AlistirmaState createState() => _AlistirmaState();
}

class _AlistirmaState extends State<Alistirma> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  List<Kelimeler> kelimeler;
  int kelimeSayac = 0;
  DatabaseHelper databaseHelper;
  int sayi;
  Color renk;

  @override
  void initState() {
    super.initState();
    kelimeler = List<Kelimeler>();
    databaseHelper = DatabaseHelper();
    databaseHelper.kelimeListesiniGetir().then((gelenListe) {
      setState(() {
        kelimeler = gelenListe;
      });
    });
    sayi = _randomSayiUret();
    renk = _randomRenkUret();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alıştırma Yap"),
        backgroundColor: renk,
      ),
      body: kelimeler.length == 0
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
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 120,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Center(
                child: Text(kategoriBelirle(kelimeler[sayi].kategoriID, "eng"),
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              decoration: BoxDecoration(
                  color: renk, borderRadius: BorderRadius.circular(50)),
            ),
            SizedBox(
              height: 100,
            ),
            Center(
              child: Text(
                kelimeler[sayi].kelimeENG.toUpperCase(),
                style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold, color: renk),
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
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 120,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Center(
                    child: Text(
                        kategoriBelirle(kelimeler[sayi].kategoriID, "tr"),
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  decoration: BoxDecoration(
                      color: renk, borderRadius: BorderRadius.circular(50)),
                ),
                SizedBox(
                  height: 100,
                ),
                Center(
                  child: Text(
                    kelimeler[sayi].kelimeTR.toUpperCase(),
                    style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold, color: renk),
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
                renk = _randomRenkUret();
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
              print("${kelimeler[sayi].kelimeENG}: " + kelimeSayac.toString());
              databaseHelper.kelimeGuncelle(
                  Kelimeler.withID(kelimeID: kelimeler[sayi].kelimeID,
                      kategoriID: kelimeler[sayi].kategoriID,
                      kelimeTR: kelimeler[sayi].kelimeTR,
                      kelimeENG: kelimeler[sayi].kelimeENG,
                      kelimeSayac: kelimeSayac)).then((guncID) {
                databaseHelper.kelimeListesiniGetir().then((val) {
                  setState(() {
                    kelimeler = val;
                    cardKey.currentState.toggleCard();
                  });
                  sayi = _randomSayiUret();
                  renk = _randomRenkUret();
                });
              });

              if (kelimeSayac >= 3) {
                databaseHelper.kelimeSil(kelimeler[sayi].kelimeID).then((
                    value) {
                  if (value != 0) {
                    //Öğrenilen tabloya kelimeyi ekle
                    databaseHelper.ogrendiklerimEkle(
                        Ogrendiklerim(kategoriID: kelimeler[sayi].kategoriID,
                        kelimeENG: kelimeler[sayi].kelimeENG,
                        kelimeTR: kelimeler[sayi].kelimeTR));
                    databaseHelper.kelimeListesiniGetir().then((val) {
                      setState(() {
                        kelimeler = val;
                      });
                    });
                  }
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

  /*SimpleDialog buildSimpleDialog(BuildContext context, int index) {
    if (kelimeler[index].kelimeSayac == 3) {
      kelimeler.removeAt(index);
      return SimpleDialog(
        //title: Center(child: Text("Kelime Anlamı")),
        backgroundColor: Colors.orangeAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                kelimeler[index].kelimeENG.toUpperCase(),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                kelimeler[index].kelimeTR +
                    "  (${kategoriBelirle(kelimeler[index].kategoriID)})",
                style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
              ),
              ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Bilmiyorum"),
                    color: Colors.red,
                  ),
                  RaisedButton(
                    onPressed: () {
                      kelimeSayac++;
                      kelimeler[index].kelimeSayac = kelimeSayac;
                      if (kelimeler[index].kelimeSayac == 3) {
                        debugPrint(kelimeler[index].kelimeSayac.toString());
                        databaseHelper.kelimeGuncelle(
                          Kelimeler.withID(
                            kelimeID: kelimeler[index].kelimeID,
                            kategoriID: kelimeler[index].kategoriID,
                            kelimeENG: kelimeler[index].kelimeENG,
                            kelimeTR: kelimeler[index].kelimeTR,
                            kelimeSayac: kelimeler[index].kelimeSayac,
                          ),
                        );
                        kelimeler.removeAt(index);
                        databaseHelper.kelimeListesiniGetir().then((liste) {
                          setState(() {
                            kelimeler = liste;
                          });
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: Text("Biliyorum"),
                    color: Colors.green,
                  )
                ],
              )
            ],
          )
        ],
      );
    } else {
      return SimpleDialog(
        //title: Center(child: Text("Kelime Anlamı")),
        backgroundColor: Colors.orangeAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                kelimeler[index].kelimeENG.toUpperCase(),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                kelimeler[index].kelimeTR +
                    "  (${kategoriBelirle(kelimeler[index].kategoriID)})",
                style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
              ),
              ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Bilmiyorum"),
                    color: Colors.red,
                  ),
                  RaisedButton(
                    onPressed: () {
                      kelimeSayac++;
                      kelimeler[index].kelimeSayac = kelimeSayac;
                      if (kelimeler[index].kelimeSayac == 3) {
                        debugPrint(kelimeler[index].kelimeSayac.toString());
                        databaseHelper.kelimeGuncelle(
                          Kelimeler.withID(
                            kelimeID: kelimeler[index].kelimeID,
                            kategoriID: kelimeler[index].kategoriID,
                            kelimeENG: kelimeler[index].kelimeENG,
                            kelimeTR: kelimeler[index].kelimeTR,
                            kelimeSayac: kelimeler[index].kelimeSayac,
                          ),
                        );
                        kelimeler.removeAt(index);
                        databaseHelper.kelimeListesiniGetir().then((liste) {
                          setState(() {
                            kelimeler = liste;
                          });
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: Text("Biliyorum"),
                    color: Colors.green,
                  )
                ],
              )
            ],
          )
        ],
      );
    }
  }*/

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

  int _randomSayiUret() {
    var random = Random();
    var length;
    setState(() {
      length = kelimeler.length;
    });
    if (length == 0) {
      sayi = 0;
    } else {
      sayi = random.nextInt(length);
    }
    return sayi;
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

  int _sayacArttir(int oAnkiSayac) {
    oAnkiSayac++;
    return oAnkiSayac;
  }
}
