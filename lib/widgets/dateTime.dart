import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/utils/validator/date_time.dart';

class DateTimeScreen extends StatefulWidget {
  DateTimeScreen(
      {super.key,
      this.startDate,
      this.endDate,
      required this.isDateValid,
      required this.isStartDateSelected,
      required this.isEndDateSelected,
      required this.isTimeValid});

  Timestamp? startDate;
  Timestamp? endDate;
  bool isDateValid;
  bool isStartDateSelected;
  bool isEndDateSelected;
  bool isTimeValid;

  @override
  State<DateTimeScreen> createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {
  void _presentTimerPicker({required bool isTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isTime) {
          DateTime combinedStart = DateTime(
            widget.startDate!.toDate().year,
            widget.startDate!.toDate().month,
            widget.startDate!.toDate().day,
            pickedTime.hour,
            pickedTime.minute,
          );
          widget.startDate = Timestamp.fromDate(combinedStart);
        } else {
          DateTime combinedStart = DateTime(
            widget.endDate!.toDate().year,
            widget.endDate!.toDate().month,
            widget.endDate!.toDate().day,
            pickedTime.hour,
            pickedTime.minute,
          );

          widget.endDate = Timestamp.fromDate(combinedStart);
          widget.isTimeValid = validateTimes();
        }
      });
    }
  }

  void _presentDatePicker({required bool isStartDate}) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: DateTime(2030),
    );
    setState(() {
      if (pickedDate != null) {
        if (isStartDate) {
          int hour =
              widget.startDate != null ? widget.startDate!.toDate().hour : 0;
          int minute =
              widget.startDate != null ? widget.startDate!.toDate().minute : 0;
          DateTime combinedDate = DateTime(
              pickedDate.year, pickedDate.month, pickedDate.day, hour, minute);
          widget.startDate = Timestamp.fromDate(combinedDate);
          widget.isStartDateSelected = true;
        } else {
          int hour = widget.endDate != null ? widget.endDate!.toDate().hour : 0;
          int minute =
              widget.endDate != null ? widget.endDate!.toDate().minute : 0;
          DateTime combinedDate = DateTime(
              pickedDate.year, pickedDate.month, pickedDate.day, hour, minute);
          widget.endDate = Timestamp.fromDate(combinedDate);
          widget.isEndDateSelected = true;
        }
        widget.isTimeValid = validateTimes();

        widget.isDateValid = validateDates();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    "Start Date",
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      "End Date",
                      textAlign: TextAlign.start,
                    )),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print('start date');
                      _presentDatePicker(isStartDate: true);
                    },
                    child: Container(
                      width: 150,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: Icon(Icons.calendar_month_outlined),
                          ),
                          Container(
                            child: Text(widget.startDate == null
                                ? 'Select Start Date'
                                : '${widget.startDate!.toDate().toLocal()}'
                                    .split(' ')[0]),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.grey)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    print('end date');
                    _presentDatePicker(isStartDate: false);
                  },
                  child: Container(
                    width: 150,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Icon(Icons.calendar_month_outlined),
                        ),
                        Container(
                            child: Text(widget.endDate == null
                                ? 'Select End Date'
                                : '${widget.endDate!.toDate().toLocal()}'
                                    .split(' ')[0])),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey)),
                  ),
                )),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 3,
        ),

        if (!widget.isDateValid)
          Container(
            width: MediaQuery.of(context).size.width,
            child: const Text(
              'Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu',
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.red),
            ),
          ),
        if (!widget.isStartDateSelected)
          Container(
            width: MediaQuery.of(context).size.width,
            child: const Text(
              'Vui lòng chọn ngày bắt đầu',
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.red),
            ),
          ),
        if (!widget.isEndDateSelected)
          Container(
            width: MediaQuery.of(context).size.width,
            child: const Text(
              'Vui lòng chọn ngày kết thúc',
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.red),
            ),
          ),
        SizedBox(
          height: 10,
        ),
        // !TIme
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    "Start Time",
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      "End Time",
                      textAlign: TextAlign.start,
                    )),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    print('start time');
                    _presentTimerPicker(isTime: true);
                  },
                  child: Container(
                    width: 150,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Icon(Icons.timer_outlined),
                        ),
                        Container(
                            child: Text(widget.startDate == null
                                ? 'Select Start Time'
                                : '${widget.startDate!.toDate().hour}:${widget.startDate!.toDate().minute}'))
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey)),
                  ),
                )),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    _presentTimerPicker(isTime: false);
                  },
                  child: Container(
                    width: 150,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Icon(Icons.timer_outlined),
                        ),
                        Container(
                            child: Text(widget.endDate == null
                                ? 'Select End Time'
                                : '${widget.endDate!.toDate().hour}:${widget.endDate!.toDate().minute}')),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey)),
                  ),
                )),
              ],
            ),
            if (!widget.isTimeValid)
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Giờ kết thúc phải lớn hơn hoặc bằng giờ bắt đầu',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
