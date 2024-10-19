import 'package:flutter/material.dart';
import 'package:iplanning/models/Budget.dart';
import 'package:iplanning/models/note.dart';
import 'package:iplanning/screens/transactionScreen.dart';
import 'package:iplanning/services/note.dart';
import 'package:iplanning/sqlhelper/note_sqlife.dart';
import 'package:iplanning/utils/transactionType.dart';
import 'package:iplanning/widgets/budgetItems.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:intl/intl.dart';

class InformationBudgetScreen extends StatefulWidget {
  const InformationBudgetScreen(
      {super.key,
      required this.budgetName,
      required this.note,
      required this.estimateAmount,
      required this.budgetId,
      required this.budgetAmount});
  final String budgetName;
  final String budgetAmount;
  final String note;
  final double estimateAmount;
  final String budgetId;
  @override
  State<InformationBudgetScreen> createState() =>
      _InformationBudgetScreenState();
}

class _InformationBudgetScreenState extends State<InformationBudgetScreen>
    with SingleTickerProviderStateMixin {
  bool isOpen = true;
  bool isCheck = false;
  List<NoteModel> noteModels = [];
  double _icome = 0.0;
  double _expense = 0.0;
  late final TabController _tabController;
  double totals = 0.0;
  final formatterAmount = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  Future<void> _loadNoteModel() async {
    final notes = await NoteMethod().loadNoteModelwithBudget(widget.budgetId);

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
    double total = (widget.estimateAmount + icome) - expense;
    setState(() {
      _icome = icome;

      _expense = expense;
      totals = total;
    });
    return icome;
  }

  // ! data Structure chart
  List<GaugeRange> _buildRangePointers() {
    double cumulativeValue = 0;
    double totalValue = _icome + _expense;
    // Tổng giá trị của tất cả chi phí
    List<GaugeRange> ranges = [];
    double incomePercent = (_icome / totalValue) * 100;
    double expensePercent = (_expense / totalValue) * 100;
    ranges.add(GaugeRange(
      startValue: expensePercent,
      endValue: incomePercent,
      color: Colors.green,
      startWidth: 0.3,
      endWidth: 0.3,
      sizeUnit: GaugeSizeUnit.factor,
    ));

    // Phạm vi cho chi phí
    ranges.add(GaugeRange(
      startValue: incomePercent,
      endValue: 100,
      color: Colors.red,
      startWidth: 0.3,
      endWidth: 0.3,
      sizeUnit: GaugeSizeUnit.factor,
    ));

    return ranges;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _loadNoteModel().then((_) {
      _total().then((_) {
        _buildRangePointers();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  final List<Tab> tabs = [
    Tab(text: "Thu"),
    Tab(text: "Chi"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Information Budget"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Budget Name",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
              ),
              Text(
                widget.budgetName,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Note ",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
              ),
              Text(
                widget.budgetId,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Estimate Amount ",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
              ),
              Text(
                "${formatterAmount.format(widget.estimateAmount).replaceAll('.', ',')}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Icome ",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
              ),
              Text(
                "${formatterAmount.format(_icome).replaceAll('.', ',')}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Expense ",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
              ),
              Text(
                "${formatterAmount.format(_expense).replaceAll('.', ',')}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Remaining ",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
              ),
              Text(
                "${formatterAmount.format(totals).replaceAll('.', ',')}",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 50,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Balance: ${formatterAmount.format(widget.estimateAmount).replaceAll('.', ',')}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(
                        !isOpen ? Icons.arrow_downward : Icons.arrow_upward,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (isOpen)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
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
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          primary: true,
                          shrinkWrap: true,
                          itemCount: noteModels.length,
                          itemBuilder: (context, index) {
                            final noteDoc = noteModels[index];

                            return Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        noteDoc.transactionType ==
                                                TransactionType.income
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.end,
                                    children: [
                                      noteDoc.transactionType ==
                                              TransactionType.income
                                          ? Text(
                                              formatterAmount
                                                  .format(noteDoc.amount)
                                                  .replaceAll('.', ','),
                                              style: TextStyle(
                                                  color: Colors.green),
                                            )
                                          : Text(
                                              formatterAmount
                                                  .format(noteDoc.amount)
                                                  .replaceAll('.', ','),
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              Container(
                // margin: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "Payments",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => TransactionScreen(
                                      budgetId: widget.budgetId,
                                    )));
                        if (result == true) {
                          _loadNoteModel().then((_) {
                            _total();
                          });
                        }
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            weight: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 140,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0)),
                child: !isOpen
                    ? Center(
                        child: Text(
                        "No payment not found",
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w300),
                      ))
                    : Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 13, horizontal: 11),
                        child: ListView.builder(
                          itemCount: noteModels.length,
                          itemBuilder: (BuildContext context, int index) {
                            final note = noteModels[index];
                            return Container(
                              padding: EdgeInsets.only(
                                  right: 10, left: 10, bottom: 10),
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        note.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(note.transactionType.toString()),
                                    ],
                                  ),
                                  Container(
                                    child: Text(
                                        "${formatterAmount.format(note.amount).replaceAll('.', ',')}"),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: tabs,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Card(
                                  child: Container(
                                    height: 150,
                                    margin: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: SfRadialGauge(
                                      axes: [
                                        RadialAxis(
                                          pointers: [
                                            RangePointer(
                                              value: 65,
                                              width: 20,
                                              cornerStyle:
                                                  CornerStyle.bothCurve,
                                              // gradient: SweepGradient(

                                              //   stops: [0.1, 0.75, 0.4],
                                              // ),
                                            ),
                                          ],
                                          axisLineStyle: AxisLineStyle(
                                            thickness: 35,
                                            color: Colors.grey.shade300,
                                          ),
                                          startAngle: 360,
                                          endAngle: 360,
                                          maximum: 100,
                                          minimum: 0,
                                          ranges: _buildRangePointers(),
                                          showLabels: false,
                                          showTicks: false,
                                          showAxisLine: false,
                                          canScaleToFit: true,
                                          radiusFactor: 0.8,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: 300,
                                    child: GridView.count(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2.5,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      children: [
                                        budgetItems(),
                                        budgetItems(),
                                        budgetItems(),
                                        budgetItems(),
                                        budgetItems(),
                                        budgetItems(),
                                        budgetItems(),
                                        budgetItems(),
                                        budgetItems(),
                                        budgetItems(),
                                        budgetItems(),
                                        budgetItems(),
                                        budgetItems(),
                                        budgetItems(),
                                        budgetItems(),
                                        budgetItems(),
                                        budgetItems(),
                                        budgetItems(),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                ),
                                Text("Hello")
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(bottom: 350),
                              child: Card(
                                child: Container(
                                  height: 150,
                                  margin: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: SfRadialGauge(
                                    axes: [
                                      RadialAxis(
                                        pointers: [
                                          RangePointer(
                                            value: 65,
                                            width: 20,
                                            cornerStyle: CornerStyle.bothCurve,
                                            gradient: SweepGradient(
                                              colors: [
                                                Colors.orange.shade500,
                                                Colors.orange.shade200,
                                                Colors.orange.shade400,
                                              ],
                                              stops: [0.1, 0.75, 0.4],
                                            ),
                                          ),
                                        ],
                                        axisLineStyle: AxisLineStyle(
                                            thickness: 35,
                                            color: Colors.grey.shade300),
                                        startAngle: 5,
                                        endAngle: 5,
                                        showLabels: false,
                                        showTicks: false,
                                        showLastLabel: false,
                                        showAxisLine: false,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
