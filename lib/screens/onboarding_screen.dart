import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<Map<String, dynamic>> tasks = [
    {
      'icon': Icons.bedtime,
      'label': 'Wake Up Early',
      'category': 'Morning Routine',
    },
    {
      'icon': Icons.local_drink,
      'label': 'Drink water first thing',
      'category': 'Morning Routine',
    },
    {
      'icon': Icons.fitness_center,
      'label': 'Excercise',
      'category': 'Physical Health',
    },
    {
      'icon': Icons.breakfast_dining,
      'label': 'Eat a Healthy Breakfast',
      'category': 'Nutrition',
    },
    {
      'icon': Icons.medication,
      'label': 'Take supplements',
      'category': 'Physical Health',
    },
    {
      'icon': Icons.self_improvement,
      'label': 'Meditate',
      'category': 'Mental Well-being',
    },
    {
      'icon': Icons.calendar_today,
      'label': 'Plan your day',
      'category': 'Productivity',
    },
  ];
  final Set<int> selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What tasks do you want to track today?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Select tasks to add to your routine.',
              style: TextStyle(fontSize: 14, color: Colors.white60),
            ),
            SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                itemCount: tasks.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, idx) {
                  final isSelected = selected.contains(idx);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selected.remove(idx);
                        } else {
                          selected.add(idx);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white24 : Colors.white10,
                        borderRadius: BorderRadius.circular(18),
                        border:
                            isSelected
                                ? Border.all(color: Colors.white, width: 2)
                                : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            tasks[idx]['icon'],
                            size: 40,
                            color: Colors.white,
                          ),
                          SizedBox(height: 12),
                          Text(
                            tasks[idx]['label'],
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Text('Skip'),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white, width: 2), // 白色外边框
                    foregroundColor: Colors.white, // 文字颜色
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    // 获取选中的任务
                    final selectedTasks =
                        selected
                            .map(
                              (idx) => {
                                'title': tasks[idx]['label'],
                                'category': tasks[idx]['category'],
                              },
                            )
                            .toList();

                    Navigator.pushReplacementNamed(
                      context,
                      '/home',
                      arguments: selectedTasks,
                    );
                  },
                  child: Text('Proceed'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
