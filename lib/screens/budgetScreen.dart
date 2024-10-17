import 'package:flutter/material.dart';
import 'package:iplanning/models/events_model.dart';
import 'package:iplanning/screens/budgetList.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';

class Budgetscreen extends StatefulWidget {
  const Budgetscreen({super.key, required this.eventId});
  final String eventId;
  @override
  State<Budgetscreen> createState() => _BudgetscreenState();
}

class _BudgetscreenState extends State<Budgetscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budget',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => BudgetList(
                                event_id: widget.eventId,
                              )));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Color(0xffF0534F),
                      ),
                      Text(
                        "Add Budget",
                        style:
                            TextStyle(fontSize: 18, color: Color(0xffF0534F)),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.black12, shape: BoxShape.circle),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        'No Budget found',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        'Please add your tasks',
                        style: TextStyle(fontSize: 14),
                      )
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
