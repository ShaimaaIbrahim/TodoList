

class Student{

  int _id;
  String _name;
  String _description;
  int _pass;
  String _date;

  Student(this._name, this._description, this._pass, this._date);

  Student.withId(this._id, this._name, this._description, this._pass, this._date);

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  int get pass => _pass;

  set pass(int value) {
    if(value>=1 && value<=2){
      _pass = value;
    }
  }

  String get description => _description;
  set description(String value) {
    if(value.length <= 255){
      _description = value;
    }
  }

  String get name => _name;
  set name(String value) {
    if(value.length<=255){
      _name = value;
    }
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Map<String , dynamic> toMap(){
    var map = Map<String , dynamic>();
    map["id"] = this._id;
    map["name"] = this._name;
    map["description"]  =this._description;
    map["date"] =this._date;
    map["pass"] =this._pass;

    return map;
  }

  //extension function to add specified function for class
    Student.getMap(Map<String , dynamic> map){
    this._id = map["id"];
    this._name = map["name"];
    this._description=map["description"];
    this._date=map["date"];
    this._pass=map["pass"];
  }
}






