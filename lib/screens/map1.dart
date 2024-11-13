import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/utils/dialog.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:http/http.dart' as http;

class Map1Screen extends StatefulWidget {
  Map1Screen({super.key, required this.location});
  final String? location;

  @override
  State<Map1Screen> createState() => _Map1ScreenState();
}

class _Map1ScreenState extends State<Map1Screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.location != null && widget.location!.isNotEmpty) {
      _setLocationFromAddress(widget.location!);
    } else {
      moveCurrent();
    }
  }

  final MapController _mapController = MapController();
  LatLng? _myLocation;
  String? currentLocation;
  String? living;
  Future<LocationData?> _getCurrentLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    locationData = await location.getLocation();
    return locationData;
  }

  Future<void> getAddressFromLatLng(double? latitude, double? longitude) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${latitude}&lon=${longitude}');
    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'YourAppName/1.0 trantintin1989@gmail.com',
        },
      );
      if (response.statusCode == 200) {
        final resData = json.decode(response.body);
        final address = resData['address'];
        final road = address['road'];
        final quarter = address['quarter'];
        final suburb = address['suburb'];
        final city = address['city'];
        final country = address['country'];
        print('Tên đường: $road, Thành phố: $city, Quốc gia: $country');
        setState(() {
          living = '$road, $country';
        });
      } else {
        print('Lỗi khi lấy dữ liệu địa chỉ');
      }
    } catch (e) {
      print('Lỗi xảy ra: $e');
    }
  }

  Future<void> saveAddressFireStore() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && living != null) {
      try {
        await firestoreInstance.collection('users').doc(currentUser.uid).update(
          {
            'country': living,
          },
        );
        Navigator.pop(context, living);
      } catch (e) {}
    }
  }

  Future<void> _setLocationFromAddress(String address) async {
    try {
      List<geo.Location> myExistslocations =
          await geo.locationFromAddress(widget.location!);
      if (myExistslocations.isNotEmpty) {
        double latitude = myExistslocations.first.latitude;
        double longitude = myExistslocations.first.longitude;
        setState(() {
          _myLocation = LatLng(latitude, longitude);
        });
        _mapController.move(_myLocation!, 13.0);
      }
    } catch (e) {
      print("Không thể lấy vị trí từ địa chỉ: $e");
      moveCurrent(); // Gọi moveCurrent nếu không thể tìm thấy toạ độ từ địa chỉ
    }
  }

  void moveCurrent() async {
    print("location");
    try {
      LocationData? positionData = await _getCurrentLocation();
      if (positionData != null) {
        LatLng currentPosition =
            LatLng(positionData.latitude!, positionData.longitude!);

        await getAddressFromLatLng(
            positionData.latitude, positionData.longitude);
        _mapController.move(currentPosition, 17.0);
        setState(() {
          _myLocation = currentPosition;

          print(_myLocation);
        });

        print("Vị trí hiện tại: $_myLocation");
      } else {
        print("Không thể lấy vị trí hiện tại");
      }
    } catch (e) {
      print("Không thể lấy vị trí hiện tại");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              if (_myLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      width: screenWidth * 0.1,
                      height: screenHeight * 0.1,
                      point: _myLocation!,
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
            ],
            mapController: _mapController,
            options:
                MapOptions(initialZoom: 13.0, onTap: (tapPosition, latLng) {}),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
              ),
              width: screenWidth,
              height: screenHeight * 0.18,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (widget.location == null ||
                              widget.location!.isEmpty) {
                            bool? shouldExit =
                                await showExitConfirmationDialog(context);
                            if (shouldExit) {
                              Navigator.pop(context);
                            }
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          child: Icon(
                            Icons.arrow_circle_left_rounded,
                            size: screenWidth * 0.13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                          child: TextField(
                        style: TextStyle(fontSize: screenWidth * 0.04),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.025),
                          ),
                          filled: true,
                          fillColor: Colors.white30,
                        ),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: saveAddressFireStore,
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Color(0xff3D56F0),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            "Cập nhật",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: screenHeight * 0.05,
                horizontal: screenWidth * 0.05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  GestureDetector(
                    onTap: moveCurrent,
                    child: Container(
                      height: screenWidth * 0.12,
                      width: screenWidth * 0.12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Align(
                            child: Icon(
                              Icons.location_searching,
                              color: _myLocation != null
                                  ? Colors.black
                                  : Colors.red,
                              size: screenWidth * 0.08,
                            ),
                          ),
                          Align(
                              child: _myLocation != null
                                  ? Container(
                                      height: screenWidth * 0.03,
                                      width: screenWidth * 0.03,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle),
                                    )
                                  : Text(
                                      '?',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.w600),
                                    ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
