import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'task_manager_screen.dart';
import '../l10n/app_localizations.dart';

class Task {
  String title;
  String category;
  bool completed;
  int streak;
  String lastCheckInDate; // 新增

  Task({
    required this.title,
    required this.category,
    this.completed = false,
    this.streak = 0,
    this.lastCheckInDate = '',
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'category': category,
    'completed': completed,
    'streak': streak,
    'lastCheckInDate': lastCheckInDate,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    title: json['title'],
    category: json['category'],
    completed: json['completed'] ?? false,
    streak: json['streak'] ?? 0,
    lastCheckInDate: json['lastCheckInDate'] ?? '',
  );
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  List<Task> trackedTasks = [];
  bool _initializedFromArgs = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadTasks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resetTasksForNewDay();
    }
  }

  // 格式化日期为 YYYY-MM-DD 格式
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // 每天自动重置勾选状态
  void _resetTasksForNewDay() async {
    final today = DateTime.now();
    final todayStr = _formatDate(today);
    final yesterday = today.subtract(Duration(days: 1));
    final yesterdayStr = _formatDate(yesterday);
    bool changed = false;
    
    for (var task in trackedTasks) {
      // 检查是否断档
      if (task.lastCheckInDate.isNotEmpty) {
        final lastDateParts = task.lastCheckInDate.split('-');
        final lastDate = DateTime(
          int.parse(lastDateParts[0]),
          int.parse(lastDateParts[1]),
          int.parse(lastDateParts[2]),
        );
        final diff = today.difference(lastDate).inDays;
        
        if (diff > 1) {  // 如果超过一天没打卡
          task.streak = 0;
          changed = true;
        }
      }
      
      // 重置完成状态
      if (task.lastCheckInDate != todayStr) {
        if (task.completed) {
          task.completed = false;
          changed = true;
        }
      }
    }
    
    if (changed) {
      setState(() {});
      await _saveTasks();
    }
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString('trackedTasks');
    if (tasksJson != null) {
      final List decoded = jsonDecode(tasksJson);
      setState(() {
        trackedTasks = decoded.map((e) {
          var task = Task.fromJson(e);
          // 确保streak不小于1
          if (task.streak < 1) {
            task.streak = 1;
          }
          return task;
        }).toList();
      });
      _resetTasksForNewDay();
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = jsonEncode(trackedTasks.map((e) => e.toJson()).toList());
    await prefs.setString('trackedTasks', tasksJson);
    print('Saved tasks:');
    for (var task in trackedTasks) {
      print('Task: ${task.title}, Streak: ${task.streak}, Last check-in: ${task.lastCheckInDate}');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedFromArgs && trackedTasks.isEmpty) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is List) {
        setState(() {
          trackedTasks =
              args
                  .map<Task>(
                    (item) =>
                        Task(title: item['title'], category: item['category']),
                  )
                  .toList();
          _initializedFromArgs = true;
        });
        _saveTasks();
      }
    }
    _resetTasksForNewDay();
  }

  void toggleTask(int index) async {
    final today = DateTime.now();
    final todayStr = _formatDate(today);
    final task = trackedTasks[index];

    // 只处理未完成的任务
    if (!task.completed) {
      // 打卡逻辑
      if (task.lastCheckInDate.isNotEmpty) {
        // 解析最后打卡日期
        final lastDateParts = task.lastCheckInDate.split('-');
        final lastDate = DateTime(
          int.parse(lastDateParts[0]), // year
          int.parse(lastDateParts[1]), // month
          int.parse(lastDateParts[2]), // day
        );
        
        // 计算日期差
        final diff = today.difference(lastDate).inDays;

        if (diff == 1) {
          // 连续，保持当前streak
        } else if (diff > 1) {
          // 断档，设为0
          task.streak = 0;
        } else if (diff == 0) {
          // 今天已打卡，不处理
        }
      } else {
        // 第一次打卡
        task.streak = 0;
      }
      
      // 完成打卡，streak + 1
      task.streak += 1;
      task.completed = true;
      task.lastCheckInDate = todayStr;
      setState(() {});
      await _saveTasks();
    }
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
      await _saveTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // 按类别分组
    Map<String, List<Task>> grouped = {};
    for (var task in trackedTasks) {
      grouped.putIfAbsent(task.category, () => []).add(task);
    }

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              padding: EdgeInsets.only(top: 40.0, bottom: 80.0),
              children: [
                Text(
                  l10n.dailyRoutines,
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
                                // 只在今天已打卡时展示 streak
                                if (task.completed)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16.0,
                                      bottom: 12.0,
                                    ),
                                    child: Text(
                                      '${l10n.currentStreak}：${task.streak}',
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
                  Text(l10n.noRoutines),
              ],
            ),
          ),
          // 悬浮按钮区域
          Positioned(
            left: 24,
            bottom: 24,
            child: FloatingActionButton(
              heroTag: 'removeBtn',
              backgroundColor: Colors.black,
              child: Icon(Icons.remove, color: Colors.white),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => TaskManagerScreen(tasks: trackedTasks),
                  ),
                );
                if (result != null && result is List<Task>) {
                  setState(() {
                    trackedTasks = result;
                  });
                  await _saveTasks();
                }
              },
            ),
          ),
          Positioned(
            right: 24,
            bottom: 24,
            child: FloatingActionButton(
              heroTag: 'addBtn',
              backgroundColor: Colors.black,
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () => _addTask(context),
            ),
          ),
        ],
      ),
    );
  }
}
