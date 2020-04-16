import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:remember_words/common_controls/common_controls.dart';
import 'package:remember_words/helper/database_helper.dart';
import 'package:remember_words/models/kelimeler.dart';

class Kelimelerim extends StatefulWidget {
  final AppBar myAppBar;
  final List<Kelimeler> gelenKelime;
  //final gelenIndex;

  Kelimelerim({this.myAppBar, this.gelenKelime});

  @override
  _KelimelerimState createState() => _KelimelerimState();
}

class _KelimelerimState extends State<Kelimelerim> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Controls _controls;
  List<Kelimeler> tumKelimeler;
  List<Kelimeler> gelenKelimeler;
  DatabaseHelper databaseHelper;
  Color currentRenk = Colors.blue, lastRenk = Colors.blue;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    gelenKelimeler = List<Kelimeler>();
    gelenKelimeler = widget.gelenKelime;
    tumKelimeler = List<Kelimeler>();
    _controls = Controls(currentRenk: currentRenk, lastRenk: lastRenk);
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
      /*bottomNavigationBar: MyBottomNavBar(
        gelenIndex: widget.gelenIndex,
      ),*/
      appBar: widget.myAppBar,
      body: gelenKelimeler.length == 0 || gelenKelimeler.length == null
          ? Center(
              child: Text("Sözlükte kelime bulunmamaktadır."),
            )
          : Stack(
              children: <Widget>[
                PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: gelenKelimeler.length,
                  itemBuilder: (context, index) =>
                      kelimeListsiniOlustur(context, index),
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
            ),
    );
  }

  kelimeListsiniOlustur(BuildContext context, int index) {

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
                gelenKelimeler[index].kelimeENG,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  gelenKelimeler[index].kelimeTR +
                      "(${_controls.kategoriBelirle(gelenKelimeler[index].kategoriID, "tr")})",
                  style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic,),
                ),
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
                            .kelimeSil(
                            gelenKelimeler[index].kelimeID)
                            .then((silinenID) {
                          if (silinenID != null) {
                            setState(() {
                              gelenKelimeler.removeAt(index);
                            });
                            _scaffoldKey.currentState.showSnackBar(
                              //kelime listesini güncellemek için metot çağır....
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
