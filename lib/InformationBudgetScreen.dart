import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class InformationBudgetScreen extends StatefulWidget {
  const InformationBudgetScreen(
      {super.key,
      required this.budgetName,
      required this.note,
      required this.estimateAmount});
  final String budgetName;
  final String note;
  final String estimateAmount;

  @override
  State<InformationBudgetScreen> createState() =>
      _InformationBudgetScreenState();
}

class _InformationBudgetScreenState extends State<InformationBudgetScreen>
    with SingleTickerProviderStateMixin {
  bool isOpen = true;
  late final TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                widget.note,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Estimate Amount ",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
              ),
              Text(
                widget.estimateAmount,
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
              SizedBox(
                height: 10,
              ),
              if (isOpen)
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5)),
                  child: ListView(
                    primary: true,
                    shrinkWrap: true,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                ),
              SizedBox(
                height: 20,
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
                    Container(
                      // color: Color(0xffE7EBEE),
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          Container(
                              child: SingleChildScrollView(
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
                                              gradient: SweepGradient(
                                                colors: [
                                                  Colors.blue.shade500,
                                                  Colors.blue.shade200,
                                                  Colors.blue.shade400,
                                                ],
                                                stops: [0.1, 0.75, 0.4],
                                              ),
                                            ),
                                          ],
                                          axisLineStyle: AxisLineStyle(
                                            thickness: 35,
                                            color: Colors.grey.shade300,
                                          ),
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
                                ),
                                Center(
                                  child: Container(
                                    child: GridView.count(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2.5,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      physics: NeverScrollableScrollPhysics(),
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
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
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

class budgetItems extends StatelessWidget {
  const budgetItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            child: Icon(Icons.place),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Food&Drink',
                style: TextStyle(fontSize: 14.0),
              ),
              Text(
                '1tr2',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )
            ],
          )
        ],
      ),
    );
  }
}
