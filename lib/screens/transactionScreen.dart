import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iplanning/services/note.dart';
import 'package:iplanning/sqlhelper/note_sqlife.dart';
import 'package:iplanning/utils/transactionType.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';

class TransactionScreen extends StatefulWidget {
  TransactionScreen({super.key, required this.budgetId});
  final String budgetId;
  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  bool isCheck = false;
  TransactionType? _transactionType;
  TextEditingController name = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController content = TextEditingController();
  TextEditingController amount = TextEditingController();
  NoteMethod _noteService = NoteMethod();

  createNodeModel() async {
    try {
      double? amountValue = double.tryParse(amount.text) ?? 0.0;
      if (amountValue == null) {
        Fluttertoast.showToast(
            msg: "Vui lòng nhập số hợp lệ cho số tiền ước tính");
        setState(() {
          // isLoading = false;
        });
        return;
      }
      String res = await _noteService.addNote(
          amount: amountValue,
          name: name.text,
          budget_id: widget.budgetId,
          content: content.text,
          transactionType: _transactionType!);
      if (res == 'success') {
        // Sử dụng popUntil để quay về HomeScreen
        Navigator.pop(context, true);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Transaction"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  TextFieldCustom(
                    controller: name,
                    title: 'Name',
                    bottom: 26,
                    radius: 10.0,
                  ),
                  TextFieldCustom(
                    controller: amount,
                    title: 'Amount',
                    bottom: 26,
                    radius: 10.0,
                  ),
                  TextFieldCustom(
                    controller: content,
                    title: 'Enter content',
                    bottom: 26,
                    radius: 10.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      onTap: () {
                        print('start date');
                      },
                      child: Container(
                        width: 150,
                        // padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                  border: Border(
                                      right: BorderSide(
                                    color: Colors.grey,
                                  ))),
                              child: Icon(Icons.calendar_month_outlined),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'DD/MM/YY',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.grey)),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                              title: Text("Icome"),
                              value: TransactionType.income,
                              groupValue: _transactionType,
                              onChanged: (TransactionType? value) {
                                setState(() {
                                  _transactionType = value;
                                });
                              }),
                        ),
                        Expanded(
                          child: RadioListTile(
                              title: Text("Expense"),
                              value: TransactionType.expense,
                              groupValue: _transactionType,
                              onChanged: (TransactionType? value) {
                                setState(() {
                                  _transactionType = value;
                                });
                              }),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  createNodeModel();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: Center(
                      child: Text(
                    'Add To Payments',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
                  decoration: BoxDecoration(
                      color: Color(0xffF0534F),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
