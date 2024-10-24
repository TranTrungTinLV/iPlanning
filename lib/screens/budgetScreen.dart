import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iplanning/models/note.dart';
import 'package:iplanning/screens/InformationBudgetScreen.dart';
import 'package:iplanning/models/Budget.dart';

import 'package:iplanning/screens/budgetList.dart';
import 'package:iplanning/services/budget.dart';
import 'package:iplanning/services/note.dart';
import 'package:iplanning/utils/transactionType.dart';

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
    _loadBudgets().then((_) {
      _loadNoteModel().then((_) {
        _total();
      });
    });
  }

  final _budgetService = BudgetMethod();

  // ignore: unused_field
  List<bool> _isChecked = [];
  Budget? budgets;
  bool isLoading = true;
  bool isChoose = false;
  double _income = 0.0;
  double _expense = 0.0;
  double totalExpense = 0.0;
  final _formatterAmount = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  List<NoteModel> noteModels = [];

  Future<void> _loadBudgets() async {
    try {
      Budget? loadedBudgets =
          await _budgetService.loadBudgetwithEvent(widget.eventId);
      setState(() {
        budgets = loadedBudgets;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading budgets: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadNoteModel() async {
    final notes =
        await NoteMethod().loadNoteModelwithBudget(budgets!.budget_id);
    setState(() {
      noteModels = notes;
    });
  }

  Future<double> _total() async {
    if (noteModels.isEmpty) return 0.0;
    double icome = noteModels
        .where((note) => note.transactionType == TransactionType.income)
        .map((note) => note.amount)
        .reduce((acc, element) => acc + element);

    double expense = noteModels
        .where((note) => note.transactionType == TransactionType.expense)
        .map((note) => note.amount)
        .reduce((acc, element) => acc + element);

    setState(() {
      _income = icome;

      _expense = expense;
    });

    return icome;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isChoose = !isChoose;
              });
            },
            child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsetsDirectional.only(end: 20),
                child: Text(
                  !isChoose ? 'Chọn' : "Huỷ",
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
        title: Text(
          'Budget',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
              child: Column(
                children: [
                  budgets == null
                      ? Center(child: Text('No Budgets found'))
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: IconButton(
                                        onPressed: () async {
                                          final result = Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  InformationBudgetScreen(
                                                budgetAmount: budgets!
                                                    .paidAmount
                                                    .toString(),
                                                budgetName:
                                                    budgets!.budget_name,
                                                note: budgets!.note_id
                                                        ?.join(", ") ??
                                                    "Hiện không có",
                                                estimateAmount: (budgets!
                                                    .paidAmount as double),
                                                budgetId: budgets!.budget_id,
                                                event_ids: budgets!.event_id!,
                                              ),
                                            ),
                                          ).then((value) {
                                            if (value == true) {
                                              _loadBudgets().then((_) {
                                                _loadNoteModel().then((_) {
                                                  _total();
                                                });
                                              });
                                              _loadNoteModel();
                                            }
                                          });
                                        },
                                        icon: Icon(!isChoose
                                            ? Icons.info_outline_rounded
                                            : Icons.check),
                                        color: Colors.blue.withOpacity(0.8),
                                      )),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${budgets!.budget_name}",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "${_formatterAmount.format(budgets!.paidAmount).replaceAll('.', ',').toString()}",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Thu vào",
                                        style: TextStyle(color: Colors.green),
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        _formatterAmount
                                            .format(_income)
                                            .replaceAll('.', ','),
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      Text(
                                        _formatterAmount
                                            .format(_expense)
                                            .replaceAll('.', ','),
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          )
                              // },
                              ),
                        ),
                  if (isChoose)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Sự kiện hiện tại sẽ được kích hoạt"),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            '"Thanh Toán"',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  if (budgets == null)
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
