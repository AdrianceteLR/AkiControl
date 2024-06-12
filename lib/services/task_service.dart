// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:akicontrol/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TasksService extends ChangeNotifier {
  final String _baseUrl =
      'akicontrol-48918-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Task> tasks = [];

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  Task selectTask = Task(
    finish: false,
    title: '',
    description: '',
    day: '',
  );

  TasksService() {
    loadTasks();
  }

  Future loadTasks() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'tasks.json');
    final resp = await http.get(url);

    final Map<String, dynamic> tasksMap = json.decode(resp.body);

    tasksMap.forEach((key, value) {
      final tempTask = Task.fromMap(value);
      tempTask.id = key;

      tasks.add(tempTask);
    });

    isLoading = false;
    notifyListeners();

    return tasks;
  }

  List<Task> getTasksForDay(DateTime day) {
    String dayStr = day.toIso8601String().split('T')[0];
    return tasks.where((task) => task.day!.startsWith(dayStr)).toList();
  }

  Future saveOrCreateTask(Task task) async {
    isSaving = true;
    notifyListeners();

    if (task.id == null) {
      await createTask(task);
    } else {
      await updateTask(task);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateTask(Task task) async {
    final url = Uri.https(_baseUrl, 'tasks/${task.id}.json');
    final resp = await http.put(url, body: task.toJson());
    final decodedData = resp.body;

    final index = tasks.indexWhere((element) => element.id == task.id);
    tasks[index] = task;

    return task.id!;
  }

  Future<String> createTask(Task task) async {
    final url = Uri.https(_baseUrl, 'tasks/.json');
    final resp = await http.post(url, body: task.toJson());
    final decodedData = jsonDecode(resp.body);

    task.id = decodedData['name'];
    tasks.add(task);

    return task.id!;
  }

  Future<void> deleteTask(String id) async {
    final url = Uri.https(_baseUrl, 'tasks/$id.json');
    await http.delete(url);

    tasks.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
