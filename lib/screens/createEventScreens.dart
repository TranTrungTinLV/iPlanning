import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/models/Budget.dart';
import 'package:iplanning/models/categoryClass.dart';
import 'package:iplanning/screens/loading_manager.dart';
import 'package:iplanning/services/cloud.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';
import 'package:iplanning/widgets/dropdownCategories.dart';
import 'package:iplanning/widgets/mutipleImage.dart';

class CreateEventScreens extends StatefulWidget {
  CreateEventScreens(
      {super.key,
      required this.list,
      required this.uid,
      required this.username,
      required this.avatar});
  final String uid;
  final String username;
  final String? avatar;
  final List<CategoryModel> list;
  @override
  State<CreateEventScreens> createState() => _CreateEventScreensState();
}

class _CreateEventScreensState extends State<CreateEventScreens> {
  DateTime? _selectedDate;
  DateTime? _startDate;
  DateTime? _endDate;
  List<Uint8List>? fileImage = [];
  TextEditingController description = TextEditingController();
  TextEditingController eventName = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController eventType = TextEditingController();

  bool isLoading = false;
  void _presentDatePicker({required bool isStartDate}) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.day, now.month, now.year - 1);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: DateTime(2030));
    setState(() {
      if (pickedDate != null) {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      }
    });
  }

  uploadEvent() async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await ClouMethods().uploadPost(
        username: widget.username,
        profilePic: widget.avatar,
        event_name: eventName.text,
        eventDateEnd: Timestamp.fromDate(_startDate!),
        eventDateStart: Timestamp.fromDate(_endDate!),
        uid: widget.uid,
        location: location.text,
        eventType: eventType.text,
        description: description.text,
        eventImages: fileImage!,
      );
      if (res == 'success') {
        // Sử dụng popUntil để quay về HomeScreen
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingManager(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Customizing'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: MutipleImage(
                          images: fileImage!,
                        ),
                      ),
                      TextFieldCustom(
                        controller: eventName,
                        title: 'Event Name',
                        radius: 10.0,
                      ),
                      Dropdowncategories(
                        list: widget.list,
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: TextFieldCustom(
                            controller: eventType,
                            title: 'Event Type',
                            radius: 10.0,
                          )),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Date&time',
                          style: TextStyle(fontSize: 25),
                        ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Icon(Icons.calendar_month_outlined),
                                  ),
                                  Container(
                                      child: Text(_startDate == null
                                          ? 'Select Start Date'
                                          : '${_startDate!.toLocal()}'
                                              .split(' ')[0]))
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
                              print('end date');
                              _presentDatePicker(isStartDate: false);
                            },
                            child: Container(
                              width: 150,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Icon(Icons.calendar_month_outlined),
                                  ),
                                  Container(
                                      child: Text(_endDate == null
                                          ? 'Select End Date'
                                          : '${_endDate!.toLocal()}'
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
                      SizedBox(
                        height: 20,
                      ),
                      TextFieldCustom(
                        controller: description,
                        title: 'Events description',
                        minLine: 3,
                        radius: 10.0,
                        maxLine: 10,
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  print('create Events');
                  uploadEvent();
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
      ),
    );
  }
}
