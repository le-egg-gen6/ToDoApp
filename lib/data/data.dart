import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataList {
  List toDoList = [];
  
  final _myBox = Hive.box('mybox');

  void createInitialData() {
    toDoList = [
      ['Code', false],
      ['Study', true]
    ];
  }
  
  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  void updateData() {
    _myBox.put("TODOLIST", toDoList);
  }
}