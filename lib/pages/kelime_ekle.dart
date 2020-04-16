import 'package:flutter/material.dart';
import 'package:remember_words/helper/database_helper.dart';
import 'package:remember_words/models/diller.dart';
import 'package:remember_words/models/kategori.dart';
import 'package:remember_words/models/kelimeler.dart';

class KelimeEkle extends StatefulWidget {
  final AppBar myAppBar;

  KelimeEkle({this.myAppBar});

  @override
  _KelimeEkleState createState() => _KelimeEkleState();
}

class _KelimeEkleState extends State<KelimeEkle> {
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _controller1;
  TextEditingController _controller2;
  DatabaseHelper _databaseHelper;
  String girilenKelime;
  String aciklama;
  List<Kategori> tumKategoriler;
  List<Kelimeler> tumKelimeler;
  List<Diller> tumDiller;
  int kategoriID = 1;
  int languagesID = 1;
  int kelimeSayac = 0;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    tumKategoriler = List<Kategori>();
    tumDiller = List<Diller>();
    _databaseHelper.dillerinListesiniGetir().then((gelenDilListesi) {
      setState(() {
        tumDiller = gelenDilListesi;
        print(tumDiller[0].languagesName);
      });
    });

    _databaseHelper.kategorileriGetir().then((kategoriMapListesi) {
      for (Map okunanMap in kategoriMapListesi) {
        tumKategoriler.add(Kategori.fromMap(okunanMap));

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Kelime ekle"),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20)],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLength: 20,
                        autofocus: false,
                        controller: _controller1,
                        decoration: InputDecoration(
                            hintText: "Kelimeyi Yazınız",
                            labelText: "Yabancı Kelime",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        // ignore: missing_return
                        validator: (value) {
                          if (value.length == 0) {
                            return "Lütfen Boş Bırakmayınız!!";
                          }
                        },
                        onSaved: (value) {
                          girilenKelime = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: false,
                        controller: _controller2,
                        maxLines: 3,
                        decoration: InputDecoration(
                            hintText: "Anlamını Yazınız",
                            labelText: "Türkçesi",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        // ignore: missing_return
                        validator: (value) {
                          if (value.length == 0) {
                            return "Lütfen Boş Bırakmayınız!!";
                          }
                        },
                        onSaved: (value) {
                          aciklama = value;
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Kategori: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              items: kategoriItemleriOlustur(),
                              value: kategoriID,
                              onChanged: (secilenID) {
                                setState(() {
                                  kategoriID = secilenID;
                                });
                              },
                            ),
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 24),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Diller: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              items: dillerItemleriOlustur(),
                              value: languagesID,
                              onChanged: (secilenID) {
                                setState(() {
                                  languagesID = secilenID;
                                });
                              },
                            ),
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 24),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ButtonBar(
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.red,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Vazgeç",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            RaisedButton(
                              color: Colors.green,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  _databaseHelper
                                      .kelimeEkle(Kelimeler(
                                          kategoriID: kategoriID,
                                          kelimeENG: girilenKelime,
                                          kelimeTR: aciklama,
                                          kelimeSayac: kelimeSayac,
                                          languagesID: languagesID))
                                      .then((value) {
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                          content: Text("Kelime eklendi."),
                                          duration: Duration(seconds: 3),
                                    ));
                                    _controller1.text = "";
                                    _controller2.text = "";
                                    kategoriID = 1;
                                    languagesID = 1;
                                    setState(() {});
                                  });
                                }
                              },
                              child: Text(
                                "Kaydet",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  kategoriItemleriOlustur() {
    return tumKategoriler
        .map(
          (kategori) => DropdownMenuItem<int>(
            value: kategori.kategoriID,
            child: Text(kategori.kategoriBaslik),
          ),
        )
        .toList();
  }

  dillerItemleriOlustur() {
    return tumDiller
        .map(
          (diller) => DropdownMenuItem<int>(
            value: diller.languagesID,
            child: Text(diller.languagesName),
          ),
        )
        .toList();
  }
}
