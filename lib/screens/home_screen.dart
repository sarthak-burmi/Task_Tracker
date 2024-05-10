import 'package:flutter/material.dart';
import 'package:task_tracker_assignment/constant/colors.dart';
import 'package:task_tracker_assignment/screens/task_list.dart';
import 'package:task_tracker_assignment/widgets/dateSelector.dart';
import 'package:task_tracker_assignment/widgets/greeting_text.dart';
import 'package:task_tracker_assignment/constant/task_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_tracker_assignment/screens/add_task.dart';

class TaskScreen extends StatelessWidget {
  final TaskController taskController = Get.find<TaskController>();
  final DateController dateController = Get.put(DateController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMM d, yyyy').format(now);

    String weekday = DateFormat('EEEE').format(now);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          OutlinedButton(onPressed: () {}, child: Text("")),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.02, horizontal: width * 0.040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.05),
                Row(
                  children: [
                    const CircleAvatar(
                      // backgroundImage: AssetImage("assets/images/DP 1.jpg"),
                      backgroundColor: Color.fromARGB(82, 7, 7, 7),
                    ),
                    SizedBox(width: width * 0.02),
                    Text(
                      "Hi, Sarthak ",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.01),
                TimeGreetingScreen(),
                Row(
                  children: [
                    Text(
                      "$formattedDate,",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    //const Spacer(),
                    Text(
                      weekday,
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.025),
                TaskDetails(
                  height: height,
                  width: width,
                  taskController: taskController,
                ),
                SizedBox(height: height * 0.0040),
                Obx(
                  () => DateSelector(
                    selectedIndex: dateController.selectedIndex.value,
                    onDateSelected: (index) {
                      dateController.updateSelectedIndex(index);
                    },
                  ),
                ),
                SizedBox(height: height * 0.01),
                TaskList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TaskDetails extends StatelessWidget {
  const TaskDetails({
    super.key,
    required this.height,
    required this.width,
    required this.taskController,
  });

  final double height;
  final double width;
  final TaskController taskController;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: completedTask,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Obx(
                () => RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                    children: [
                      TextSpan(
                        text: 'Completed\n',
                        style: GoogleFonts.kanit(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      TextSpan(
                        text: '${taskController.completedTasks.value} tasks',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: width * 0.02),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: remainigTask,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Obx(
                () => RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: 'Remaning\n',
                        style: GoogleFonts.kanit(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      TextSpan(
                        text: '${taskController.remainingTasks.value} tasks',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: width * 0.02),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTaskScreen(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: addTaskColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                    children: [
                      TextSpan(
                        text: 'Tap here\n',
                        style: GoogleFonts.kanit(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      TextSpan(
                        text: 'To add Task',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class DateController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }
}
