class Kelimeler {
  int kelimeID;
  int kategoriID;
  String kelimeENG;
  String kelimeTR;
  int kelimeSayac;

  Kelimeler({this.kategoriID, this.kelimeENG, this.kelimeTR, this.kelimeSayac});
  Kelimeler.withID({this.kategoriID, this.kelimeENG, this.kelimeTR, this.kelimeSayac});


  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic> ();

    map["kelimeID"] = kelimeID;
    map["kategoriID"] = kategoriID;
    map["kelimeENG"] = kelimeENG;
    map["kelimeTR"] = kelimeTR;
    map["kelimeSayac"] = kelimeSayac;

    return map;
  }

  Kelimeler.fromMap(Map<String, dynamic> map) {
    kelimeID = map["kelimeID"];
    kategoriID = map["kategoriID"];
    kelimeENG = map["kelimeENG"];
    kelimeTR = map["kelimeTR"];
    kelimeSayac = map["kelimeSayac"];
  }
}