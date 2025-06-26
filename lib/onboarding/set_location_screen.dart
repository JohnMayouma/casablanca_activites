import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/user_profile.dart';

class SetLocationScreen extends StatefulWidget {
  final String profileImagePath;
  final String firstName;
  final String lastName;

  const SetLocationScreen({
    super.key,
    required this.profileImagePath,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<SetLocationScreen> createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  double? _latitude;
  double? _longitude;
  String _locationText = '';
  bool _isLoading = false;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Active la localisation pour continuer.")),
        );
        await Geolocator.openLocationSettings();
        if (!mounted) return;
        setState(() => _isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Permission de localisation refusée.")),
          );
          setState(() => _isLoading = false);
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      String address = '';
      if (!kIsWeb) {
        try {
          final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
          if (placemarks.isNotEmpty) {
            final p = placemarks[0];
            address = [
              p.street ?? '',
              p.subLocality ?? '',
              p.locality ?? '',
              p.subAdministrativeArea ?? '',
              p.administrativeArea ?? '',
              p.country ?? '',
            ].where((s) => s.trim().isNotEmpty).join(', ');
          }
        } catch (_) {}
      }

      if (!mounted) return;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _locationText = address.isNotEmpty
            ? address
            : "${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}";
        _isLoading = false;
      });

      _mapController.move(LatLng(position.latitude, position.longitude), 16);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de localisation : $e")),
      );
      setState(() => _isLoading = false);
    }
  }

  void _onContinue() {
    if (_latitude != null && _longitude != null && _locationText.isNotEmpty) {
      if (!mounted) return;

      final userProfile = UserProfile(
        firstName: widget.firstName,
        lastName: widget.lastName,
        location: _locationText,
        imageUrl: widget.profileImagePath,
      );

      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {'userProfile': userProfile},
      );
    }
  }

  Widget _buildProfileMarker() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 1),
            ],
          ),
        ),
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color.fromARGB(255, 255, 71, 71), width: 4),
          ),
          child: ClipOval(
            child: widget.profileImagePath.isNotEmpty
                ? (widget.profileImagePath.startsWith('assets/')
                    ? Image.asset(widget.profileImagePath, fit: BoxFit.cover)
                    : Image.file(File(widget.profileImagePath), fit: BoxFit.cover))
                : const Icon(Icons.person, size: 46, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapHeight = MediaQuery.of(context).size.height * 0.40;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        title: const Text("Définir votre emplacement"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Column(
        children: [
          Container(
            height: mapHeight,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: (_latitude != null && _longitude != null)
                ? FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: LatLng(_latitude!, _longitude!),
                      zoom: 16,
                      interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: const ['a', 'b', 'c'],
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(_latitude!, _longitude!),
                            width: 80,
                            height: 80,
                            child: _buildProfileMarker(),
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : IconButton(
                            icon: const Icon(Icons.location_searching, size: 32),
                            onPressed: _getCurrentLocation,
                          ),
                  ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${widget.firstName} ${widget.lastName}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Color.fromARGB(255, 253, 58, 58)),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        _locationText.isNotEmpty
                            ? _locationText
                            : (_isLoading ? "En cours de localisation..." : "Appuyez pour localiser"),
                        style: const TextStyle(fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_latitude != null && _longitude != null && !_isLoading) ? _onContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 243, 48, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                child: const Text("Continuer", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}