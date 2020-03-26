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
  DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    tumKelimeler = List<Kelimeler>();
    _databaseHelper.kelimeListesiniGetir().then((gelenListe) {
      setState(() {
        tumKelimeler = gelenListe;
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
    /*return ListTile(
      title: Text(tumKelimeler[index].kelimeENG),
      subtitle: Text(tumKelimeler[index].kelimeTR),
      leading: Icon(Icons.work),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          _databaseHelper
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
          setState(() {
            _databaseHelper.kelimeListesiniGetir().then((gelenListe) {
              tumKelimeler = gelenListe;
            });
          });
        },
      ),
    );*/
    return Dismissible(
      background: slideLeftBackground(),
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      // ignore: missing_return
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final bool res = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(
                      "${tumKelimeler[index].kelimeENG} kelimesini silmek istediğinizden emin misiniz?"),
                  actions: <Widget>[
                    FlatButton(
                      color: Colors.red,
                      child: Text("Vazgeç"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    FlatButton(
                      color: Colors.green,
                      child: Text("Sil"),
                      onPressed: () {
                        _databaseHelper
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
                        setState(() {
                          _databaseHelper
                              .kelimeListesiniGetir()
                              .then((gelenListe) {
                            tumKelimeler = gelenListe;
                          });
                        });
                      },
                    )
                  ],
                );
              });
          return res;
        }
      },
      /*child: Padding(
        padding: const EdgeInsets.all(15),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.book),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      tumKelimeler[index].kelimeENG,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.brown),
                    ),
                    Text(
                      tumKelimeler[index].kelimeTR,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                      fontStyle: FontStyle.italic),
                    ),
                  ],
                ),

                /*Text(
                  tumKategoriler[tumKelimeler[index].kategoriID].kategoriBaslik,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                )*/
              ],
            ),
          ),
        ),
      ),*/

      child: ListTile(
        title: Text(tumKelimeler[index].kelimeENG),
        subtitle: Text(tumKelimeler[index].kelimeTR),
        leading: Icon(Icons.work),
      ),
    );

  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
