import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_tracker_assignment/constant/colors.dart';
import 'package:task_tracker_assignment/screens/home_screen.dart';
import 'package:task_tracker_assignment/widgets/custom_toast.dart';
import 'package:task_tracker_assignment/constant/task_controller.dart';
import 'package:task_tracker_assignment/model/task_model.dart';
import 'package:task_tracker_assignment/widgets/timePicker.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  DateTime? _selectedDate;
  String _fromTime = '12';
  String _toTime = '12';

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: height * 0.02,
            horizontal: width * 0.040,
          ),
          child: Column(
            children: [
              SizedBox(height: height * 0.04),
              Row(
                children: [
                  Text(
                    "Add Task",
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskScreen()));
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                    ),
                  )
                ],
              ),
              SizedBox(height: height * 0.01),
              FadeInUp(
                duration: const Duration(milliseconds: 300),
                child: Image.asset(
                  "assets/images/add_notes-bro.png",
                  height: height * 0.26,
                ),
              ),
              SizedBox(height: height * 0.02),
              addtaskform(height, context, width),
            ],
          ),
        ),
      ),
    );
  }

  Form addtaskform(double height, BuildContext context, double width) {
    return Form(
      child: Column(
        children: [
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            child: TextFormField(
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: 18,
              ),
              controller: titleController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: addTaskColor, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Title',
                labelStyle: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              maxLength: 15,
            ),
          ),
          SizedBox(height: height * 0.001),
          FadeInUp(
            duration: const Duration(milliseconds: 500),
            child: TextFormField(
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: 18,
              ),
              controller: descriptionController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: addTaskColor, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Description',
                labelStyle: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.03),
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: Container(
                height: height * 0.078,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(9, 6, 1, 6),
                  child: Row(
                    children: [
                      Text(
                        _selectedDate != null
                            ? DateFormat('dd-MM-yyyy').format(_selectedDate!)
                            : "Selected Date",
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.03),
          FadeInUp(
            duration: const Duration(milliseconds: 700),
            child: Row(
              children: [
                Expanded(
                  child: CustomTimePicker(
                    label: "From",
                    onTimeSelected: (TimeOfDay selectedTime) {
                      setState(() {
                        _fromTime =
                            '${selectedTime.hour}:${selectedTime.minute} ';
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.03),
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: Row(
              children: [
                Expanded(
                  child: CustomTimePicker(
                    label: "To",
                    onTimeSelected: (TimeOfDay selectedTime) {
                      setState(() {
                        _toTime = '${selectedTime.hour}:${selectedTime.minute}';
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.02),
          FadeInUp(
            duration: const Duration(milliseconds: 900),
            child: SizedBox(
              width: width * 0.8,
              height: height * 0.05,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: completedTask,
                ),
                onPressed: () {
                  _addTask(context);
                },
                child: Text(
                  'Add Task',
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 19,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addTask(BuildContext context) {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (title.isNotEmpty && description.isNotEmpty && _selectedDate != null) {
      Task newTask = Task(
        title: title,
        description: description,
        selectedDate: _selectedDate!,
        from: _fromTime,
        to: _toTime,
      );
      Get.find<TaskController>().addTask(newTask);
      customToast('Task added', context: context, Colors.green.shade500);
      Navigator.pop(context);
    } else {
      showToast('Please enter all details',
          context: context,
          backgroundColor: Colors.red,
          animation: StyledToastAnimation.scale,
          reverseAnimation: StyledToastAnimation.fade);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        //print("Selected Date: $_selectedDate");
      });
    }
  }
}
