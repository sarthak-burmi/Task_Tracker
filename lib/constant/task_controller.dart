import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:task_tracker_assignment/model/task_model.dart';

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
      // Handle the exception gracefully
      print('Error opening Hive box: $e');
    }
  }

  void addTask(Task task) {
    try {
      tasksBox.add(task);
      tasks.add(task);
      updateTaskCounters();
    } catch (e) {
      // Handle the exception gracefully
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
        updateTaskCounters();
        update();
      }
    } catch (e) {
      // Handle the exception gracefully
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
        update();
      }
    } catch (e) {
      // Handle the exception gracefully
      print('Error updating task in Hive box: $e');
    }
  }

  void updateTaskCounters() {
    try {
      int completedCount = 0;
      for (Task task in tasks) {
        if (task.completed) {
          completedCount++;
        }
      }
      completedTasks.value = completedCount;
      remainingTasks.value = tasks.length - completedCount;
    } catch (e) {
      // Handle the exception gracefully
      print('Error updating task counters: $e');
    }
  }
}
