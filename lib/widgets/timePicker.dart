import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final void Function(TimeOfDay)? onTimeSelected;
  final String label;

  const CustomTimePicker({Key? key, this.onTimeSelected, required this.label})
      : super(key: key);

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () async {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: _selectedTime,
        );

        if (pickedTime != null && widget.onTimeSelected != null) {
          setState(() {
            _selectedTime = pickedTime;
          });
          widget.onTimeSelected!(pickedTime);
        }
      },
      child: Container(
        height: height * 0.078,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time),
            const SizedBox(width: 5),
            Text(widget.label),
            const Spacer(),
            Text(
              '${_selectedTime.hourOfPeriod}:${_selectedTime.minute} ${_selectedTime.period == DayPeriod.am ? 'AM' : 'PM'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
