import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:task_tracker_assignment/model/task_model.dart';
import 'package:task_tracker_assignment/screens/home_screen.dart';

class TaskController extends GetxController {
  late Box<Task> tasksBox;

  final tasks = <Task>[].obs;
  final completedTasks = 0.obs;
  final remainingTasks = 0.obs;

  @override
  void onInit() async {
    super.onInit();

    try {
      await Hive.openBox<Task>('tasks');
      tasksBox = Hive.box<Task>('tasks');
      tasks.assignAll(tasksBox.values.toList());
      updateTaskCounters();
    } catch (e) {
      print('Error opening Hive box: $e');
    }

    final DateController dateController = Get.put(DateController());
    dateController.selectedIndex.listen((_) {
      updateTaskCounters(); // Recalculate counters
    });
  }

  void updateTaskCounters() {
    try {
      final DateController dateController = Get.find<DateController>();
      final selectedDateIndex = dateController.selectedIndex.value;

      List<Task> filteredTasks;

      if (selectedDateIndex == 0) {
        filteredTasks = tasks; // All tasks
      } else {
        final DateTime selectedDate = _getNext7Days()[selectedDateIndex];
        filteredTasks = tasks
            .where(
              (task) => DateUtils.isSameDay(task.selectedDate, selectedDate),
            )
            .toList();
      }

      int completedCount = filteredTasks.where((task) => task.completed).length;
      completedTasks.value = completedCount;
      remainingTasks.value = filteredTasks.length - completedCount;
    } catch (e) {
      // Handle the exception gracefully
      print('Error updating task counters: $e');
    }
  }

  List<DateTime> _getNext7Days() {
    List<DateTime> dates = [];
    DateTime today = DateTime.now();
    dates.add(DateTime(0)); // "All" selection
    for (int i = 0; i < 7; i++) {
      dates.add(today.add(Duration(days: i)));
    }
    return dates;
  }

  void addTask(Task task) {
    try {
      tasksBox.add(task);
      tasks.add(task);
      updateTaskCounters();
    } catch (e) {
      print('Error adding task to Hive box: $e');
    }
  }

  void deleteTask(Task task) {
    try {
      int index = tasks.indexOf(task);
      if (index != -1) {
        tasks.removeAt(index);
        tasksBox.deleteAt(index);
        tasksBox.compact();
        updateTaskCounters(); // Update counters after deletion
      }
    } catch (e) {
      print('Error deleting task from Hive box: $e');
    }
  }

  void updateTask(Task task) {
    try {
      int index = tasks.indexOf(task);
      if (index != -1) {
        tasks[index] = task;
        tasksBox.putAt(index, task);

        updateTaskCounters();
      }
    } catch (e) {
      print('Error updating task in Hive box: $e');
    }
  }
}
