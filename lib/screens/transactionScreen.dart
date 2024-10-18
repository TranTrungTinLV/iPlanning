import 'package:flutter/material.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

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
                    title: 'Name',
                    bottom: 26,
                    radius: 10.0,
                  ),
                  TextFieldCustom(
                    title: 'Enter note',
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
                            Container(
                              child: Row(
                                children: [],
                              ),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.grey)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {},
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
