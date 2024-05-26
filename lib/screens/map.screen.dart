import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _center =
      const LatLng(41.043053, 29.001549); // Beşiktaş, Istanbul
  final Marker _marker = Marker(
    markerId: MarkerId('center_marker'),
    position: LatLng(41.043053, 29.001549),
    infoWindow: InfoWindow(
      title: 'Merkez Nokta',
      snippet: 'Beşiktaş, İstanbul',
    ),
  );

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Merkez Nokta',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Beşiktaş, İstanbul', style: TextStyle(fontSize: 18)),
                ElevatedButton(
                  child: const Text('Kapat'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Example'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14.0,
        ),
        markers: {
          _marker.copyWith(
            onTapParam: () => _showBottomSheet(context),
          ),
        },
      ),
    );
  }
}
