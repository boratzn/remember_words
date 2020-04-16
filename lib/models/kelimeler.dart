class Kelimeler {
  int kelimeID;
  int kategoriID;
  int languagesID;
  String kelimeENG;
  String kelimeTR;
  int kelimeSayac;

  Kelimeler({this.kategoriID, this.kelimeENG, this.kelimeTR, this.kelimeSayac,this.languagesID});
  Kelimeler.withID({this.kelimeID,this.kategoriID, this.kelimeENG, this.kelimeTR, this.kelimeSayac, this.languagesID});


  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic> ();

    map["kelimeID"] = kelimeID;
    map["kategoriID"] = kategoriID;
    map["kelimeENG"] = kelimeENG;
    map["kelimeTR"] = kelimeTR;
    map["kelimeSayac"] = kelimeSayac;
    map["languagesID"] = languagesID;

    return map;
  }

  Kelimeler.fromMap(Map<String, dynamic> map) {
    kelimeID = map["kelimeID"];
    kategoriID = map["kategoriID"];
    kelimeENG = map["kelimeENG"];
    kelimeTR = map["kelimeTR"];
    kelimeSayac = map["kelimeSayac"];
    languagesID = map["languagesID"];
  }

}