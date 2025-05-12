import 'package:flutter/material.dart';
import 'add_task_screen.dart'; // 确保已导入

class Task {
  String title;
  String category;
  bool completed;
  int streak;

  Task({
    required this.title,
    required this.category,
    this.completed = false,
    this.streak = 0,
  });
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> trackedTasks = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (trackedTasks.isEmpty) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is List) {
        trackedTasks =
            args.map<Task>((item) {
              return Task(title: item['title'], category: item['category']);
            }).toList();
      }
    }
  }

  void toggleTask(int index) {
    setState(() {
      trackedTasks[index].completed = !trackedTasks[index].completed;
      if (trackedTasks[index].completed) {
        trackedTasks[index].streak += 1;
      } else {
        trackedTasks[index].streak = 0;
      }
    });
  }

  Future<void> _addTask(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );
    if (result != null && result is Map) {
      setState(() {
        trackedTasks.add(
          Task(title: result['title'], category: result['category']),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 按类别分组
    Map<String, List<Task>> grouped = {};
    for (var task in trackedTasks) {
      grouped.putIfAbsent(task.category, () => []).add(task);
    }

    return Scaffold(
      // 没有 appBar
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text(
              'Daily Routines',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            if (grouped.isNotEmpty)
              ...grouped.entries.map(
                (entry) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(223, 26, 126, 227),
                      ),
                    ),
                    ...entry.value.asMap().entries.map((e) {
                      final index = trackedTasks.indexOf(e.value);
                      final task = e.value;
                      return Card(
                        color: Colors.white10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Checkbox(
                                value: task.completed,
                                onChanged: (v) => toggleTask(index),
                                activeColor: Colors.white,
                                checkColor: Colors.black,
                              ),
                            ),
                            if (task.streak > 0)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                  bottom: 12.0,
                                ),
                                child: Text(
                                  'Cureent Streak：${task.streak}',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      210,
                                      241,
                                      125,
                                      24,
                                    ),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 16),
                  ],
                ),
              )
            else
              Text('No routines tracked.'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () => _addTask(context),
      ),
      // 没有 bottomNavigationBar
    );
  }
}
