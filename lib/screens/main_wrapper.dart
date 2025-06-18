import 'package:flutter/material.dart';
import '../screens/home/home_content.dart';
import '../screens/map/map_screen.dart';
import '../screens/tickets/tickets_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/favorites/favorites_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int currentIndex = 0;

  List<Map<String, dynamic>> events = [
    {
      "title": "REMA World Tour",
      "category": "Music",
      "date": "13 Juin 2025 à 21h00",
      "price": "From 200 MAD",
      "imageUrl": "assets/images/rema.jpg",
      "liked": false,
      "location": "Stade Mohammed V, Casablanca",
      "description":
          "Join REMA on his World Tour stop in Casablanca for an unforgettable night of afrobeat music and electrifying energy.",
      "tickets": [
        {"type": "Standard", "price": 200},
        {"type": "VIP", "price": 500},
        {"type": "VVIP", "price": 1000},
      ],
    },
    {
      "title": "Jazz Night Casablanca",
      "category": "Concert",
      "date": "20 Août 2025 à 19h30",
      "price": "120 MAD",
      "imageUrl": "assets/images/jazz.jpg",
      "liked": false,
      "location": "Théâtre Mohammed VI",
      "description": "Soirée de jazz avec artistes locaux et internationaux.",
      "tickets": [],
    },
    {
      "title": "Atelier Cuisine Marocaine",
      "category": "Workshop",
      "date": "5 Juillet 2025 à 15h00",
      "price": "80 MAD",
      "imageUrl": "assets/images/cuisine.jpeg",
      "liked": false,
      "location": "Centre Culturel L’Uzine",
      "description": "Atelier pour découvrir les secrets de la cuisine traditionnelle.",
      "tickets": [],
    }
  ];

  void toggleFavorite(int index) {
    setState(() {
      events[index]['liked'] = !events[index]['liked'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final likedEvents = events.where((e) => e['liked'] == true).toList();

    final List<Widget> pages = [
      HomeContent(
        events: events,
        toggleFavorite: toggleFavorite,
        goToDetails: (e) {
          Navigator.pushNamed(context, '/details', arguments: e);
        },
      ),
      const MapScreen(),
      FavoritesScreen(likedEvents: likedEvents),
      const TicketsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromARGB(255, 244, 111, 71),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_num), label: "Tickets"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
