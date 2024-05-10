import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_tracker_assignment/constant/colors.dart';

class DateSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDateSelected;

  const DateSelector({
    super.key,
    required this.selectedIndex,
    required this.onDateSelected,
  });

  List<DateTime> _getNext7Days() {
    List<DateTime> dates = [];
    DateTime today = DateTime.now();
    dates.add(DateTime(0));
    for (int i = 0; i < 7; i++) {
      dates.add(today.add(Duration(days: i)));
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    List<DateTime> dates = _getNext7Days();

    return SizedBox(
      height: height * 0.08,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          DateTime date = dates[index];
          bool isAllOption = date.year == 0;
          bool isSelected = index == selectedIndex;
          String weekday;
          String dateText;

          if (isAllOption) {
            weekday = "";
            dateText = "";
          } else {
            if (DateTime.now().day == date.day) {
              weekday = "Today";
            } else {
              weekday = DateFormat('EEEE').format(date).substring(0, 3);
            }

            dateText = DateFormat('d' ' ' 'MMM').format(date);
          }

          return GestureDetector(
            onTap: () => onDateSelected(index),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.010),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isAllOption || !isAllOption) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: height * 0.009,
                        horizontal: width * 0.03,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? mainColor : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isAllOption ? "All" : dateText,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                  Text(
                    weekday,
                    style: TextStyle(
                      color: isSelected ? mainColor : Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
