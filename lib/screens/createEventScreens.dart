import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:iplanning/models/categoryClass.dart';
import 'package:iplanning/screens/loading_manager.dart';
import 'package:iplanning/screens/mapScreen.dart';

import 'package:iplanning/services/cloud.dart';
import 'package:iplanning/utils/dialog.dart';

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
  Timestamp? _startDate;
  Timestamp? _endDate;
  List<Uint8List>? fileImage = [];
  TextEditingController description = TextEditingController();
  TextEditingController eventName = TextEditingController();
  TextEditingController location = TextEditingController(text: "");
  TextEditingController eventType = TextEditingController();
  CategoryModel? _selectedCategories;
  bool isLoading = false;
  int _index = 0;
  bool isChecked = false;

  final _formKey = GlobalKey<FormState>();
  bool isFormValid = false;

  // !Date time
  bool _isDateValid = true;
  bool _isTimeValid = true;
  bool _isStartDateSelected = true;
  bool _isEndDateSelected = true;
  bool _isImage = true;
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
          int hour = _startDate != null ? _startDate!.toDate().hour : 0;
          int minute = _startDate != null ? _startDate!.toDate().minute : 0;
          DateTime combinedDate = DateTime(
              pickedDate.year, pickedDate.month, pickedDate.day, hour, minute);
          _startDate = Timestamp.fromDate(combinedDate);
          _isStartDateSelected = true;
        } else {
          int hour = _endDate != null ? _endDate!.toDate().hour : 0;
          int minute = _endDate != null ? _endDate!.toDate().minute : 0;
          DateTime combinedDate = DateTime(
              pickedDate.year, pickedDate.month, pickedDate.day, hour, minute);
          _endDate = Timestamp.fromDate(combinedDate);
          _isEndDateSelected = true;
        }
        _isTimeValid = validateTimes();

        _isDateValid = validateDates();
      }
    });
  }

  bool validateTimes() {
    if (_startDate != null && _endDate != null) {
      if (_endDate!.toDate().year == _startDate!.toDate().year &&
          _endDate!.toDate().month == _startDate!.toDate().month &&
          _endDate!.toDate().day == _startDate!.toDate().day) {
        if (_endDate!.toDate().hour < _startDate!.toDate().hour ||
            (_endDate!.toDate().hour == _startDate!.toDate().hour)) {
          return false; // Giờ hoặc phút kết thúc nhỏ hơn giờ hoặc phút bắt đầu
        }
      }
    }

    return true;
  }

  bool validateDates() {
    // Kiểm tra nếu cả hai ngày đều được chọn
    if (_startDate != null && _endDate != null) {
      // Kiểm tra ngày trước
      if (_endDate!.toDate().year < _startDate!.toDate().year ||
          (_endDate!.toDate().year == _startDate!.toDate().year &&
              _endDate!.toDate().month < _startDate!.toDate().month) ||
          (_endDate!.toDate().year == _startDate!.toDate().year &&
              _endDate!.toDate().month == _startDate!.toDate().month &&
              _endDate!.toDate().day < _startDate!.toDate().day)) {
        return false; // Ngày kết thúc nhỏ hơn ngày bắt đầu
      }
    }

    return true; // Ngày hợp lệ hoặc một trong hai ngày bị null
  }

  void _presentTimerPicker({required bool isTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isTime) {
          DateTime combinedStart = DateTime(
            _startDate!.toDate().year,
            _startDate!.toDate().month,
            _startDate!.toDate().day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _startDate = Timestamp.fromDate(combinedStart);
        } else {
          DateTime combinedStart = DateTime(
            _endDate!.toDate().year,
            _endDate!.toDate().month,
            _endDate!.toDate().day,
            pickedTime.hour,
            pickedTime.minute,
          );

          _endDate = Timestamp.fromDate(combinedStart);
          _isTimeValid = validateTimes();
        }
      });
    }
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
          eventDateEnd: _endDate!,
          eventDateStart: _startDate!,
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              bool? shouldExit = await showExitConfirmationDialog(context);
              if (shouldExit != null && shouldExit) {
                Navigator.pop(context);
              }
            },
          ),
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
            if (_startDate == null) {
              setState(() {
                _isStartDateSelected = false;
              });
            }
            if (fileImage?.isEmpty ?? true) {
              setState(() {
                _isImage = false;
              });
            }
            if (_endDate == null) {
              setState(() {
                _isEndDateSelected = false;
              });
            }
            if (_formKey.currentState != null &&
                _formKey.currentState!.validate() &&
                _isDateValid &&
                _isTimeValid &&
                _startDate != null &&
                _endDate != null &&
                _isImage) {
              _formKey.currentState!.save();
              setState(() {
                _index += 1;
                isFormValid = true;
              });
            }
          },
          onStepTapped: (int index) {
            if (index <= _index) {
              setState(() {
                _index = index;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: Stack(
                    children: [
                      Container(
                          padding: EdgeInsets.all(16.0),
                          height: 90,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              'Vui lòng hoàn thành bước hiện tại trước.',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          )),
                      Positioned(
                        right: 10,
                        top: 5,
                        child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              },
                              child: Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              );
            }
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
                        onPressed: () {
                          uploadEvent();
                        },
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
                child: Form(
                  key: _formKey,
                  autovalidateMode: isFormValid
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    children: [
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
                              if (!_isImage)
                                Text(
                                  'Vui lòng thêm ảnh',
                                  style: TextStyle(color: Colors.red),
                                ),
                              SizedBox(
                                height: 10,
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
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          "Start Date",
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            print('start date');
                                            _presentDatePicker(
                                                isStartDate: true);
                                          },
                                          child: Container(
                                            width: 150,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height: 50,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  child: Icon(Icons
                                                      .calendar_month_outlined),
                                                ),
                                                Container(
                                                  child: Text(_startDate == null
                                                      ? 'Select Start Date'
                                                      : '${_startDate!.toDate().toLocal()}'
                                                          .split(' ')[0]),
                                                ),
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                    color: Colors.grey)),
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
                                          _presentDatePicker(
                                              isStartDate: false);
                                        },
                                        child: Container(
                                          width: 150,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          height: 50,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                child: Icon(Icons
                                                    .calendar_month_outlined),
                                              ),
                                              Container(
                                                  child: Text(_endDate == null
                                                      ? 'Select End Date'
                                                      : '${_endDate!.toDate().toLocal()}'
                                                          .split(' ')[0])),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                        ),
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 3,
                              ),

                              if (!_isDateValid)
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: const Text(
                                    'Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              if (!_isStartDateSelected)
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: const Text(
                                    'Vui lòng chọn ngày bắt đầu',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              if (!_isEndDateSelected)
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          "Start Time",
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          print('start time');
                                          _presentTimerPicker(isTime: true);
                                        },
                                        child: Container(
                                          width: 150,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          height: 50,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                child:
                                                    Icon(Icons.timer_outlined),
                                              ),
                                              Container(
                                                  child: Text(_startDate == null
                                                      ? 'Select Start Time'
                                                      : '${_startDate!.toDate().hour}:${_startDate!.toDate().minute}'))
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              border: Border.all(
                                                  color: Colors.grey)),
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          height: 50,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                child:
                                                    Icon(Icons.timer_outlined),
                                              ),
                                              Container(
                                                  child: Text(_endDate == null
                                                      ? 'Select End Time'
                                                      : '${_endDate!.toDate().hour}:${_endDate!.toDate().minute}')),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                        ),
                                      )),
                                    ],
                                  ),
                                  if (!_isTimeValid)
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        'Giờ kết thúc phải lớn hơn hoặc bằng giờ bắt đầu',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
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
                                onChanged: (value) => validateForm(),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Vui lòng nhập địa chỉ';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  location.text = value!;
                                },
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
                    ],
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
                              "${_startDate?.toDate().day.toString()}, ${_startDate?.toDate().month.toString()}-${_startDate?.toDate().year.toString()}",
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
                              "${_startDate?.toDate().hour}:${_startDate?.toDate().minute}",
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
                      height: 20,
                    ),
                    if (_index >= 1)
                      MapScreen(
                        location: location.text,
                        categories: _selectedCategories!.name,
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
