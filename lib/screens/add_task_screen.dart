import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _controller = TextEditingController();
  String? selectedCategory;
  final List<String> categories = [
    'Morning Routine',
    'Physical Health',
    'Mental Well-being',
    'Productivity',
    'Nutrition',
    'Wealth',
    'Personal Growth',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task'), backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text(
              'Routine',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 24),
            Text(
              'Category',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items:
                  categories
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
              onChanged: (val) {
                setState(() {
                  selectedCategory = val;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              dropdownColor: Colors.black,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_controller.text.trim().isNotEmpty &&
                    selectedCategory != null) {
                  Navigator.pop(context, {
                    'title': _controller.text.trim(),
                    'category': selectedCategory,
                  });
                }
              },
              child: Text('Create routine', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
