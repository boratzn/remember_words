class Diller {
  int languagesID;
  String languagesName;
  String languagesIMG;

  Diller({this.languagesName, this.languagesIMG});

  Diller.withID({this.languagesID, this.languagesName, this.languagesIMG});


  Map<String, dynamic> toMap() {
    Map map = Map<String, dynamic>();
    map["languagesID"] = languagesID;
    map["languagesName"] = languagesName;
    map["languagesIMG"] = languagesIMG;

    return map;
  }

  Diller.fromMap(Map<String,dynamic> map) {
    languagesID = map["languagesID"];
    languagesName = map["languagesName"];
    languagesIMG = map["languagesIMG"];
  }

}