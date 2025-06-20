import 'package:flutter/material.dart';

class PartnerDashboardScreen extends StatelessWidget {
  const PartnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Tu pourras brancher les stats et avis récents sur de vraies données plus tard
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Vue d'ensemble",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _dashboardCard(
                title: "Réservations",
                value: "32",
                icon: Icons.event,
                color: Color(0xFFFF6600),
              ),
              const SizedBox(width: 12),
              _dashboardCard(
                title: "Avis",
                value: "12",
                icon: Icons.reviews,
                color: Color(0xFF00C853),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _dashboardCard(
                title: "Taux de rempl.",
                value: "82%",
                icon: Icons.people,
                color: Color(0xFFCEB8FF),
              ),
              const SizedBox(width: 12),
              _dashboardCard(
                title: "CA (mois)",
                value: "2 350€",
                icon: Icons.euro,
                color: Color(0xFFFFE59C),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            "Derniers avis",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: 10),
          _lastAvis(
            user: "Alexandre",
            rating: 5,
            text: "Super organisation, je recommande !",
            date: "15/06/2024",
          ),
          _lastAvis(
            user: "Fatima",
            rating: 4,
            text: "Très bon accueil.",
            date: "10/06/2024",
          ),
        ],
      ),
    );
  }

  Widget _dashboardCard({required String title, required String value, required IconData icon, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.09),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lastAvis({required String user, required int rating, required String text, required String date}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0.5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFFF6600).withOpacity(0.18),
          child: Text(user[0], style: const TextStyle(color: Color(0xFFFF6600))),
        ),
        title: Row(
          children: [
            Text(
              user,
              style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            ),
            const SizedBox(width: 8),
            ...List.generate(rating, (i) => const Icon(Icons.star, size: 16, color: Color(0xFFFFAA00))),
          ],
        ),
        subtitle: Text(text, style: const TextStyle(fontFamily: 'Poppins')),
        trailing: Text(date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ),
    );
  }
}