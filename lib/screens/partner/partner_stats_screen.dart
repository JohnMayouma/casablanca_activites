import 'package:flutter/material.dart';

class PartnerStatsScreen extends StatelessWidget {
  const PartnerStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Remplacer par des vrais graphes ou stats dynamiques plus tard
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Statistiques de performance",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 22),
          _statCard("Réservations/mois", "32", Icons.event, Color(0xFFFF6600)),
          _statCard("Taux de remplissage", "82%", Icons.people, Color(0xFF00C853)),
          _statCard("Note Moyenne", "4.7/5", Icons.star, Color(0xFFFFAA00)),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0.5,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(label, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        trailing: Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}