import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  MapScreen({
    super.key,
    required this.location,
  });
  TextEditingController location = TextEditingController();

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  final MapController _mapController = MapController();
  LatLng? _selectedLocation;
  LatLng? _myPosition;
  LatLng? _draggedPosition;
  bool _isSearching = false;

  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation().then((value) {
      print(value.altitude);
      print(value.longitude);
    });
    _determinePosition();
  }

  // !Get current location
  Future<Position> _getCurrentLocation() async {
    Location location = new Location();

    bool serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error("Location services are disable");
      }
    }
    geo.LocationPermission permission = await Geolocator.checkPermission();
    // _permissionGranted = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != PermissionStatus.granted) {
        // return;
      }
    }
    if (permission == geo.LocationPermission.deniedForever) {
      return Future.error("Location services are deniedForever");
    }

    return await geo.Geolocator.getCurrentPosition();
  }

  // ! current geolocator
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // Position? lastPosition = await Geolocator.getLastKnownPosition();
    LocationSettings locationSettings = await LocationSettings(
      accuracy: geo.LocationAccuracy.high,
      distanceFilter: 100,
    );
    print("Current: ${locationSettings}");
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    } catch (e) {
      print('Error: $e');
    }
    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    // LocationSettings locationSettings = const LocationSettings(accuracy: .best)
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options:
                MapOptions(initialZoom: 13.0, onTap: (tapPosition, latlng) {}),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              )
            ],
          )
        ],
      ),
    );
  }
}
