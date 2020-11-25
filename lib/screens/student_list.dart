import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/screens/student_details.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist_app/models/Student.dart';
import 'package:todolist_app/utilities/sql_helper.dart';

class StudentList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StudentState();
  }
}

class StudentState extends State<StudentList> {
  int count = 0;
  SQL_Helper helper = new SQL_Helper();
  List<Student> studentsList;

  @override
  Widget build(BuildContext context) {
    if (studentsList == null) {
      studentsList = new List<Student>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("TODO LIST"),
      ),
      body: getStudentsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToStudent(Student("" , "" , 1 , "") , "Add New Students");
        },
        tooltip: "Add",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getStudentsList() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(

              leading: CircleAvatar(

                backgroundColor: isPassed(this.studentsList[position].pass),
                child: getIcon(this.studentsList[position].pass),
              ),

              title: Text(this.studentsList[position].name),

              subtitle: Text(this.studentsList[position].description +
                  " " +
                  this.studentsList[position].date),
              trailing: GestureDetector(
                child: Icon(
                  Icons.auto_delete,
                  color: Colors.grey,
                ),
                onTap: () {
                  _delete(context, this.studentsList[position]);
                  updateListView();
                },
              ),
              onTap: () {
                navigateToStudent(this.studentsList[position] , "Edit Students");
              },
            ),
          );
        });
  }

  Color isPassed(int value) {
    switch (value) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.red;
      default:
        return Colors.amber;
    }
  }

  Icon getIcon(int value) {
    switch (value) {
      case 1:
        return Icon(Icons.check);
      case 2:
        return Icon(Icons.close);
    }
  }

 void updateListView(){
    Future<Database> db =  helper.initializeDatabase();
    db.then((db) {
    Future<List<Student>> students = helper.getStudentList();
    students.then((value){
      setState(() {
       this.studentsList= value;
       this.count=value.length;
      });
    });
   });
  }
  
  void _delete(BuildContext context, Student student) async {
    int result = await helper.deleteSudent(student.id);
    if (result != 0) {
      showSnackBar(context, "deleted succefully");
      updateListView();
    }
  }

  void showSnackBar(BuildContext context, String msg) {
    final snackbar = SnackBar(
      content: Text(msg),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void navigateToStudent(Student student , String appTitle) async{

   var result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StudentDetails(student , appTitle);
    }));

   if(result){
     updateListView();
   }
  }
}
