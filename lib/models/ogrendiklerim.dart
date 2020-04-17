class Ogrendiklerim {

  int ogrenilenID;
  int kategoriID;
  int languagesID;
  String kelimeENG;
  String kelimeTR;

  Ogrendiklerim({this.kategoriID, this.kelimeENG, this.kelimeTR, this.languagesID});
  Ogrendiklerim.withID({this.ogrenilenID, this.kategoriID, this.kelimeENG, this.kelimeTR, this.languagesID});


  Map<String, dynamic> toMap () {
    var map = Map<String, dynamic>();

    map["ogrenilenID"] = ogrenilenID;
    map["kategoriID"] = kategoriID;
    map["kelimeENG"] = kelimeENG;
    map["kelimeTR"] = kelimeTR;
    map["languagesID"] = languagesID;

    return map;
  }

  Ogrendiklerim.fromMap(Map<String, dynamic> map) {
    ogrenilenID = map["ogrenilenID"];
    kategoriID = map["kategoriID"];
    kelimeENG = map["kelimeENG"];
    kelimeTR = map["kelimeTR"];
    languagesID = map["languagesID"];
  }

}