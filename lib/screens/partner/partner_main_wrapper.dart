import 'package:flutter/material.dart';
import 'partner_dashboard_screen.dart';
import 'partner_annonces_screen.dart';
import 'partner_disponibilites_screen.dart';
import 'partner_reservations_screen.dart';
import 'partner_promotions_screen.dart';
import 'partner_avis_screen.dart';
import 'partner_stats_screen.dart';
import 'partner_profile_screen.dart';

class PartnerMainWrapper extends StatefulWidget {
  const PartnerMainWrapper({super.key});

  @override
  State<PartnerMainWrapper> createState() => _PartnerMainWrapperState();
}

class _PartnerMainWrapperState extends State<PartnerMainWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    PartnerDashboardScreen(),
    PartnerAnnoncesScreen(),
    PartnerDisponibilitesScreen(),
    PartnerReservationsScreen(),
    PartnerPromotionsScreen(),
    PartnerAvisScreen(),
    PartnerStatsScreen(),
    PartnerProfileScreen(),
  ];

  final List<String> _titles = [
    "Tableau de bord",
    "Annonces",
    "Disponibilités",
    "Réservations",
    "Promotions",
    "Avis",
    "Statistiques",
    "Profil",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool get _showBack =>
      _selectedIndex != 0; // Afficher retour sauf sur dashboard

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFF6600)),
        leading: _showBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              )
            : null,
      ),
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFF6600),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.announcement), label: "Annonces"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Dispo"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Réservations"),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: "Promos"),
          BottomNavigationBarItem(icon: Icon(Icons.reviews), label: "Avis"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}