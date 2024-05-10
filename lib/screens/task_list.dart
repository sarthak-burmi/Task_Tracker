import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_tracker_assignment/constant/colors.dart';
import 'package:task_tracker_assignment/constant/task_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_tracker_assignment/model/task_model.dart';
import 'package:animate_do/animate_do.dart';
import 'package:task_tracker_assignment/screens/editTask.dart';
import 'package:task_tracker_assignment/screens/home_screen.dart';
import 'package:task_tracker_assignment/widgets/custom_toast.dart';

// ignore: use_key_in_widget_constructors
class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find<TaskController>();
    final DateController dateController = Get.find<DateController>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () {
                final selectedDateIndex = dateController.selectedIndex.value;
                final List<Task> allTasks = taskController.tasks.toList();

                List<Task> filteredTasks;
                if (selectedDateIndex == 0) {
                  filteredTasks = allTasks;
                } else {
                  final DateTime selectedDate =
                      _getNext7Days()[selectedDateIndex];
                  filteredTasks = allTasks
                      .where(
                        (task) => DateUtils.isSameDay(
                            task.selectedDate, selectedDate),
                      )
                      .toList();
                }

                filteredTasks
                    .sort((a, b) => a.selectedDate.compareTo(b.selectedDate));

                if (filteredTasks.isEmpty) {
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
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: filteredTasks.map(
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
                            customToast('Task Deleted', Colors.red.shade500,
                                context: context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: FadeInUp(
                              duration: const Duration(milliseconds: 500),
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    width: 0.99,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 7,
                                    horizontal: 4,
                                  ),
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
                                          activeColor: addTaskColor,
                                          onChanged: (value) {
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
                                            SizedBox(width: width * 0.01),
                                            Text(
                                              DateFormat('MMMM d, yyyy')
                                                  .format(task.selectedDate),
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(width: width * 0.01),
                                            const Icon(Icons.access_time),
                                            SizedBox(width: width * 0.01),
                                            Text(
                                              '${task.from} - ${task.to}',
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: mainColor,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditTaskScreen(
                                                            task: task),
                                                  ),
                                                );
                                              },
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

  List<DateTime> _getNext7Days() {
    List<DateTime> dates = [];
    DateTime today = DateTime.now();
    dates.add(DateTime(0));
    for (int i = 0; i < 7; i++) {
      dates.add(today.add(Duration(days: i)));
    }
    return dates;
  }
}
