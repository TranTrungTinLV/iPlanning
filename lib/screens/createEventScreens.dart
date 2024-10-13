import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/models/Budget.dart';
import 'package:iplanning/models/categoryClass.dart';
import 'package:iplanning/screens/loading_manager.dart';
import 'package:iplanning/services/categories.dart';
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
  CategoryModel? _selectedCategories;
  bool isLoading = false;
  int _index = 0;
  bool isChecked = false;

  final _formKey = GlobalKey<FormState>();
  bool isFormValid = false;

  void validateForm() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        isFormValid = true;
      });
    } else {
      setState(() {
        isFormValid = false;
      });
    }
  }

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
          category_id: _selectedCategories!,
          isPost: isChecked);

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
        body: Stepper(
          currentStep: _index,
          onStepCancel: () {
            if (_index > 0) {
              setState(() {
                _index -= 1;
              });
            }
          },
          onStepContinue: () {
            // final isValid = _formKey.currentState!.validate();

            // if (isValid && _index < 1) {
            //   isFormValid;
            //   setState(() {
            //     _index += 1;
            //     isFormValid = true;
            //   });
            //   _formKey.currentState!.save();
            //   try {} catch (e) {}
            // } else {}
            if (_formKey.currentState != null &&
                _formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              setState(() {
                _index += 1;
                isFormValid = true;
              });
            }
          },
          onStepTapped: (int index) {
            setState(() {
              _index = index;
            });
          },
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_index == 0)
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isFormValid ? Color(0xffF0534F) : Colors.grey),
                        onPressed: details.onStepContinue,
                        child: const Text(
                          'Next Event Details',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  if (_index > 0)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepCancel,
                        child: const Text('Back'),
                      ),
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (_index > 0)
                    Expanded(
                      child: ElevatedButton(
                        // onPressed: details.onStepCancel,
                        onPressed: () {},
                        child: const Text('Done'),
                      ),
                    ),
                ],
              ),
            );
          },
          type: StepperType.horizontal,
          steps: <Step>[
            Step(
              state: _index > 0 ? StepState.complete : StepState.indexed,
              isActive: _index >= 0,
              title: Text('Create Event'),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                // padding: EdgeInsets.only(bottom: 10),
                // margin: EdgeInsets.only(
                //   left: 10,
                //   right: 10,
                //   top: 10,
                // ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: isFormValid
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.end,
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
                                onChanged: (value) {
                                  validateForm();
                                },
                                title: 'Event Name',
                                radius: 10.0,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Vui lòng nhập nội dung';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  eventName.text = value!;
                                },
                              ),
                              Dropdowncategories(
                                list: widget.list,
                                onCategoryChanged: (CategoryModel selected) {
                                  setState(() {
                                    _selectedCategories = selected;
                                  });
                                },
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      height: 50,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            child: Icon(
                                                Icons.calendar_month_outlined),
                                          ),
                                          Container(
                                              child: Text(_startDate == null
                                                  ? 'Select Start Date'
                                                  : '${_startDate!.toLocal()}'
                                                      .split(' ')[0]))
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border:
                                              Border.all(color: Colors.grey)),
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      height: 50,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            child: Icon(
                                                Icons.calendar_month_outlined),
                                          ),
                                          Container(
                                              child: Text(_endDate == null
                                                  ? 'Select End Date'
                                                  : '${_endDate!.toLocal()}'
                                                      .split(' ')[0])),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border:
                                              Border.all(color: Colors.grey)),
                                    ),
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              // !TIme
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                      print('start time');
                                      _presentDatePicker(isStartDate: true);
                                    },
                                    child: Container(
                                      width: 150,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      height: 50,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            child: Icon(Icons.timer_outlined),
                                          ),
                                          Container(
                                              child: Text(_startDate == null
                                                  ? 'Select Start Time'
                                                  : '${_startDate!.toLocal()}'
                                                      .split(' ')[0]))
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border:
                                              Border.all(color: Colors.grey)),
                                    ),
                                  )),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                      print('end time');
                                      _presentDatePicker(isStartDate: false);
                                    },
                                    child: Container(
                                      width: 150,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      height: 50,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            child: Icon(Icons.timer_outlined),
                                          ),
                                          Container(
                                              child: Text(_endDate == null
                                                  ? 'Select End Time'
                                                  : '${_endDate!.toLocal()}'
                                                      .split(' ')[0])),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border:
                                              Border.all(color: Colors.grey)),
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
                                onChanged: (value) => validateForm(),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Vui lòng nhập nội dung';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  description.text = value!;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Text(
                                  'Location',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFieldCustom(
                                keyboardType: TextInputType.streetAddress,
                                controller: location,
                                title: 'Location',
                                radius: 10,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                      "Bạn muốn đăng bài viết này không?",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Checkbox(
                                      value: isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked = !isChecked;
                                        });
                                      })
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      // GestureDetector(
                      //   onTap: () {
                      //     print('create Events');
                      //     uploadEvent();
                      //   },
                      //   child: Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: Container(
                      //       width: MediaQuery.of(context).size.width,
                      //       height: 60,
                      //       decoration: BoxDecoration(
                      //           color: Color(0xff171924),
                      //           borderRadius: BorderRadius.circular(20)),
                      //       child: Center(
                      //         child: Text(
                      //           'Public Now',
                      //           style: TextStyle(
                      //               color: Colors.white,
                      //               fontSize: 20,
                      //               fontWeight: FontWeight.w600),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                    //   ),
                    // ],
                  ),
                ),
              ),
            ),
            Step(
              title: Text('Next Preview'),
              isActive: _index >= 1,
              content: Container(
                // child: Text('detail'),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (fileImage != null && fileImage!.isNotEmpty)
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: fileImage!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.memory(
                                fileImage![index],
                                fit: BoxFit.fill,
                                width: 150,
                              ),
                            );
                          },
                        ),
                      ),
                    Container(
                      child: Text(
                        eventName.text,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                    ),
                    // ! Day&Time
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            isChecked ? 'Public' : 'Private',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.date_range_sharp,
                              size: 15,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "${_startDate?.day.toString()}, ${_startDate?.month.toString()}-${_startDate?.year.toString()}",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 15,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "${_startDate?.hour}:${_startDate?.minute}",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    // !Hosted By
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Hosted By",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          child: Text(
                            widget.username,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // ! Description
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            'Event Description',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          // width: 300,
                          child: Text(
                            description.text,
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ],
                    ),
                    // !Guest List phát triển sau này
                    Container(
                      child: Text(
                        'Guest List',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 24),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
