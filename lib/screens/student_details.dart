import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/models/Student.dart';
import 'package:todolist_app/utilities/sql_helper.dart';
import 'package:intl/intl.dart';


class StudentDetails extends StatefulWidget {
  String screenTitle;
  Student student;

  StudentDetails(this.student, this.screenTitle);

  @override
  State<StatefulWidget> createState() {
    return Students(student, screenTitle);
  }
}

class Students extends State<StudentDetails> {
  String screenTitle;
  Student student;
  SQL_Helper helper = new SQL_Helper();

  Students(this.student, this.screenTitle);

  static var status = ["success", "failed"];

  TextEditingController studentName = TextEditingController();
  TextEditingController studentDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    studentName.text = student.name;
    studentDescription.text = student.description;

    return WillPopScope(
        onWillPop: () {
          goBack();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(screenTitle),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                goBack();
              },
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                ListTile(
                    title: DropdownButton<String>(
                        items: status.map((String selectedItem) {
                          return DropdownMenuItem<String>(
                            value: selectedItem,
                            child: Text(selectedItem),
                          );
                        }).toList(),
                        style: textStyle,
                        value: getPassing(student.pass),
                        onChanged: (selectedItem) {
                          setState(() {
                            setPassing(selectedItem);
                          });
                        })),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    controller: studentName,
                    style: textStyle,
                    onChanged: (value) {
                      student.name = value;
                    },
                    decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    controller: studentDescription,
                    style: textStyle,
                    onChanged: (value) {
                     student.description = value;
                    },
                    decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            "SAVE",
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                           _save(student);
                             });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            "DELETE",
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                             _delete(student);
                             });
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void goBack() {
    Navigator.pop(context , true);
  }

  void setPassing(String value) {
    switch (value) {
      case "success":
        student.pass = 1;
        break;
      case "failed":
        student.pass = 2;
        break;
    }
  }

  String getPassing(int value) {
    String pass;
    switch (value) {
      case 1:
        pass = status[0];
        break;
      case 2:
        pass = status[1];
        break;
    }
    return pass;
  }

  void _save(Student student) async{

   //go back
    goBack();

    student.date = new DateFormat.yMMMd().format(DateTime.now());

   int result;
   if(student.id ==""){
     result = await helper.insertSudent(student);
   }else{
     result = await helper.updateSudent(student);
   }

  if(result==0){
    showAlertDialoge("sorry", "student can not be saved");
   }else{
    showAlertDialoge("congratulation", "student has been saved succefully");
  }

  }

  void _delete(Student student) async{
    //go back
    goBack();

    if(student.id ==null){
     showAlertDialoge("Ok Deleted", "NO Student has deleted");
     return;
    }
   int result = await helper.deleteSudent(student.id);
    if(result==0){
      showAlertDialoge("Ok Deleted", "NO Student has deleted");
    }else{
      showAlertDialoge("Ok Deleted", "Student has been deleted");
    }
  }

  void showAlertDialoge(String title , String content){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
    );
       showDialog(context: context , builder: (_) => alertDialog);

  }

}
