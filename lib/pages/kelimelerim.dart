import 'package:flutter/material.dart';
import 'package:remember_words/helper/database_helper.dart';
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
      body: ListView.builder(
        itemCount: tumKelimeler.length,
        itemBuilder: (context, index) => kelimeListsiniOlustur(context, index),
      ),
    );
  }
  

  kelimeListsiniOlustur(BuildContext context, int index) {
    return Dismissible(

      child: ListTile(
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
              _databaseHelper.kelimeListesiniGetir().then((gelenListe){
                tumKelimeler = gelenListe;
              });
            });
          },
        ),
      ),
    );

    /*ExpansionTile(
              title: Text(tumKelimeler[index].kelimeENG),
              subtitle: Text(tumKelimeler[index].kelimeTR),
              leading: Icon(Icons.work),
            );*/
  }
}
