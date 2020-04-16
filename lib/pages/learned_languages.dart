import 'package:flutter/material.dart';
import 'package:remember_words/common_controls/common_controls.dart';
import 'package:remember_words/helper/database_helper.dart';
import 'package:remember_words/models/diller.dart';
import 'package:remember_words/models/diller_listesi.dart';
import 'package:remember_words/models/ogrendiklerim.dart';
import 'package:remember_words/pages/ogrenilenler.dart';
import 'package:remember_words/ui/appbar_content.dart';
import 'package:remember_words/ui/bottom_navigation_bar.dart';

class LearnedLanguages extends StatefulWidget {
  final AppBar myAppBar;
  final gelenIndex;

  LearnedLanguages({this.myAppBar, this.gelenIndex});

  @override
  _LearnedLanguagesState createState() => _LearnedLanguagesState();
}

class _LearnedLanguagesState extends State<LearnedLanguages> {
  DatabaseHelper _databaseHelper;
  Controls controls;
  List<Diller> diller;
  List<Ogrendiklerim> ogrenilenKelimeler;
  List<Ogrendiklerim> currentList;
  DillerListesi dillerListesi;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    diller = List<Diller>();
    controls = Controls();
    ogrenilenKelimeler = List<Ogrendiklerim>();
    dillerListesi = DillerListesi();
    currentList = List<Ogrendiklerim>();
    _databaseHelper = DatabaseHelper();
    _databaseHelper.dillerinListesiniGetir().then((gelenListe) {
      setState(() {
        diller = gelenListe;
      });
    });
    _databaseHelper.ogrendikleriminListesiniGetir().then((kelimeListesi) {
      ogrenilenKelimeler = kelimeListesi;
      controls.ogrenilenleriDillereGoreEkle(ogrenilenKelimeler,dillerListesi);
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.myAppBar,
      bottomNavigationBar: MyBottomNavBar(
        gelenIndex: widget.gelenIndex,
      ),
      body: diller.length == 0
          ? Center(
        child: Text("Sözlükte kelime bulunmamaktadır."),
      )
          : ListView.builder(
        itemBuilder: (_,index) => dilListesiniOlustur(_, index),
        itemCount: diller.length,
      ),
    );
  }

  dilListesiniOlustur(BuildContext buildContext, int index) {

    return InkWell(
      onTap: () {
        currentList = controls.dilKontrol(context, index, dillerListesi, diller, false, ogrenilenKelimeler: ogrenilenKelimeler);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Ogrenilenler(myAppBar: myApBar(baslik: "Öğrenilenler"), gelenKelime: currentList)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20)],
              borderRadius: BorderRadius.circular(50)),
          width: MediaQuery.of(context).size.width,
          height: 150,
          child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset("${diller[index].languagesIMG}",height: 120,width: 120,),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Text(
                      diller[index].languagesName,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }

}
