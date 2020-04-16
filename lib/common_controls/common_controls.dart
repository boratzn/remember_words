import 'dart:math';

import 'package:flutter/material.dart';
import 'package:remember_words/helper/database_helper.dart';
import 'package:remember_words/models/diller.dart';
import 'package:remember_words/models/diller_listesi.dart';
import 'package:remember_words/models/kelimeler.dart';
import 'package:remember_words/models/ogrendiklerim.dart';

class Controls {
  Color currentRenk;
  Color lastRenk;
  DatabaseHelper databaseHelper;
  List<Kelimeler> currLang;
  List<Ogrendiklerim> currLearnedLang;

  Controls({this.currentRenk, this.lastRenk}) {
    databaseHelper = DatabaseHelper();
  }

  dilKontrol(
      BuildContext context,
      int oAnkiIndex,
      DillerListesi dillerListesi,
      List<Diller> diller,
      bool control,
      {List<Kelimeler> tumKelimeler,
      List<Ogrendiklerim> ogrenilenKelimeler}) {
    if (control == true) {
      if (tumKelimeler.length != 0) {
        for (int i = 0; i < tumKelimeler.length; i++) {
          if (diller[oAnkiIndex].languagesID == 1) {
            return dillerListesi.langENG;
          }
          if (diller[oAnkiIndex].languagesID == 2) {
            return dillerListesi.langFR;
          }
          if (diller[oAnkiIndex].languagesID == 3) {
            return dillerListesi.langSP;
          }
          if (diller[oAnkiIndex].languagesID == 4) {
            return dillerListesi.langDE;
          }
          if (diller[oAnkiIndex].languagesID == 5) {
            return dillerListesi.langITA;
          }
          if (diller[oAnkiIndex].languagesID == 6) {
            return dillerListesi.langRUS;
          }
        }
      } else {
        return tumKelimeler;
      }
    } else {
      //Ogrenilen kelimelerin dillere ayrılması
      if (ogrenilenKelimeler.length != 0) {
        for (int i = 0; i < ogrenilenKelimeler.length; i++) {
          if (diller[oAnkiIndex].languagesID == 1) {
            return dillerListesi.learnedLangENG;
          }
          if (diller[oAnkiIndex].languagesID == 2) {
            return dillerListesi.learnedLangFR;
          }
          if (diller[oAnkiIndex].languagesID == 3) {
            return dillerListesi.learnedLangSP;
          }
          if (diller[oAnkiIndex].languagesID == 4) {
            return dillerListesi.learnedLangDE;
          }
          if (diller[oAnkiIndex].languagesID == 5) {
            return dillerListesi.learnedLangITA;
          }
          if (diller[oAnkiIndex].languagesID == 6) {
            return dillerListesi.learnedLangRUS;
          }
        }
      } else {
        return ogrenilenKelimeler;
      }
    }
  }

  kelimeleriDillereGoreEkle(
      List<Kelimeler> tumKelimeler, DillerListesi dillerListesi) {
    if (tumKelimeler.length != 0) {
      for (int i = 0; i < tumKelimeler.length; i++) {
        if (tumKelimeler[i].languagesID == 1) {
          dillerListesi.langENG.add(tumKelimeler[i]);
        }
        if (tumKelimeler[i].languagesID == 2) {
          dillerListesi.langFR.add(tumKelimeler[i]);
        }
        if (tumKelimeler[i].languagesID == 3) {
          dillerListesi.langSP.add(tumKelimeler[i]);
        }
        if (tumKelimeler[i].languagesID == 4) {
          dillerListesi.langDE.add(tumKelimeler[i]);
        }
        if (tumKelimeler[i].languagesID == 5) {
          dillerListesi.langITA.add(tumKelimeler[i]);
        }
        if (tumKelimeler[i].languagesID == 6) {
          dillerListesi.langRUS.add(tumKelimeler[i]);
        }
      }
    }
    else{
      return tumKelimeler;
    }
  }

  ogrenilenleriDillereGoreEkle(
    List<Ogrendiklerim> ogrenilenKelimeler,
    DillerListesi dillerListesi,
  ) {
    if (ogrenilenKelimeler.length != 0) {
      for (int i = 0; i < ogrenilenKelimeler.length; i++) {
        if (ogrenilenKelimeler[i].languagesID == 1) {
          dillerListesi.learnedLangENG.add(ogrenilenKelimeler[i]);
        }
        if (ogrenilenKelimeler[i].languagesID == 2) {
          dillerListesi.learnedLangFR.add(ogrenilenKelimeler[i]);
        }
        if (ogrenilenKelimeler[i].languagesID == 3) {
          dillerListesi.learnedLangSP.add(ogrenilenKelimeler[i]);
        }
        if (ogrenilenKelimeler[i].languagesID == 4) {
          dillerListesi.learnedLangDE.add(ogrenilenKelimeler[i]);
        }
        if (ogrenilenKelimeler[i].languagesID == 5) {
          dillerListesi.learnedLangITA.add(ogrenilenKelimeler[i]);
        }
        if (ogrenilenKelimeler[i].languagesID == 6) {
          dillerListesi.learnedLangRUS.add(ogrenilenKelimeler[i]);
        }
      }
    }
  }

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

  Color randomRenkUret() {
    Color color;
    var random = Random();
    int sayi = random.nextInt(8);
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
        color = Colors.deepOrangeAccent;
        return color;
        break;
    }
    //return color;
  }

  Color renkKontrol() {
    currentRenk = randomRenkUret();

    if (currentRenk == lastRenk) {
      for (int i = 0; currentRenk == lastRenk; i++) {
        lastRenk = currentRenk;
        currentRenk = randomRenkUret();
      }
      return currentRenk;
    } else {
      lastRenk = currentRenk;
      return currentRenk;
    }
  }

  kelimeListesiniYenile(
      BuildContext context,
      int oAnkiIndex,
      int controlIndex,
      DillerListesi dillerListesi,
      List<Diller> diller,
      bool control,) {
    if (controlIndex == 0) {
      //Kelimeler
      databaseHelper.kelimeListesiniGetir().then((tumKelimeler) {
        kelimeleriDillereGoreEkle(tumKelimeler, dillerListesi);
        currLang = dilKontrol(context, oAnkiIndex, dillerListesi, diller, control);
        return currLang;
      });
    } else {
      //Ogrenilenler
    }
  }
}
