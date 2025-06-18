import 'package:flutter/material.dart';
import '../../../widgets/category_filter.dart';

class PopularEventsPage extends StatefulWidget {
  final List<Map<String, dynamic>> events;

  const PopularEventsPage({super.key, required this.events});

  @override
  State<PopularEventsPage> createState() => _PopularEventsPageState();
}

class _PopularEventsPageState extends State<PopularEventsPage> {
  String selectedCategory = 'Tous';

  List<Map<String, dynamic>> get filteredEvents {
    if (selectedCategory == 'Tous') return widget.events;
    return widget.events
        .where((e) =>
            e['category'] != null &&
            e['category'].toString().toLowerCase() ==
                selectedCategory.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['Tous', 'Musique', 'Atelier', 'Restaurants', 'Nightlife'];
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Événements populaires 🔥",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Action recherche
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: CategoryFilter(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (cat) {
                setState(() => selectedCategory = cat);
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: filteredEvents.isEmpty
                  ? const Center(child: Text("Aucun événement trouvé."))
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final e = filteredEvents[index];
                        return PopularEventGridCard(event: e);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class PopularEventGridCard extends StatelessWidget {
  final Map<String, dynamic> event;
  const PopularEventGridCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.asset(
                  event['imageUrl'],
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                if ((event['isFree'] ?? false) || (event['price'] == "FREE"))
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text("FREE",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11)),
                    ),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'] ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  event['date'] ?? "",
                  style: const TextStyle(
                      color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue, size: 15),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        event['location'] ?? "",
                        style: const TextStyle(color: Colors.black54, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(
                      (event['liked'] ?? false)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: (event['liked'] ?? false) ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      // Tu peux ajouter ici une callback pour "like" si tu veux.
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