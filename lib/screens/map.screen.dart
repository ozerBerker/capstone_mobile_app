import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_app/inner_screens/foodBowl_details_screen.dart';
import 'package:mobile_app/models/foodBowl_model.dart';
import 'package:mobile_app/providers/foodBowl_provider.dart';
import 'package:mobile_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.3,
        maxChildSize: 0.55,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: controller,
            children: [
              Image.asset(
                'assets/images/cart-icon.png',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              // ListTile(
              //   title: Text('Location ~~ Beşiktaş'),
              // ),
              // ListTile(
              //   title: Text('Bowl Level ~~ Low'),
              // ),
              // ListTile(
              //   title: Text('Container Slot ~~ 0'),
              // ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, FoodBowlDetail.routeName,
                          arguments: "6f3db20d-cba9-4c09-aea5-ead3ffdd7625");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFF914D).withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: TextWidget(
                      text: 'Donate',
                      color: Colors.white,
                      textSize: 20,
                      isTitle: true,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(41.042066, 29.008683),
                  initialZoom: 15,
                  interactiveFlags: InteractiveFlag.drag |
                      InteractiveFlag.doubleTapZoom |
                      InteractiveFlag.pinchZoom,
                ),
                children: [
                  openStreetMapTileLayer,
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(41.042066, 29.008683),
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            _showBottomSheet(context);
                          },
                          child: Icon(
                            IconlyBold.heart,
                            size: 60,
                            color: Color(0xff1C4189),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
