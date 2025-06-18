import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> likedEvents;
  const FavoritesScreen({super.key, required this.likedEvents});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> filteredEvents = [];
  String selectedCategory = 'All';
  String sortBy = 'Date';
  bool isGrid = false;

  @override
  void initState() {
    super.initState();
    filteredEvents = List.from(widget.likedEvents);
  }

  void filterEvents(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'All') {
        filteredEvents = List.from(widget.likedEvents);
      } else {
        filteredEvents = widget.likedEvents
            .where((e) => (e['category'] ?? '').toLowerCase() == category.toLowerCase())
            .toList();
      }
    });
  }

  void sortEvents(String criteria) {
    setState(() {
      sortBy = criteria;
      filteredEvents.sort((a, b) {
        if (criteria == 'Date') {
          return a['date'].compareTo(b['date']);
        } else {
          return a['title'].compareTo(b['title']);
        }
      });
    });
  }

  void confirmRemove(int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Remove from Favorites?", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(filteredEvents[index]['imageUrl'], width: 60, height: 60),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(filteredEvents[index]['title']),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 250, 80, 80)),
                    onPressed: () {
                      setState(() {
                        widget.likedEvents.remove(filteredEvents[index]);
                        filteredEvents.removeAt(index);
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Yes, Remove"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildEventCard(Map<String, dynamic> event, int index) {
    return GestureDetector(
      onLongPress: () => confirmRemove(index),
      onTap: () {
        Navigator.pushNamed(context, '/details', arguments: event);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(event['imageUrl'], width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(event['date'], style: const TextStyle(color: Colors.grey)),
                  Text(event['location'] ?? 'Casablanca', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
            const Icon(Icons.favorite, color: Color.fromARGB(255, 244, 83, 83)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              // Remplace le cœur par ton logo :
              Image.asset(
                "assets/icons/logo.png", // Mets le chemin de ton logo ici !
                width: 31,
                height: 31,
              ),
              const SizedBox(width: 8),
              const Text(
                'Favorites',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.tune, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(isGrid ? Icons.view_list : Icons.grid_view, color: Colors.grey),
              onPressed: () => setState(() => isGrid = !isGrid),
            ),
            const SizedBox(width: 8)
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text('Sort by', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: selectedCategory == 'All',
                    selectedColor: Colors.orange.shade100,
                    onSelected: (_) => filterEvents('All'),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Music'),
                    selected: selectedCategory == 'Music',
                    selectedColor: Colors.orange.shade100,
                    onSelected: (_) => filterEvents('Music'),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Workshop'),
                    selected: selectedCategory == 'Workshop',
                    selectedColor: Colors.orange.shade100,
                    onSelected: (_) => filterEvents('Workshop'),
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: sortBy,
                    icon: const Icon(Icons.sort),
                    underline: const SizedBox(),
                    onChanged: (String? newValue) => sortEvents(newValue!),
                    items: const [
                      DropdownMenuItem(value: 'Date', child: Text('Date')),
                      DropdownMenuItem(value: 'Title', child: Text('Title')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimationLimiter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: isGrid
                      ? GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: filteredEvents.length,
                          itemBuilder: (context, index) {
                            final event = filteredEvents[index];
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              columnCount: 2,
                              child: ScaleAnimation(
                                child: buildEventCard(event, index),
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: filteredEvents.length,
                          itemBuilder: (context, index) {
                            final event = filteredEvents[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: buildEventCard(event, index),
                              ),
                            );
                          },
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}