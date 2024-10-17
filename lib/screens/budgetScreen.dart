import 'package:flutter/material.dart';
import 'package:iplanning/models/Budget.dart';
import 'package:iplanning/models/events_model.dart';
import 'package:iplanning/screens/budgetList.dart';
import 'package:iplanning/services/budget.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';

class Budgetscreen extends StatefulWidget {
  const Budgetscreen({super.key, required this.eventId});
  final String eventId;
  @override
  State<Budgetscreen> createState() => _BudgetscreenState();
}

class _BudgetscreenState extends State<Budgetscreen> {
  initState() {
    super.initState();
    _loadBudgets();
  }

  final _budgetService = BudgetMethod();

  List<bool> _isChecked = [];
  List<Budget> budgets = [];
  bool isLoading = true;
  Future<void> _loadBudgets() async {
    try {
      List<Budget> loadedBudgets =
          await _budgetService.loadBudgetwithEvent(widget.eventId);
      setState(() {
        budgets = loadedBudgets;
        _isChecked = List<bool>.filled(loadedBudgets.length, false);
        isLoading = false;
      });
    } catch (e) {
      print("Error loading budgets: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : budgets.isEmpty
              ? Center(child: Text('No Budgets found'))
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
                  child: Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                        itemCount: budgets.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 22),
                            child: Row(
                              children: [
                                Checkbox(
                                    value: _isChecked[index],
                                    onChanged: (value) {
                                      setState(() {
                                        _isChecked[index] = value!;
                                      });
                                    }),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${budgets[index].budget_name}"),
                                    Text("${budgets[index].paidAmount}"),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      )),
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
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xffF0534F)),
                              ),
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
