import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:iplanning/services/budget.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';

class BudgetList extends StatefulWidget {
  BudgetList({super.key, required this.event_id});
  final String event_id;
  @override
  State<BudgetList> createState() => _BudgetListState();
}

class _BudgetListState extends State<BudgetList> {
  bool isOpen = false;
  bool isLoading = false;
  TextEditingController budgetName = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController estimateAmount = TextEditingController();
  createBudget() async {
    setState(() {
      isLoading = true;
    });
    try {
      double? estimateAmountValue = double.tryParse(estimateAmount.text);
      if (estimateAmountValue == null) {
        Fluttertoast.showToast(
            msg: "Vui lòng nhập số hợp lệ cho số tiền ước tính");
        setState(() {
          isLoading = false;
        });
        return;
      }
      String res = await BudgetMethod().addBudget(
          budget_name: budgetName.text,
          estimate_amount: estimateAmountValue,
          event_id: widget.event_id);
      if (res == 'success') {
        // Sử dụng popUntil để quay về HomeScreen
        Navigator.pop(context, true);
      }
    } catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'Budget details',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w600),
                    ),
                    margin: EdgeInsets.only(bottom: 20),
                  ),
                  TextFieldCustom(
                    controller: budgetName,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập tên budget';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      budgetName.text = value!;
                    },
                    title: 'Enter Name',
                    labelText: 'Enter Name',
                    bottom: 26,
                    radius: 10.0,
                  ),
                  TextFieldCustom(
                    controller: note,
                    title: 'Enter Note',
                    labelText: 'Enter Note',
                    bottom: 26,
                    radius: 10.0,
                  ),
                  TextFieldCustom(
                    controller: estimateAmount,
                    title: 'Estimate Amount',
                    labelText: 'Estimate Amount',
                    radius: 10.0,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isOpen = !isOpen;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black54)),
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Balance",
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(
                            Icons.arrow_downward,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isOpen)
                    ListView(
                      primary: true,
                      shrinkWrap: true,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          // decoration: BoxDecoration(
                          //     border: Border(
                          //   left: BorderSide(
                          //     color: Colors.black54,
                          //   ),
                          //   right: BorderSide(
                          //     color: Colors.black54,
                          //   ),
                          //   bottom: BorderSide(
                          //     color: Colors.black54,
                          //   ),
                          // )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Thu",
                                style: TextStyle(color: Colors.green),
                              ),
                              Text(
                                "Chi",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "200",
                                style: TextStyle(color: Colors.green),
                              ),
                              Text(
                                "100",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  createBudget();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: Center(
                      child: Text(
                    'Add To Budget',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
                  decoration: BoxDecoration(
                      color: Color(0xffF0534F),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
