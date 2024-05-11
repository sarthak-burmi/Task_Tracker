import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:task_tracker_assignment/constant/task_controller.dart';
import 'package:task_tracker_assignment/model/task_adapter.dart';
import 'package:task_tracker_assignment/model/task_model.dart';
import 'package:task_tracker_assignment/screens/Authentication/login_screen.dart';
import 'package:task_tracker_assignment/screens/Authentication/sign_up.dart';
import 'package:task_tracker_assignment/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(TaskAdapter());
  Get.put(TaskController());
  await Hive.openBox<Task>('tasks');
  runApp(const TaskTracker());
}

class TaskTracker extends StatelessWidget {
  const TaskTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/home': (context) => TaskScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen()
      },
    );
  }
}
