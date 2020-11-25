import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todolist_app/models/Student.dart';

class SQL_Helper {
  static SQL_Helper dbHelper;
  static Database _database;

  //new constructor from this class
  SQL_Helper._createInstance();

  //constructor return value
  factory SQL_Helper() {
    if (dbHelper == null) {
      dbHelper = SQL_Helper._createInstance();
    }
    return dbHelper;
  }

  String tableName = "student_table";
  String _id = "id";
  String _name = "name";
  String _description = "description";
  String _date = "data";
  String _pass = "pass";

  //function getter for database
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    var path = directory.path + "students.db";
    var studentsDB =
        await openDatabase(path, version: 1, onCreate: createDatabase);

    return studentsDB;
  }

  void createDatabase(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableName($_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        " $_name TEXT, $_description TEXT, $_date TEXT, $_pass INTEGER)");
  }

  //get all students from database
  Future<List<Map<String, dynamic>>> getStudentsMapList() async {
    Database db = await this.database;
    var results = await db.query(tableName, orderBy: "$_id ASC");
    return results;
  }

  //insert into database
  Future<int> insertSudent(Student student) async {
    Database db = await this.database;
    var result = await db.insert(tableName, student.toMap());
    return result;
  }

  //update from database
  Future<int> updateSudent(Student student) async {
    Database db = await this.database;
    var result = await db.update(tableName, student.toMap() , where: "where $_id ?" , whereArgs: [student.id]);
    return result;
  }

  //delete from database
  Future<int> deleteSudent(int id) async {
    Database db = await this.database;
    var result = await db.rawDelete("DELETE FROM $tableName WHERE $_id = $id");
    return result;
  }

  //get all count of students in list
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String , dynamic>> all = await db.rawQuery("SELECT (*) FROM $tableName");
    int  result = Sqflite.firstIntValue(all);
    return result;
  }

  //return list of students
  Future<List<Student>> getStudentList ()async{
   var studentMapList = await getStudentsMapList();
   int count = studentMapList.length;
   List<Student> students= new List<Student>();

   for(int i=0 ; i<=count-1 ; i++){
     students.add(Student.getMap(studentMapList[i]));
   }
   return students;
  }

}
