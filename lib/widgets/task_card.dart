import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String due;

  const TaskCard({super.key, required this.title, required this.due});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Due in: $due', style: TextStyle(color: Colors.white70)),
        trailing: Checkbox(
          value: false,
          onChanged: (v) {},
          activeColor: Colors.white,
          checkColor: Colors.black,
        ),
      ),
    );
  }
}
