import 'package:flutter/material.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';

class GuestList extends StatelessWidget {
  const GuestList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guest List'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
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
                    title: 'Grocery',
                    labelText: 'Grocery',
                    bottom: 26,
                    radius: 10.0,
                  ),
                  TextFieldCustom(
                    title: 'Note',
                    labelText: 'Note',
                    bottom: 26,
                    radius: 10.0,
                  ),
                  TextFieldCustom(
                    title: 'Estimate Amount',
                    labelText: 'Estimate Amount',
                    radius: 10.0,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
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
