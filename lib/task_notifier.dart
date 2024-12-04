import 'package:flutter/material.dart';

class TaskNotifier extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners(); 
  }

  void updateTask(int index, Task task) {
    _tasks[index] = task;
    notifyListeners(); 
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}

class Task {
  final String title;
  final String description;

  Task({required this.title, required this.description});
}
