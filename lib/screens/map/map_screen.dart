import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'distance_screen.dart';


// Modèle ConcertEvent
class ConcertEvent {
  final String id;
  final String name;
  final String imageUrl;
  final DateTime dateTime;
  final String location;
  final double latitude;
  final double longitude;
  final bool isFavorite;

  ConcertEvent({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.dateTime,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.isFavorite = false,
  });

  ConcertEvent copyWith({
    bool? isFavorite,
  }) {
    return ConcertEvent(
      id: id,
      name: name,
      imageUrl: imageUrl,
      dateTime: dateTime,
      location: location,
      latitude: latitude,
      longitude: longitude,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

// Header de localisation avec le bouton de distance ajouté
class LocationHeader extends StatelessWidget {
  final String cityName;
  final VoidCallback onChangePressed;
  final VoidCallback onDistancePressed;

  const LocationHeader({
    super.key,
    required this.cityName,
    required this.onChangePressed,
    required this.onDistancePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF6366F1),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location (within 10 km)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      cityName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onChangePressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Change',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onDistancePressed,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "Distance entre votre position et ce lieu",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


// Carte détail événement
class EventDetailCard extends StatelessWidget {
  final ConcertEvent? event;
  final VoidCallback? onFavoritePressed;

  const EventDetailCard({
    super.key,
    this.event,
    this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    if (event == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              event!.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: const Icon(Icons.music_note, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event!.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('EEE, MMM dd • HH:mm').format(event!.dateTime),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        event!.location,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onFavoritePressed,
            child: Icon(
              event!.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: event!.isFavorite ? Colors.red : Colors.grey,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  // Coordonnées de Casablanca, Maroc
  final LatLng _casablancaCenter = const LatLng(33.5731, -7.5898);
  ConcertEvent? _selectedEvent;
  late List<ConcertEvent> _events;

  @override
  void initState() {
    super.initState();
    // Exemple d'événements à Casablanca
    _events = [
      ConcertEvent(
        id: '1',
        name: 'Festival National de Musique 2024',
        imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=200',
        dateTime: DateTime(2024, 12, 24, 18, 0),
        location: 'Parc de la Ligue Arabe, Casablanca',
        latitude: 33.5899,
        longitude: -7.6039,
      ),
      ConcertEvent(
        id: '2',
        name: 'Jazz Night Live Experience',
        imageUrl: 'https://images.unsplash.com/photo-1511735111819-9a3f7709049c?w=200',
        dateTime: DateTime(2024, 12, 25, 20, 0),
        location: 'Boultek, Casablanca',
        latitude: 33.5731,
        longitude: -7.5898,
      ),
      ConcertEvent(
        id: '3',
        name: 'Rock Concert Experience',
        imageUrl: 'https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?w=200',
        dateTime: DateTime(2024, 12, 26, 19, 30),
        location: 'Théâtre Mohammed V, Casablanca',
        latitude: 33.5951,
        longitude: -7.6188,
      ),
      ConcertEvent(
        id: '4',
        name: 'Electronic Dance Party Night',
        imageUrl: 'https://images.unsplash.com/photo-1571266028243-d220c9c3b31f?w=200',
        dateTime: DateTime(2024, 12, 27, 22, 0),
        location: 'Ancienne Médina, Casablanca',
        latitude: 33.6000,
        longitude: -7.6200,
      ),
      ConcertEvent(
        id: '5',
        name: 'Classical Symphony Orchestra',
        imageUrl: 'https://images.unsplash.com/photo-1465847899084-d164df4dedc6?w=200',
        dateTime: DateTime(2024, 12, 28, 19, 0),
        location: 'Cathédrale Sacré-Cœur, Casablanca',
        latitude: 33.5902,
        longitude: -7.6184,
      ),
      ConcertEvent(
        id: '6',
        name: 'Hip Hop Showcase Live',
        imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=200',
        dateTime: DateTime(2024, 12, 29, 21, 0),
        location: 'Stade Mohamed V, Casablanca',
        latitude: 33.5823,
        longitude: -7.6426,
      ),
    ];
    _selectedEvent = _events.first;
  }

  /// Retourne la localisation ("Casablanca, Maroc") à partir des coordonnées du premier événement
  String _getCityNameFromCoords() {
    if (_events.isNotEmpty) {
      final first = _events.first;
      // Casablanca: 33.5 <= lat <= 33.7, -7.7 <= long <= -7.5
      if (first.latitude >= 33.5 && first.latitude <= 33.7 &&
          first.longitude >= -7.7 && first.longitude <= -7.5) {
        return "Casablanca, Maroc";
      }
    }
    // fallback générique
    return "Maroc";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LocationHeader(
            cityName: _getCityNameFromCoords(),
            onChangePressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Changer localisation')),
            ), onDistancePressed: () { if (_selectedEvent != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DistanceScreen(
          destinationLat: _selectedEvent!.latitude,
          destinationLng: _selectedEvent!.longitude,
          destinationName: _selectedEvent!.location,
        ),
      ),
    );
  }   },
          ),




          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _casablancaCenter,
                    initialZoom: 12.0, // Zoom adapté pour Casablanca
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.casablanca_activites',
                    ),
                    CircleLayer(circles: [
                      CircleMarker(
                        point: _casablancaCenter,
                        radius: 10000,
                        useRadiusInMeter: true,
                        color: const Color(0xFF6366F1).withOpacity(0.2),
                        borderColor: const Color(0xFF6366F1).withOpacity(0.5),
                        borderStrokeWidth: 2,
                      )
                    ]),
                    MarkerLayer(
                      markers: _events.map((event) {
                        return Marker(
                          point: LatLng(event.latitude, event.longitude),
                          width: 50,
                          height: 50,
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedEvent = event),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _selectedEvent?.id == event.id ? const Color(0xFF6366F1) : Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  event.imageUrl,
                                  fit: BoxFit.cover,
                                  width: 44,
                                  height: 44,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: EventDetailCard(
                    event: _selectedEvent,
                    onFavoritePressed: () {
                      if (_selectedEvent == null) return;
                      final index = _events.indexWhere((e) => e.id == _selectedEvent!.id);
                      if (index != -1) {
                        setState(() {
                          _events[index] = _events[index].copyWith(
                            isFavorite: !_events[index].isFavorite,
                          );
                          _selectedEvent = _events[index];
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}