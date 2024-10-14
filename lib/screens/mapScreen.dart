import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart' as latlong;
// import 'package:geolocator/geolocator.dart' as geo;
// import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart'
    as google_maps_flutter;
// import 'package:location/location.dart';

// ignore: must_be_immutable
class MapScreen extends StatefulWidget {
  MapScreen({
    super.key,
    required this.location,
    required this.categories,
  });
  final String location;
  final String categories;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final flutter_map.MapController _mapController = flutter_map.MapController();
  List<google_maps_flutter.LatLng> routpoints = [];
  latlong.LatLng? pickedLocation;
  List<flutter_map.Marker> markers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCoordinatesFromLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _getCoordinatesFromLocation();
  }

  void _getCoordinatesFromLocation() async {
    final location = widget.location;
    if (location.isEmpty) {
      print("Location không hợp lệ, bỏ qua tìm kiếm.");
      return;
    }
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        double latitude = locations.first.latitude;
        double longitude = locations.first.longitude;
        print('Tọa độ: $latitude, $longitude');

        setState(() {
          routpoints = [google_maps_flutter.LatLng(latitude, longitude)];
          pickedLocation = latlong.LatLng(latitude, longitude);
          markers = [
            flutter_map.Marker(
              width: 80,
              height: 100,
              point: pickedLocation!,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Đảm bảo Column có kích thước tối thiểu cần thiết
                  children: [
                    // Nhãn "shop"
                    Container(
                      // width: 30,
                      // height: 20,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        widget.categories,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 10), // Khoảng cách 20px giữa nhãn và biểu tượng
                    // Biểu tượng màu đỏ
                    Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ],
                ),
              ),
            )
          ];

          _mapController.move(pickedLocation!, 13.0);
        });
      } else {
        print('Không tìm thấy địa điểm này.');
      }
    } catch (e) {
      print('Lỗi khi lấy tọa độ: $e');
    }
  }

  Future<void> _searchPlaces() async {
    try {
      final input = widget.location;
      print("Địa điểm: $input");
      List<Location> locations = await locationFromAddress(input);
      if (locations.isEmpty) {
        print("Không tìm thấy địa điểm.");
        return;
      }
      double latitude = locations[0].latitude;
      double longitude = locations[0].longitude;
      print("Tọa độ: $latitude, $longitude");
      final url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/$longitude,$latitude;108.277,14.0609848?steps=true&annotations=true&geometries=geojson&overview=full',
      );
      final response = await http.get(url);
      print('Response Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['routes'].isEmpty) {
          print('Không tìm thấy tuyến đường.');
          return;
        }

        // Lấy danh sách tọa độ từ phản hồi JSON
        final coordinatesList =
            data['routes'][0]['geometry']['coordinates'] as List;

        setState(() {
          routpoints = coordinatesList
              .map<google_maps_flutter.LatLng>(
                  (coord) => google_maps_flutter.LatLng(coord[1], coord[0]))
              .toList();
        });

        print("Route Points: $routpoints");
      } else {
        print('Lỗi API: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi: $e');
    }
  }

  // Future<void> _searchPlaces() async {
  //   print(widget.location);
  //   final showMaps = widget.location.text.trim();
  //   print(showMaps);
  //   if (showMaps.isEmpty) {
  //     setState(() {
  //       // widget.location.text = "";
  //       _searchResult = [];
  //     });
  //     return;
  //   }
  //   final coordinates = showMaps.split(',');
  //   if (coordinates.length != 2) return;

  //   final longitude = coordinates[0];
  //   final latitude = coordinates[1];
  //   final url =
  //       "http://router.project-osrm.org/route/v1/driving/${longitude},${latitude};108.277,14.0609848";

  //   final response = await http.get(Uri.parse(url));
  //   // print(response.body);
  //   setState(() {
  //     routpoints = [];
  //     var ruter =
  //         jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
  //     for (var point in ruter) {
  //       double lon = point[0];
  //       double lat = point[1];
  //       routpoints.add(LatLng(lat, lon));
  //     }
  //     ;
  //   });
  //   if (response.statusCode != 200) {
  //     print('Lỗi API: ${response.statusCode}');
  //     return;
  //   }
  //   print("routpoints ${routpoints}");

  //   final data = json.decode(response.body);
  //   if (data.isNotEmpty) {
  //     setState(() {
  //       _searchResult = data;
  //     });
  //   } else {
  //     setState(() {
  //       _searchResult = [];
  //     });
  //   }
  // }

  // !Get current location
  // Future<Position> _getCurrentLocation() async {
  //   Location location = new Location();
  //   print("Local");
  //   print('Location input: ${widget.location.text}');

  //   bool serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //   LocationData locationData;

  //   serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       return Future.error("Location services are disable");
  //     }
  //   }
  //   geo.LocationPermission permission = await Geolocator.checkPermission();
  //   // _permissionGranted = await location.hasPermission();
  //   if (permission == PermissionStatus.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission != PermissionStatus.granted) {
  //       // return;
  //     }
  //   }
  //   if (permission == geo.LocationPermission.deniedForever) {
  //     return Future.error("Location services are deniedForever");
  //   }
  //   await _searchPlaces();
  //   return await geo.Geolocator.getCurrentPosition();
  // }

  // ! current geolocator
  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   // Position? lastPosition = await Geolocator.getLastKnownPosition();
  //   LocationSettings locationSettings = await LocationSettings(
  //     accuracy: geo.LocationAccuracy.high,
  //     distanceFilter: 100,
  //   );
  //   print("Current: ${locationSettings}");
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       locationSettings: locationSettings,
  //     );
  //     print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  //   return await Geolocator.getCurrentPosition(
  //     locationSettings: locationSettings,
  //   );

  //   // LocationSettings locationSettings = const LocationSettings(accuracy: .best)
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: flutter_map.FlutterMap(
        mapController: _mapController,
        options: flutter_map.MapOptions(
          initialZoom: 13.0,
        ),
        children: [
          flutter_map.TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          if (pickedLocation != null) // Kiểm tra nếu có vị trí đã chọn
            flutter_map.MarkerLayer(
              markers: markers, // Thêm các marker vào bản đồ
            ),
        ],
      ),
    );
  }
}
