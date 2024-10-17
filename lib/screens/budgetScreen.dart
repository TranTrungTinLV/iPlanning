import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iplanning/InformationBudgetScreen.dart';
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
  @override
  initState() {
    super.initState();
    _loadBudgets();
  }

  final _budgetService = BudgetMethod();

  List<bool> _isChecked = [];
  List<Budget> budgets = [];
  bool isLoading = true;
  final _formatterAmount = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
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
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
                  child: Column(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: ListView.builder(
                            itemCount: budgets.length,
                            itemBuilder: (context, index) {
                              final amount = budgets[index].paidAmount;
                              final formattedValue = _formatterAmount
                                  .format(amount)
                                  .replaceAll('.', ',');
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      // Checkbox(
                                      //     value: _isChecked[index],
                                      //     onChanged: (value) {
                                      //       setState(() {
                                      //         _isChecked[index] = value!;
                                      //       });
                                      //     }),
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      InformationBudgetScreen(
                                                    budgetName: budgets[index]
                                                        .budget_name,
                                                    note: budgets[index]
                                                                .note_id !=
                                                            null
                                                        ? budgets[index].note_id
                                                            as String
                                                        : "Hiện không có",
                                                    estimateAmount:
                                                        (budgets[index]
                                                                    .paidAmount
                                                                as double)
                                                            .toString(),
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                                Icons.info_outline_rounded),
                                            color: Colors.blue.withOpacity(0.8),
                                          )),

                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${budgets[index].budget_name}",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            "${formattedValue.toString()}",
                                            style: TextStyle(fontSize: 14.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Thu vào",
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                          Text(
                                            "Chi ra",
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '10,000,000',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                          Text(
                                            '10,000',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              );
                            },
                          )),
                      Container(
                        child: GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => BudgetList(
                                          event_id: widget.eventId,
                                        )));
                            if (result == true) {
                              _loadBudgets();
                            }
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
                      ),
                    ],
                  ),
                ),
    );
  }
}
