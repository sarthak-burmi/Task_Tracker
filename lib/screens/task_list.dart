import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_tracker_assignment/constant/colors.dart';
import 'package:task_tracker_assignment/constant/task_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_tracker_assignment/model/task_model.dart';
import 'package:task_tracker_assignment/widgets/custom_toast.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find<TaskController>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () {
                final List<Task> sortedTasks =
                    [...taskController.tasks].toList()
                      ..sort((a, b) {
                        final DateTime aDate = a.selectedDate;
                        final DateTime bDate = b.selectedDate;
                        return aDate.compareTo(bDate);
                      });
                if (sortedTasks.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image(
                        height: height * 0.4,
                        image: const AssetImage(
                          "assets/images/Oops! 404 Error with a broken robot-rafiki.png",
                        ),
                      ),
                      Center(
                        child: Text(
                          "No Tasks Are Added",
                          style: GoogleFonts.montserrat(
                            color: completedTask,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return Column(
                    children: sortedTasks.map(
                      (task) {
                        return Dismissible(
                          key: Key(task.hashCode.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(Icons.delete, color: Colors.white),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Delete',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Text(
                                    "Confirm",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  content: Text(
                                    "Are you sure you want to delete this task?",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text(
                                        "CANCEL",
                                        style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text(
                                        "DELETE",
                                        style: GoogleFonts.montserrat(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) {
                            taskController.deleteTask(task);
                            customToast(
                              'Task Deleted',
                              context: context,
                              Colors.red.shade500,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: FadeInUp(
                              duration: const Duration(milliseconds: 500),
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                    width: 0.99,
                                    color: Colors.black,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: height * 0.009,
                                      horizontal: width * 0.009),
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Text(
                                          task.title,
                                          style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 29,
                                          ),
                                        ),
                                        const Spacer(),
                                        CupertinoSwitch(
                                          value: task.completed,
                                          activeColor: taskcard,
                                          trackColor: Colors.black,
                                          onChanged: (value) {
                                            print(
                                                'Switch state changed: $value');
                                            task.completed = value;
                                            taskController.updateTask(task);
                                          },
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.description,
                                          style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Icon(Icons.date_range),
                                            const SizedBox(width: 5),
                                            Text(
                                              DateFormat('MMMM d, yyyy')
                                                  .format(task.selectedDate),
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            const SizedBox(width: 20),
                                            const Icon(Icons.access_time),
                                            const SizedBox(width: 5),
                                            Text(
                                              '${task.from} - ${task.to}',
                                              // TextStyle for displaying time
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
