import 'package:flutter/material.dart';
import 'home_screen.dart'; // 导入 Task 类

class TaskManagerScreen extends StatefulWidget {
  final List<Task> tasks;
  TaskManagerScreen({required this.tasks});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  late List<Task> editableTasks;

  @override
  void initState() {
    super.initState();
    editableTasks = List<Task>.from(widget.tasks);
  }

  void _deleteTask(int index) {
    setState(() {
      editableTasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Tasks'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: editableTasks.length,
        itemBuilder: (context, index) {
          final task = editableTasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.category),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTask(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.check, color: Colors.white),
        onPressed: () {
          Navigator.pop(context, editableTasks);
        },
      ),
    );
  }
}
