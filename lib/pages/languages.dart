import 'package:flutter/material.dart';
import 'package:remember_words/common_controls/common_controls.dart';
import 'package:remember_words/helper/database_helper.dart';
import 'package:remember_words/models/diller.dart';
import 'package:remember_words/models/diller_listesi.dart';
import 'package:remember_words/models/kelimeler.dart';
import 'package:remember_words/pages/alistirma.dart';
import 'package:remember_words/pages/kelimelerim.dart';
import 'package:remember_words/ui/appbar_content.dart';
import 'package:remember_words/ui/bottom_navigation_bar.dart';

class Languages extends StatefulWidget {
  final AppBar myAppBar;
  final gelenIndex;

  Languages({this.myAppBar, this.gelenIndex});

  @override
  _LanguagesState createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  DatabaseHelper _databaseHelper;
  Controls controls;
  DillerListesi dillerListesi;
  List<Diller> diller;
  List<Kelimeler> tumKelimeler;
  List<Kelimeler> currentList;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    diller = List<Diller>();
    dillerListesi = DillerListesi();
    tumKelimeler = List<Kelimeler>();
    currentList = List<Kelimeler>();
    controls = Controls();

    _databaseHelper = DatabaseHelper();
    _databaseHelper.dillerinListesiniGetir().then((gelenListe) {
      setState(() {
        diller = gelenListe;
      });
    });
    _databaseHelper.kelimeListesiniGetir().then((kelimeListesi) {
      tumKelimeler = kelimeListesi;
      controls.kelimeleriDillereGoreEkle(tumKelimeler, dillerListesi);
        setState(() {

        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.gelenIndex == 0 ? widget.myAppBar : widget.myAppBar,
      bottomNavigationBar: widget.gelenIndex == 0 ? null : MyBottomNavBar(
        gelenIndex: widget.gelenIndex,
      ),
      body: diller.length == 0
          ? Center(
              child: Text("Sözlükte kelime bulunmamaktadır."),
            )
          : ListView.builder(
        itemBuilder: (_,index) => widget.gelenIndex == 1 ? dilListesiniOlustur(_, index) : dilListesiniOlustur2(_, index),
        itemCount: diller.length,
      ),
    );
  }

  //KELİMELERİM SAYFASI İÇİN
  dilListesiniOlustur(BuildContext buildContext, int index) {

    return InkWell(
      onTap: () {
        currentList = controls.dilKontrol(context, index, dillerListesi, diller, true, tumKelimeler: tumKelimeler);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Kelimelerim(myAppBar: myApBar(baslik: "Kelimeler"), gelenKelime: currentList)));
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
  //ALIŞTIRMA SAYFASI İÇİN
  dilListesiniOlustur2(BuildContext buildContext, int index) {

    return InkWell(
      onTap: () {
        currentList = controls.dilKontrol(context, index, dillerListesi, diller, true, tumKelimeler: tumKelimeler);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Alistirma(gelenKelimeler: currentList,)));
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
