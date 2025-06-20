import 'package:flutter/material.dart';
import '../../widgets/category_filter.dart';
import 'package:geolocator/geolocator.dart';
import 'popular_event_page.dart'; // <-- Assure-toi que ce fichier existe et correspond à ta page d'événements populaires

class HomeContent extends StatefulWidget {
  final List<Map<String, dynamic>> events;
  final Function(int) toggleFavorite;
  final Function(Map<String, dynamic>) goToDetails;

  const HomeContent({
    super.key,
    required this.events,
    required this.toggleFavorite,
    required this.goToDetails,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // Filtres globaux
  String searchText = '';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  RangeValues? priceRange;
  String? selectedLocation;
  String? selectedType;
  String? selectedAmenity;

  // Filtre indépendant pour la section Populaires
  String popularCategory = 'Tous';

  void _onSearch(String value) {
    setState(() {
      searchText = value;
    });
  }

  void _onPopularCategorySelected(String selected) {
    setState(() {
      popularCategory = selected;
    });
  }

  // Filtrage pour Nouveautés (pas de filtre par catégorie)
  List<Map<String, dynamic>> get featuredEvents {
    final base = widget.events.take(6).toList();
    return _filterEvents(base);
  }

  // Filtrage pour Populaires (avec filtre par catégorie)
  List<Map<String, dynamic>> get popularEvents {
    final base = widget.events.length > 6
        ? widget.events.sublist(6).cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];
    return _filterEvents(base, sectionCategory: popularCategory);
  }

  List<Map<String, dynamic>> _filterEvents(List<Map<String, dynamic>> events, {String? sectionCategory}) {
    return events.where((event) {
      final matchesName = event['title']
          .toString()
          .toLowerCase()
          .contains(searchText.toLowerCase());
      final matchesCategory = sectionCategory == null || sectionCategory == 'Tous'
          ? true
          : (event['category'] != null &&
              event['category'].toString().toLowerCase() == sectionCategory.toLowerCase());
      final matchesDate = selectedDate == null ||
          (event['date'] != null &&
              DateTime.tryParse(event['date'])?.day == selectedDate?.day &&
              DateTime.tryParse(event['date'])?.month == selectedDate?.month &&
              DateTime.tryParse(event['date'])?.year == selectedDate?.year);
      final matchesTime = selectedTime == null || event['time'] == null
          ? true
          : TimeOfDay(
                  hour: int.tryParse(event['time'].split(':')[0]) ?? 0,
                  minute: int.tryParse(event['time'].split(':')[1]) ?? 0)
              .hour ==
              selectedTime?.hour;
      final matchesPrice = priceRange == null ||
          (event['priceValue'] != null &&
              event['priceValue'] >= priceRange!.start &&
              event['priceValue'] <= priceRange!.end);
      final matchesLocation = selectedLocation == null ||
          (event['location'] != null &&
              event['location']
                  .toString()
                  .toLowerCase()
                  .contains(selectedLocation!.toLowerCase()));
      final matchesType = selectedType == null ||
          (event['type'] != null &&
              event['type'].toString().toLowerCase() == selectedType!.toLowerCase());
      final matchesAmenity = selectedAmenity == null ||
          (event['amenities'] != null &&
              (event['amenities'] as List)
                  .map((a) => a.toString().toLowerCase())
                  .contains(selectedAmenity!.toLowerCase()));
      return matchesName &&
          matchesCategory &&
          matchesDate &&
          matchesTime &&
          matchesPrice &&
          matchesLocation &&
          matchesType &&
          matchesAmenity;
    }).toList();
  }

  void _openAdvancedFilter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => AdvancedFilterDialog(
        date: selectedDate,
        time: selectedTime,
        priceRange: priceRange,
        location: selectedLocation,
        type: selectedType,
        amenity: selectedAmenity,
      ),
    );
    if (result is Map) {
      setState(() {
        selectedDate = result['date'];
        selectedTime = result['time'];
        priceRange = result['priceRange'];
        selectedLocation = result['location'];
        selectedType = result['type'];
        selectedAmenity = result['amenity'];
      });
    }
  }

  Future<void> _searchByLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      selectedLocation = '${position.latitude},${position.longitude}';
    });
  }

  void _goToFeaturedAll() {
    Navigator.pushNamed(context, '/seeAll', arguments: {
      "title": "Nouveautés",
      "events": widget.events.take(6).toList(),
    });
  }

  void _goToPopularAll() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PopularEventsPage(
          events: widget.events.length > 6
              ? widget.events.sublist(6).cast<Map<String, dynamic>>()
              : <Map<String, dynamic>>[],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String fullName = "john Mayouma";
    final String location = "Casablanca, Morocco";
    final String imageUrl = "assets/images/profile.jpg";

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 20,
          title: Row(
            children: [
              CircleAvatar(radius: 22, backgroundImage: AssetImage(imageUrl)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Bonjour 👋", style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Text(fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(location, style: const TextStyle(fontSize: 13, color: Colors.black54))
                    ],
                  )
                ],
              )
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
              },
            ),
            const SizedBox(width: 20),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Découvrez votre événement idéal", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              const Text("Trouvez,réservez des activités et des expériences incroyables", style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Rechercher par nom ou emplacement...",
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.map),
                          onPressed: _searchByLocation,
                          tooltip: "Rechercher autour de moi",
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      onChanged: _onSearch,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.filter_alt, color: Colors.red),
                    tooltip: "Recherche avancée",
                    onPressed: _openAdvancedFilter,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Section Nouveautés (pas de filtre par catégorie ici)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Nouveautés", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  GestureDetector(
                    onTap: _goToFeaturedAll,
                    child: const Text("Voir tout", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 320,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredEvents.length,
                  itemBuilder: (context, index) {
                    final e = featuredEvents[index];
                    return _eventCard(e, index);
                  },
                ),
              ),
              const SizedBox(height: 28),
              // Section Populaires (filtrage par catégorie ici SEULEMENT)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Événements populaires 🔥", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  GestureDetector(
                    onTap: _goToPopularAll,
                    child: const Text("Voir tout", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CategoryFilter(
                categories: ['Tous', 'Activités', 'Événements', 'Restaurants'],
                onCategorySelected: _onPopularCategorySelected,
                selectedCategory: popularCategory,
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: popularEvents.length,
                itemBuilder: (context, index) {
                  final e = popularEvents[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _eventCard(e, index + 6),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _eventCard(Map<String, dynamic> e, int index) {
    return GestureDetector(
      onTap: () => widget.goToDetails(e),
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    e['imageUrl'],
                    height: 180,
                    width: 240,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => widget.toggleFavorite(index),
                    child: Icon(
                      e['liked']
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: e['liked'] ? Colors.red : Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e['title'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(e['date'],
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(e['price'],
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => widget.goToDetails(e),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Réserver maintenant"),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Widgets avancés pour filtres (DIALOG)
class AdvancedFilterDialog extends StatefulWidget {
  final DateTime? date;
  final TimeOfDay? time;
  final RangeValues? priceRange;
  final String? location;
  final String? type;
  final String? amenity;

  const AdvancedFilterDialog({
    super.key,
    this.date,
    this.time,
    this.priceRange,
    this.location,
    this.type,
    this.amenity,
  });

  @override
  State<AdvancedFilterDialog> createState() => _AdvancedFilterDialogState();
}

class _AdvancedFilterDialogState extends State<AdvancedFilterDialog> {
  DateTime? _date;
  TimeOfDay? _time;
  RangeValues _priceRange = const RangeValues(0, 500);
  String? _location;
  String? _type;
  String? _amenity;

  @override
  void initState() {
    super.initState();
    _date = widget.date;
    _time = widget.time;
    _priceRange = widget.priceRange ?? const RangeValues(0, 500);
    _location = widget.location;
    _type = widget.type;
    _amenity = widget.amenity;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Recherche avancée"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.date_range),
              title: Text(_date == null
                  ? "Choisir une date"
                  : "${_date!.day}/${_date!.month}/${_date!.year}"),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _date ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => _date = picked);
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(_time == null
                  ? "Choisir une heure"
                  : _time!.format(context)),
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _time ?? TimeOfDay.now(),
                );
                if (picked != null) setState(() => _time = picked);
              },
            ),
            ListTile(
              leading: const Icon(Icons.euro),
              title: Text(
                  "Prix: ${_priceRange.start.round()} - ${_priceRange.end.round()}"),
              subtitle: RangeSlider(
                values: _priceRange,
                min: 0,
                max: 1000,
                divisions: 40,
                labels: RangeLabels(
                  "${_priceRange.start.round()}",
                  "${_priceRange.end.round()}",
                ),
                onChanged: (val) => setState(() => _priceRange = val),
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                  labelText: "Emplacement", icon: Icon(Icons.location_on)),
              onChanged: (val) => _location = val,
              controller: TextEditingController(text: _location),
            ),
            TextField(
              decoration: const InputDecoration(
                  labelText: "Type d'activité / événement / cuisine",
                  icon: Icon(Icons.category)),
              onChanged: (val) => _type = val,
              controller: TextEditingController(text: _type),
            ),
            TextField(
              decoration: const InputDecoration(
                  labelText: "Commodités",
                  icon: Icon(Icons.miscellaneous_services)),
              onChanged: (val) => _amenity = val,
              controller: TextEditingController(text: _amenity),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'date': _date,
              'time': _time,
              'priceRange': _priceRange,
              'location': _location,
              'type': _type,
              'amenity': _amenity,
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Filtrer"),
        ),
      ],
    );
  }
}

// NotificationsScreen inchangé
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {
        "title": "Rappel de réservation",
        "message": "N'oubliez pas votre activité 'Escape Game' demain à 19h !",
        "time": "Il y a 2h"
      },
      {
        "title": "Nouvelle offre",
        "message": "Profitez de -20% sur les événements sportifs ce weekend.",
        "time": "Il y a 5h"
      },
      {
        "title": "Événement à proximité",
        "message": "Un nouveau concert a lieu près de chez vous ce vendredi !",
        "time": "Hier"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.red,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: notifications.length,
        itemBuilder: (context, i) => ListTile(
          leading: const Icon(Icons.notifications, color: Colors.red),
          title: Text(notifications[i]['title'] ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(notifications[i]['message'] ?? ""),
          trailing: Text(
            notifications[i]['time'] ?? "",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ),
    );
  }
}