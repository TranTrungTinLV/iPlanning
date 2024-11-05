import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iplanning/widgets/TextCustomFeild.dart';

class Map1Screen extends StatefulWidget {
  const Map1Screen({super.key});

  @override
  State<Map1Screen> createState() => _Map1ScreenState();
}

class _Map1ScreenState extends State<Map1Screen> {
  final MapController _mapController = MapController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
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
        ],
      ),
    );
  }
}
