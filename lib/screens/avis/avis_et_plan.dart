import 'package:flutter/material.dart';

class AvisEtPlanScreen extends StatelessWidget {
  const AvisEtPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Avis & Plan")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Plan de la salle", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Image.network("https://via.placeholder.com/350x200", fit: BoxFit.cover),
          const SizedBox(height: 20),
          const Text("Avis des participants", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text("Fatima"),
            subtitle: Text("Super ambiance, j'ai adoré le concert !"),
          ),
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text("Youssef"),
            subtitle: Text("Organisation au top, bon son !"),
          ),
          const SizedBox(height: 20),
          const Text("Vidéo promotionnelle", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              "https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg", // Miniature YouTube
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
