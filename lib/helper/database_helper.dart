import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:remember_words/models/kategori.dart';
import 'package:remember_words/models/kelimeler.dart';
import 'dart:io';

import "package:synchronized/synchronized.dart";
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{

  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._internal();

  factory DatabaseHelper(){

    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    }else {
      return _databaseHelper;
    }
  }

  Future<Database>_getDataBase() async{

    if(_database == null){
      _database = await _initializeDataBase();
      return _database;
    }else {
      return _database;
    }
  }

  _initializeDataBase() async{
    var lock = Lock();
    Database _db;

      if(_db == null) {
        await lock.synchronized(() async{
          if(_db == null) {
            var databasesPath = await getDatabasesPath();
            var path = join(databasesPath, "appDB.db");
            var file = new File(path);

            // check if file exists
            if(!await file.exists()) {
              // Copy from asset
              ByteData data = await rootBundle.load(join("assets", "words.db"));
              List<int> bytes =
                  data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
              await new File(path).writeAsBytes(bytes);
            }
            // open the database
            _db = await openDatabase(path);
          }
        });
      }
      return _db;
  }

  Future<List<Map<String, dynamic>>> kategorileriGetir() async{
    
    var db = await _getDataBase();
    var sonuc = await db.query("kategori");
    
    return sonuc;
  }

  Future<int> kategoriEkle(Kategori kategori) async{

    var db = await _getDataBase();
    var sonuc = await db.insert("kategori", kategori.toMap());
    return sonuc;
  }

  Future<int> kategoriGuncelle(Kategori kategori) async{

    var db = await _getDataBase();
    var sonuc = await db.update("kategori", kategori.toMap(), where: "kategoriID = ?",whereArgs: [kategori.kategoriID]);
    return sonuc;
  }

  Future<int> kategoriSil(int kategoriID) async{

    var db = await _getDataBase();
    var sonuc = await db.delete("kategori", where: "kategoriID = ?", whereArgs: [kategoriID]);
    return sonuc;
  }

  Future<List<Kategori>> kategoriListesiniGetir() async{
    var kategoriIcerenMapListesi = await kategorileriGetir();
    var kategoriListesi = List<Kategori>();
    for(Map map in kategoriIcerenMapListesi){
      kategoriListesi.add(Kategori.fromMap(map));
    }
    return kategoriListesi;
  }

  //*****************************Kelimeler************************

  Future<List<Map<String, dynamic>>> kelimeleriGetir() async{

    var db = await _getDataBase();
    var sonuc = await db.rawQuery('select * from "kelime" inner join kategori on kategori.kategoriID = "kelime".kategoriID order by kelimeID Desc;');

    return sonuc;
  }
  
  Future<List<Kelimeler>> kelimeListesiniGetir() async{
    
    var kelimelerMapListesi = await kelimeleriGetir();
    var kelimeListesi = List<Kelimeler>();
    
    for(Map map in kelimelerMapListesi) {
      kelimeListesi.add(Kelimeler.fromMap(map));
    }
    return kelimeListesi;
  }

  Future<int> kelimeEkle(Kelimeler kelimeler) async{

    var db = await _getDataBase();
    var sonuc = await db.insert("kelime", kelimeler.toMap());
    return sonuc;
  }

  Future<int> kelimeGuncelle(Kelimeler kelimeler) async{

    var db = await _getDataBase();
    var sonuc = await db.update("kelime", kelimeler.toMap(), where: "kelimeID = ?", whereArgs: [kelimeler.kelimeID]);
    return sonuc;
  }

  Future<int> kelimeSil(int kelimeID) async{

    var db = await _getDataBase();
    var sonuc = await db.delete("kelime", where: "kelimeID = ?", whereArgs: [kelimeID]);
    return sonuc;
  }

  String dateFormat(DateTime tm){

    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String month;
    switch (tm.month) {
      case 1:
        month = "Ocak";
        break;
      case 2:
        month = "Şubat";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Nisan";
        break;
      case 5:
        month = "Mayıs";
        break;
      case 6:
        month = "Haziran";
        break;
      case 7:
        month = "Temmuz";
        break;
      case 8:
        month = "Ağustos";
        break;
      case 9:
        month = "Eylük";
        break;
      case 10:
        month = "Ekim";
        break;
      case 11:
        month = "Kasım";
        break;
      case 12:
        month = "Aralık";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Bugün";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Dün";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "Pazartesi";
        case 2:
          return "Salı";
        case 3:
          return "Çarşamba";
        case 4:
          return "Perşembe";
        case 5:
          return "Cuma";
        case 6:
          return "Cumartesi";
        case 7:
          return "Pazar";
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
    return "";


  }

}