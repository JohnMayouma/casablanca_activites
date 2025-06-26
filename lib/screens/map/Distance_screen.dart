import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class DistanceScreen extends StatefulWidget {
  final double destinationLat;
  final double destinationLng;
  final String destinationName;

  const DistanceScreen({
    super.key,
    required this.destinationLat,
    required this.destinationLng,
    required this.destinationName,
  });

  @override
  State<DistanceScreen> createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  LatLng? _currentLocation;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    final hasPermission = await Geolocator.requestPermission();
    if (hasPermission == LocationPermission.denied ||
        hasPermission == LocationPermission.deniedForever) {
      setState(() => _loading = false);
      return;
    }
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _loading = false;
    });
  }

  double _calculateDistance(LatLng from, LatLng to) {
    final Distance distance = const Distance();
    return distance.as(LengthUnit.Kilometer, from, to);
  }

  @override
  Widget build(BuildContext context) {
    final destination = LatLng(widget.destinationLat, widget.destinationLng);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Itinéraire vers l'événement"),
        backgroundColor: Colors.redAccent,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _currentLocation == null
              ? const Center(child: Text("Impossible de localiser l'utilisateur."))
              : Column(
                  children: [
                    Expanded(
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: _currentLocation!,
                          initialZoom: 13,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.casablanca_activites',
                          ),
                          MarkerLayer(markers: [
                            Marker(
                              point: _currentLocation!,
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.person_pin_circle,
                                  color: Colors.blue, size: 40),
                            ),
                            Marker(
                              point: destination,
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_on,
                                  color: Colors.red, size: 40),
                            )
                          ]),
                          PolylineLayer(polylines: [
                            Polyline(
                              points: [_currentLocation!, destination],
                              color: Colors.purple,
                              strokeWidth: 5,
                            )
                          ])
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Destination : ${widget.destinationName}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(
                            "Distance estimée : ${_calculateDistance(_currentLocation!, destination).toStringAsFixed(2)} km",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
    );
  }
}
