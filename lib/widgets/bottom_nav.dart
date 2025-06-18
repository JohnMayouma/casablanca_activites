import 'package:flutter/material.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/profile/profile_screen.dart'; // Assure-toi que ce chemin est correct

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<Map<String, dynamic>> likedEvents;

  const BottomNavBar({super.key, required this.currentIndex, required this.likedEvents});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Color.fromARGB(255, 244, 111, 71),
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      elevation: 10,
      showUnselectedLabels: true,
      onTap: (index) {
        if (index == 2) {
          // Aller à l'écran des favoris
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FavoritesScreen(likedEvents: likedEvents),
            ),
          );
        } else if (index == 4) {
          // Aller à l'écran de profil
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProfileScreen(),
            ),
          );
        } else {
          // Ici tu peux gérer Explore, Tickets, etc. si besoin
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          activeIcon: Icon(Icons.explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          activeIcon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.confirmation_num_outlined),
          activeIcon: Icon(Icons.confirmation_num),
          label: 'Tickets',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
