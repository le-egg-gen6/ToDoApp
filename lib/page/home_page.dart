import 'package:first_app/dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:first_app/to_do_tile.dart';
import 'package:first_app/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  final _myBox = Hive.box('mybox');

  ToDoDataList data = ToDoDataList();

  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      data.createInitialData();
    } else {
      data.loadData();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('TO DO'),
        elevation: 0,

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: data.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: data.toDoList[index][0],
            taskCompleted: data.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }

  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      data.toDoList[index][1] = !data.toDoList[index][1];
    });
    data.updateData();
  }

  void saveNewTask() {
    setState(() {
      data.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    data.updateData();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        }
    );
  }

  void deleteTask(int index) {
    setState(() {
      data.toDoList.removeAt(index);
    });
    data.updateData();
  }

}
