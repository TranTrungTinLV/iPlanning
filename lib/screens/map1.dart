import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:http/http.dart' as http;

class Map1Screen extends StatefulWidget {
  const Map1Screen({super.key});

  @override
  State<Map1Screen> createState() => _Map1ScreenState();
}

class _Map1ScreenState extends State<Map1Screen> {
  final MapController _mapController = MapController();
  LatLng? _myLocation;
  String? currentLocation;
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
      } else {
        print('Lỗi khi lấy dữ liệu địa chỉ');
      }
    } catch (e) {
      print('Lỗi xảy ra: $e');
    }
  }

  // move to current
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
          print("Tên đường $currentLocation");
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
                      height: 100,
                      width: 100,
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
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Icon(
                            Icons.arrow_circle_left_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextField(
                        style: TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white30,
                        ),
                      ))
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 50, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  GestureDetector(
                    onTap: moveCurrent,
                    child: Container(
                      height: 50,
                      width: 50,
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
                              size: 40,
                            ),
                          ),
                          Align(
                              child: _myLocation != null
                                  ? Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle),
                                    )
                                  : Text(
                                      '?',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
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
