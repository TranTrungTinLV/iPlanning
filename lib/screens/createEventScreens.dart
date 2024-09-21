import 'package:flutter/material.dart';

class CreateEventScreens extends StatefulWidget {
  const CreateEventScreens({super.key});

  @override
  State<CreateEventScreens> createState() => _CreateEventScreensState();
}

class _CreateEventScreensState extends State<CreateEventScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customizing'),
      ),
      body: Container(
        // margin: EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.all(25.0),
                  child: Text(
                    'Filter',
                    style: TextStyle(fontSize: 25),
                  )),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Filter_New_Event(),
                    Filter_New_Event(),
                    Filter_New_Event(),
                    Filter_New_Event(),
                    Filter_New_Event(),
                    Filter_New_Event(),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.all(25.0),
                      child: Text(
                        'Time & Date',
                        style: TextStyle(fontSize: 25),
                      )),
                  GestureDetector(
                    onTap: () {
                      print('calendar choosen');
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Color(0xffE6E6E6), strokeAlign: 1.0)),
                        margin: EdgeInsets.only(left: 20.0),
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'Choose from calendar',
                          style:
                              TextStyle(fontSize: 20, color: Color(0xff5669FF)),
                        )),
                  ),
                  Container(
                      margin: EdgeInsets.all(25.0),
                      child: Text(
                        'Location',
                        style: TextStyle(fontSize: 25),
                      )),
                  GestureDetector(
                    onTap: () {
                      print('choose location');
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Color(0xffE6E6E6), strokeAlign: 1.0)),
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        padding: EdgeInsets.all(15.0),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Choose location',
                          style:
                              TextStyle(fontSize: 20, color: Color(0xff5669FF)),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.all(25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            child: Text(
                          'Khoảng tiền',
                          style: TextStyle(fontSize: 25),
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              child: TextField(),
                            ),
                            Container(
                              width: 20,
                              height: 1,
                              decoration: BoxDecoration(color: Colors.black),
                              margin: EdgeInsets.symmetric(horizontal: 10),
                            ),
                            Container(
                              width: 50,
                              child: TextField(),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue),
                          width: 130,
                          child: Text('APPLY'),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Color(0xffE5E5E5), strokeAlign: 1.0)),
                          width: 130,
                          child: Text(
                            'RESET',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Filter_New_Event extends StatelessWidget {
  const Filter_New_Event({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('filter_icon');
      },
      child: Container(
        margin: EdgeInsets.only(left: 15.0),
        child: Column(
          children: [
            Container(
              width: 63,
              height: 63,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffE5E5E5), strokeAlign: 0.87),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.piano,
                size: 30,
              ),
            ),
            Text('icons')
          ],
        ),
      ),
    );
  }
}
