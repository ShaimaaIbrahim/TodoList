import 'package:flutter/material.dart';
import 'package:todolist_app/screens/student_details.dart';
import 'package:todolist_app/screens/student_list.dart';

void main(){
  runApp(MyApp());
}


class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: "todolist_app",

      theme: ThemeData(
        primarySwatch: Colors.lightBlue
      ),

      home: StudentList(),

    );
  }

}

//asynchronization in flutter
/*
void main() {
  //threas in flutter
//1-import dart.Async
//2-
print("start the application");
getFileContent();
print("end the application");

}
//methodod one
getFileContent() async{
  String fileContent = await downloadFile();
  print(fileContent);
}
//methodod two
getFileContent() async{
  Future<String> fileContent = downloadFile();
  fileContent.then((value) {
    print(value);
  });
}
//new background thread
Future<String> downloadFile() {
  //it will put value in content after 60 seconds
  Future<String> content = Future.delayed(Duration(seconds: 6), (){
   //do any action in new thread
    return "Internet file content";
  }
  );
  return content;
}
 */

