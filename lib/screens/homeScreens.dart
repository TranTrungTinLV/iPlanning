import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iplanning/widgets/categoriesUI.dart';

class Homescreens extends StatelessWidget {
  const Homescreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              height: 300.0,
              decoration: BoxDecoration(
                  color: Color(0xff4A43EC), // Đây là màu bạn muốn
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(40))),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                padding: EdgeInsets.only(top: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print('Dashboard');
                          },
                          child: Icon(
                            Icons.dashboard,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: 150.0,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Text(
                                'Current Location',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                'Ho Chi Minh, VN',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffF4F4FE)),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print('notification');
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration:
                                    const BoxDecoration(shape: BoxShape.circle),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100 / 2),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 30, sigmaY: 30),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black26),
                                    ),
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.notifications,
                                color: Colors.white,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            autocorrect: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: 'Search...',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Container(
                          height: 32,
                          width: 80,
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.filter_list),
                                Text(
                                  'Filter',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Đặt Positioned trong Stack, không trong Column
          Positioned(
            bottom: 0,
            top: 200,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(bottom: 500),
              // margin: EdgeInsets.only(left: 14),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20.0,
                    ),
                    CategoriesUI(
                      icons: Icons.sports,
                      titleCate: 'Sports',
                      colour: Colors.red,
                      textColour: Colors.white,
                      iconColour: Colors.white,
                    ),
                    CategoriesUI(
                      icons: Icons.sports,
                      titleCate: 'Sports',
                      colour: Colors.orange,
                      textColour: Colors.white,
                      iconColour: Colors.white,
                    ),
                    CategoriesUI(
                      icons: Icons.sports,
                      titleCate: 'Sports',
                      colour: Colors.green,
                      textColour: Colors.white,
                      iconColour: Colors.white,
                    ),
                    CategoriesUI(
                      icons: Icons.sports,
                      titleCate: 'Sports',
                      colour: Colors.blueAccent,
                      textColour: Colors.white,
                      iconColour: Colors.white,
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
