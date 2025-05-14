import 'package:flutter/material.dart';

class TagSelector extends StatefulWidget {
  const TagSelector({super.key});

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  final List<String> tags = [
    'Family',
    'Social',
    'Work',
    'Healthcare',
    'Travel',
  ];
  final Set<String> selected = {};

  final TextEditingController _tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        ...tags.map(
          (tag) => FilterChip(
            label: Text(tag),
            selected: selected.contains(tag),
            onSelected: (v) {
              setState(() {
                if (v) {
                  selected.add(tag);
                } else {
                  selected.remove(tag);
                }
              });
            },
            selectedColor: Colors.white24,
            backgroundColor: Colors.white10,
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
        ActionChip(
          label: Text('add tag', style: TextStyle(color: Colors.white70)),
          backgroundColor: Colors.white10,
          onPressed: () async {
            final tag = await showDialog<String>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    backgroundColor: Colors.black,
                    title: Text(
                      'Add Tag',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: TextField(
                      controller: _tagController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Tag name',
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, null),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed:
                            () => Navigator.pop(context, _tagController.text),
                        child: Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
            );
            if (tag != null && tag.trim().isNotEmpty) {
              setState(() {
                tags.add(tag.trim());
                _tagController.clear();
              });
            }
          },
        ),
      ],
    );
  }
}
