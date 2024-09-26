import 'package:flutter/material.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';
import 'package:iplanning/widgets/mutipleImage.dart';

class CreateEventScreens extends StatefulWidget {
  const CreateEventScreens({super.key});

  @override
  State<CreateEventScreens> createState() => _CreateEventScreensState();
}

class _CreateEventScreensState extends State<CreateEventScreens> {
  DateTime? _selectedDate;
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.day, now.month, now.year - 1);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: DateTime(2030));
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customizing'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        // margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.only(bottom: 10),
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stack(
            //   children: [
            // ! Multiple-images picker
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: MutipleImage(),
                    ),
                    TextFieldCustom(
                      title: 'Event Name',
                      radius: 10.0,
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: TextFieldCustom(
                          title: 'Event Type',
                          radius: 10.0,
                        )),
                    TextFieldCustom(
                      keyboardType: TextInputType.datetime,
                      title: 'Select Date Time',
                      radius: 10.0,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFieldCustom(
                      title: 'Events description',
                      minLine: 3,
                      radius: 10.0,
                      maxLine: 10,
                    ),
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                print('create Events');
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Color(0xff171924),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      'Public Now',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ],
          //   ),
          // ],
        ),
      ),
    );
  }
}
