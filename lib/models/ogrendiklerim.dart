class Ogrendiklerim {

  int ogrenilenID;
  int kategoriID;
  String kelimeENG;
  String kelimeTR;

  Ogrendiklerim({this.kategoriID, this.kelimeENG, this.kelimeTR});
  Ogrendiklerim.withID({this.ogrenilenID, this.kategoriID, this.kelimeENG, this.kelimeTR});


  Map<String, dynamic> toMap () {
    var map = Map<String, dynamic>();

    map["ogrenilenID"] = ogrenilenID;
    map["kategoriID"] = kategoriID;
    map["kelimeENG"] = kelimeENG;
    map["kelimeTR"] = kelimeTR;

    return map;
  }

  Ogrendiklerim.fromMap(Map<String, dynamic> map) {
    ogrenilenID = map["ogrenilenID"];
    kategoriID = map["kategoriID"];
    kelimeENG = map["kelimeENG"];
    kelimeTR = map["kelimeTR"];

  }



}