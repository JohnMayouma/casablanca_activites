import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _casablanca = const LatLng(33.5731, -7.5898);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Événements à proximité")),
      body: GoogleMap(
        onMapCreated: (controller) => mapController = controller,
        initialCameraPosition: CameraPosition(target: _casablanca, zoom: 12),
        markers: {
          Marker(
            markerId: const MarkerId("rema"),
            position: const LatLng(33.5898, -7.6039),
            infoWindow: const InfoWindow(title: "REMA World Tour"),
          ),
          Marker(
            markerId: const MarkerId("jazz"),
            position: const LatLng(33.5784, -7.6245),
            infoWindow: const InfoWindow(title: "Jazz Night Casablanca"),
          ),
        },
      ),
    );
  }
}
