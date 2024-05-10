import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_tracker_assignment/constant/colors.dart';
import 'package:task_tracker_assignment/constant/task_controller.dart';
import 'package:task_tracker_assignment/model/task_model.dart';
import 'package:task_tracker_assignment/widgets/custom_toast.dart';
import 'package:task_tracker_assignment/widgets/timePicker.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({required this.task, super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  DateTime? _selectedDate;
  String _fromTime = '12:00';
  String _toTime = '12:00';

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    _selectedDate = widget.task.selectedDate;
    _fromTime = widget.task.from;
    _toTime = widget.task.to;
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
      appBar: AppBar(
        title: Text(
          'Edit Task',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.02,
          horizontal: width * 0.040,
        ),
        child: Column(
          children: [
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: GoogleFonts.montserrat(),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: GoogleFonts.montserrat(),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  GestureDetector(
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
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Text(
                              _selectedDate != null
                                  ? DateFormat('dd-MM-yyyy')
                                      .format(_selectedDate!)
                                  : 'Select Date',
                              style: GoogleFonts.montserrat(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  CustomTimePicker(
                    label: 'From',
                    onTimeSelected: (TimeOfDay selectedTime) {
                      _fromTime = '${selectedTime.hour}:${selectedTime.minute}';
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  CustomTimePicker(
                    label: 'To',
                    onTimeSelected: (TimeOfDay selectedTime) {
                      _toTime = '${selectedTime.hour}:${selectedTime.minute}';
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      _updateTask(context);
                    },
                    child: Text('Update Task'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateTask(BuildContext context) {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (title.isNotEmpty && description.isNotEmpty && _selectedDate != null) {
      widget.task.title = title;
      widget.task.description = description;
      widget.task.selectedDate = _selectedDate!;
      widget.task.from = _fromTime;
      widget.task.to = _toTime;

      Get.find<TaskController>().updateTask(widget.task);
      customToast('Task updated successfully', context: context, Colors.green);
      Navigator.pop(context);
    } else {
      customToast(
          'Please enter all required fields',
          context: context,
          Colors.red.shade500);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
