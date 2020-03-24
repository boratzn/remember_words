class Kelimeler {
  int kelimeID;
  int kategoriID;
  String kelimeENG;
  String kelimeTR;

  Kelimeler({this.kategoriID, this.kelimeENG, this.kelimeTR});
  Kelimeler.withID({this.kategoriID, this.kelimeENG, this.kelimeTR});


  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic> ();

    map["kelimeID"] = kelimeID;
    map["kategoriID"] = kategoriID;
    map["kelimeENG"] = kelimeENG;
    map["kelimeTR"] = kelimeTR;

    return map;
  }

  Kelimeler.fromMap(Map<String, dynamic> map) {
    kelimeID = map["kelimeID"];
    kategoriID = map["kategoriID"];
    kelimeENG = map["kelimeENG"];
    kelimeTR = map["kelimeTR"];
  }
}