import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iplanning/models/note.dart';
import 'package:iplanning/screens/mainScreen/transactionScreen.dart';
import 'package:iplanning/services/note.service.dart';
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
      required this.budgetAmount,
      required this.event_ids});
  final String budgetName;
  final String budgetAmount;
  final String note;
  final double estimateAmount;
  final String budgetId;
  final String event_ids;
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
  double incomePercent = 0.0;
  double expensePercent = 0.0;
  String selectedFilter = "All";
  DateTime now = DateTime.now(); // Lấy ngày hiện tại
  List<NoteModel> filteredNotes = [];

  Future<void> _loadNoteModel() async {
    final notes = await NoteMethod().loadNoteModelwithBudget(widget.budgetId);
    setState(() {
      noteModels = notes;
      _filterNotes("All");
    });
  }

  // !Lọc dữ liệu
  void _filterNotes(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == "Today") {
        filteredNotes = noteModels.where((note) {
          final noteDate = note.createAt.toDate();
          final today = DateTime(now.year, now.month, now.day);
          final last7Days = today.subtract(Duration(days: 7));

          return noteDate.isAfter(last7Days) &&
              noteDate.isBefore(today.add(Duration(days: 1)));
        }).toList();
      } else if (filter == "Last 7 Days") {
        filteredNotes = noteModels.where((note) {
          final noteDate = note.createAt.toDate();
          final sevenDaysAgo = now.subtract(Duration(days: 7));
          final yesterday = DateTime(now.year, now.month, now.day);
          return noteDate.isAfter(sevenDaysAgo) && noteDate.isBefore(yesterday);
        }).toList();
      } else if (filter == "Last Month") {
        filteredNotes = noteModels.where((note) {
          final noteDate = note.createAt.toDate();
          final firstDayThisMonth = DateTime(now.year, now.month, 1);
          final firstDayLastMonth = DateTime(now.year, now.month - 1, 1);
          final lastDayLastMonth = DateTime(now.year, now.month, 0);

          print("Note Date: $noteDate");
          print("Start Date (First Day Last Month): $firstDayLastMonth");
          print("End Date (Last Day Last Month): $lastDayLastMonth");

          return noteDate.isAfter(firstDayLastMonth) &&
              noteDate.isBefore(lastDayLastMonth.add(Duration(days: 1)));
        }).toList();

        print(
            "Filtered Notes (Last Month): ${filteredNotes.map((note) => note.name).toList()}");
        print("Filtered Notes Length (Last Month): ${filteredNotes.length}");
      } else {
        filteredNotes = noteModels;
      }

      _total();
      if (filteredNotes.isEmpty) {
        Fluttertoast.showToast(
          msg: "Không có ghi chú nào phù hợp với bộ lọc!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.03,
        );
      }
    });
  }

  Future<double> _total() async {
    if (noteModels.isEmpty) return 0.0;
    double icome = filteredNotes
        .where((note) => note.transactionType == TransactionType.income)
        .map((note) => note.amount)
        .fold(0.0, (acc, element) => acc + element);
    print("Thu: $icome");
    double expense = filteredNotes
        .where((note) => note.transactionType == TransactionType.expense)
        .map((note) => note.amount)
        .fold(0.0, (acc, element) => acc + element);
    print("Chi: $expense");

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

    List<GaugeRange> ranges = [];
    double totalValue = _icome + _expense;
    incomePercent = cumulativeValue + (_icome / totalValue) * 100;
    expensePercent = cumulativeValue + (_expense / totalValue) * 100;
    incomePercent = 100 - expensePercent;
    ranges.add(GaugeRange(
      startValue: cumulativeValue,
      endValue: incomePercent,
      color: Color(0xff9E77ED),
      startWidth: 0.3,
      endWidth: 0.3,
      sizeUnit: GaugeSizeUnit.factor,
    ));

    // Phạm vi cho chi phí
    ranges.add(GaugeRange(
      startValue: incomePercent,
      endValue: 100,
      color: Color(0xffD6BBFB),
      startWidth: 0.3,
      endWidth: 0.3,
      sizeUnit: GaugeSizeUnit.factor,
    ));
    cumulativeValue = incomePercent;
    return ranges;
  }

  List<GaugeRange> _buildIncomeRangePointers() {
    double cumulativeValue = 0;
    List<GaugeRange> ranges = [];
    // ! Income Filter
    List<NoteModel> incomeNotes = filteredNotes
        .where((note) => note.transactionType == TransactionType.income)
        .toList();
    for (NoteModel incomeNote in incomeNotes) {
      double incomePercent = (incomeNote.amount / _icome) * 100;
      ranges.add(GaugeRange(
        startValue: cumulativeValue,
        endValue: cumulativeValue + incomePercent,
        color: Color(0xff9E77ED),
        startWidth: 0.3,
        endWidth: 0.3,
        sizeUnit: GaugeSizeUnit.factor,
      ));
      cumulativeValue += incomePercent;
    }
    return ranges;
  }

  List<GaugeRange> _buildExpenseRangePointers() {
    double cumulativeValue = 0;
    List<GaugeRange> ranges = [];
    // ! Expense Filter
    List<NoteModel> expenseNotes = filteredNotes
        .where((note) => note.transactionType == TransactionType.expense)
        .toList();
    for (NoteModel expenseNote in expenseNotes) {
      double expensePercent = (expenseNote.amount / _expense) * 100;
      ranges.add(GaugeRange(
        startValue: cumulativeValue,
        endValue: cumulativeValue + expensePercent,
        color: Color(0xffD6BBFB),
        startWidth: 0.3,
        endWidth: 0.3,
        sizeUnit: GaugeSizeUnit.factor,
      ));
      cumulativeValue += expensePercent;
    }
    return ranges;
  }

  List<GaugeAnnotation> _buildIncomeAnnotations() {
    double cumulativeValue = 0;
    List<GaugeAnnotation> annotations = [];
    List<NoteModel> incomeNotes = filteredNotes
        .where((note) => note.transactionType == TransactionType.income)
        .toList();
    double angle = (cumulativeValue + incomePercent / 2) * 3.6;

    double adjustedAngle = angle + (incomePercent < 1 ? 5 : 0);
    double positionFactor = adjustedAngle > 180 ? 0.7 : 1.2;

    for (NoteModel incomeNote in incomeNotes) {
      double incomePercent = (incomeNote.amount / _icome) * 100;

      annotations.add(GaugeAnnotation(
        widget: Text("${incomeNote.name} - ${incomePercent.toStringAsFixed(2)}",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        angle: -350 - (cumulativeValue + (incomePercent)) / 3.6 * 360,
        positionFactor:
            positionFactor, // Đặt vị trí của annotation ở bên ngoài biểu đồ
      ));
      cumulativeValue += incomePercent;
    }
    ;
    return annotations;
  }

  List<GaugeAnnotation> _buildExpenseAnnotations() {
    double cumulativeValue = 0;
    List<GaugeAnnotation> annotations = [];
    List<NoteModel> expenseNotes = filteredNotes
        .where((note) => note.transactionType == TransactionType.expense)
        .toList();
    double angle = (cumulativeValue + expensePercent / 2) * 3.6; // Tính lại góc

    double adjustedAngle = angle + (expensePercent < 1 ? 5 : 0);
    double positionFactor =
        adjustedAngle > 180 ? 0.7 : 1.2; // Điều chỉnh vị trí

    for (NoteModel expenseNotes in expenseNotes) {
      double expensePercent = (expenseNotes.amount / _expense) * 100;

      annotations.add(GaugeAnnotation(
        widget: Text(
            "${expenseNotes.name} - ${expensePercent.toStringAsFixed(2)}",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        angle: -350 - (cumulativeValue + (expensePercent)) / 3.6 * 360,
        positionFactor: positionFactor,
      ));
      cumulativeValue += expensePercent;
    }
    ;
    return annotations;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 3, vsync: this);

    _loadNoteModel().then((_) {
      _total().then((_) {
        _buildRangePointers();
        _filterNotes(selectedFilter);
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
    Tab(text: "Tổng quan"),
    Tab(
      text: "Thu",
    ),
    Tab(text: "Chi"),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Information Budget"),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            onSelected: (String value) {
              _filterNotes(value); // Áp dụng bộ lọc khi người dùng chọn
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "All",
                  child: Text("Tất cả"),
                ),
                PopupMenuItem(
                  value: "Today",
                  child: Text("Hôm nay"),
                ),
                PopupMenuItem(
                  value: "Last 7 Days",
                  child: Text("7 ngày qua"),
                ),
                PopupMenuItem(
                  value: "Last Month",
                  child: Text("1 tháng qua"),
                ),
              ];
            },
          ),
          SizedBox(
            width: 10,
          )
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Icon(Icons.arrow_back)),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.01,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tên chi phí tổng",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.048,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                widget.budgetName,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
              Text(
                "Ước tính",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.048,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "${formatterAmount.format(widget.estimateAmount).replaceAll('.', ',')}",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
              Text(
                "Thu vào ",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.048,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "${formatterAmount.format(_icome).replaceAll('.', ',')}",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
              Text(
                "Chi ra ",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.048,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "${formatterAmount.format(_expense).replaceAll('.', ',')}",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
              Text(
                "Còn lại ",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.048,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "${formatterAmount.format(totals).replaceAll('.', ',')}",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
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
                        "Balance: ${formatterAmount.format(totals).replaceAll('.', ',')}",
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
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: filteredNotes
                                            .where((note) =>
                                                note.transactionType ==
                                                TransactionType.income)
                                            .length,
                                        itemBuilder: (context, index) {
                                          final incomeNote = filteredNotes
                                              .where((note) =>
                                                  note.transactionType ==
                                                  TransactionType.income)
                                              .elementAt(index);
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 5),
                                            child: Text(
                                              formatterAmount
                                                  .format(incomeNote.amount)
                                                  .replaceAll('.', ','),
                                              style: TextStyle(
                                                  color: Colors.green),
                                              textAlign: TextAlign.left,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: filteredNotes
                                            .where((note) =>
                                                note.transactionType ==
                                                TransactionType.expense)
                                            .length,
                                        itemBuilder: (context, index) {
                                          final expenseNote = filteredNotes
                                              .where((note) =>
                                                  note.transactionType ==
                                                  TransactionType.expense)
                                              .elementAt(index);
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 5),
                                            child: Text(
                                              formatterAmount
                                                  .format(expenseNote.amount)
                                                  .replaceAll('.', ','),
                                              style:
                                                  TextStyle(color: Colors.red),
                                              textAlign: TextAlign.right,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
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
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "Giao dịch",
                        style: TextStyle(
                          fontSize: screenWidth * 0.048,
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
                                      event_ids: widget.event_ids,
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
                child: (_icome == 0 || _expense == 0)
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
                          itemCount: filteredNotes.length,
                          itemBuilder: (BuildContext context, int index) {
                            final note = filteredNotes[index];
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffFCFCFC).withOpacity(0.1),
                              ),
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
                                      Text(note.transactionType
                                          .toString()
                                          .split('.')
                                          .last),
                                    ],
                                  ),
                                  Container(
                                    child: TransactionType.income ==
                                            note.transactionType
                                        ? Text(
                                            "+${formatterAmount.format(note.amount).replaceAll('.', ',')}")
                                        : Text(
                                            "-${formatterAmount.format(note.amount).replaceAll('.', ',')}"),
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
                                  // !tổng quan
                                  child: (_icome != 0 || _expense != 0)
                                      ? Container(
                                          height: 150,
                                          margin: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: SfRadialGauge(
                                            animationDuration: 1000,
                                            enableLoadingAnimation: true,
                                            axes: [
                                              RadialAxis(
                                                annotations: <GaugeAnnotation>[
                                                  GaugeAnnotation(
                                                    widget: Text(
                                                        "${incomePercent.toStringAsFixed(2)}%"),
                                                    positionFactor: 1.5,
                                                    angle: 40,
                                                  ),
                                                  GaugeAnnotation(
                                                    widget: Text(
                                                        "${expensePercent.toStringAsFixed(2)}%"),
                                                    positionFactor: 1.5,
                                                    angle: 200,
                                                  )
                                                ],
                                                axisLineStyle: AxisLineStyle(
                                                  thickness: 35,
                                                  color: Colors.grey.shade300,
                                                ),
                                                minimum: 0,
                                                maximum: 100,
                                                showLabels: false,
                                                showTicks: false,
                                                showAxisLine: false,
                                                canScaleToFit: false,
                                                radiusFactor: 0.8,
                                                startAngle: 360,
                                                ranges: _buildRangePointers(),
                                                endAngle: 360,
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          height: 150.0,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Center(
                                              child: Text(
                                                  "Chưa có dữ liệu Tổng Quan")),
                                        ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Container(
                                    height: 300,
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: filteredNotes.length,
                                      physics: ScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 2.5,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final note = filteredNotes[index];
                                        return budgetItems(
                                          title: note.name,
                                          isCoulors: TransactionType.income ==
                                              note.transactionType,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              children: [
                                // !Icome
                                Card(
                                  child: _icome == 0.0
                                      ? Container(
                                          height: 150,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Center(
                                              child: Text(
                                                  "Chưa có dữ liệu phần thu")),
                                        )
                                      : Container(
                                          height: 150,
                                          margin: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: SfRadialGauge(
                                            animationDuration: 1000,
                                            enableLoadingAnimation: true,
                                            axes: [
                                              RadialAxis(
                                                annotations:
                                                    _buildIncomeAnnotations(),
                                                axisLineStyle: AxisLineStyle(
                                                  thickness: 35,
                                                  color: Colors.grey.shade300,
                                                ),
                                                minimum: 0,
                                                maximum: 100,
                                                showLabels: false,
                                                showTicks: false,
                                                showAxisLine: false,
                                                canScaleToFit: false,
                                                radiusFactor: 0.8,
                                                startAngle: 270,
                                                ranges:
                                                    _buildIncomeRangePointers(),
                                                endAngle:
                                                    (incomePercent / 100) * 360,
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Container(
                                    height: 300,
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: filteredNotes
                                          .where((note) =>
                                              note.transactionType ==
                                              TransactionType.income)
                                          .length,
                                      physics: ScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 2.5,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final note = filteredNotes.where(
                                            (note) =>
                                                note.transactionType ==
                                                TransactionType.income);
                                        return budgetItems(
                                          title: note.first.name,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   height: 100,
                                // ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              children: [
                                // ! Expense
                                Card(
                                  child: _expense == 0.0
                                      ? Container(
                                          height: 150,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Center(
                                            child: Text(
                                                "Chưa có dữ liệu cho phần chi"),
                                          ),
                                        )
                                      : Container(
                                          height: 150,
                                          margin: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: SfRadialGauge(
                                            animationDuration: 1000,
                                            enableLoadingAnimation: true,
                                            axes: [
                                              RadialAxis(
                                                annotations:
                                                    _buildExpenseAnnotations(),
                                                axisLineStyle: AxisLineStyle(
                                                  thickness: 35,
                                                  color: Colors.grey.shade300,
                                                ),
                                                minimum: 0,
                                                maximum: 100,
                                                showLabels: false,
                                                showTicks: false,
                                                showAxisLine: false,
                                                canScaleToFit: false,
                                                radiusFactor: 0.8,
                                                startAngle: 270,
                                                ranges:
                                                    _buildExpenseRangePointers(),
                                                endAngle:
                                                    (expensePercent / 100) *
                                                        360,
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                // !Expense
                                Center(
                                  child: Container(
                                    height: 300,
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: filteredNotes
                                          .where((note) =>
                                              note.transactionType ==
                                              TransactionType.expense)
                                          .length,
                                      physics: ScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 2.5,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final note = filteredNotes.where(
                                            (note) =>
                                                note.transactionType ==
                                                TransactionType.expense);
                                        return budgetItems(
                                          title: note.first.name,
                                          isCoulors:
                                              note.first.transactionType ==
                                                  TransactionType.expense,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
