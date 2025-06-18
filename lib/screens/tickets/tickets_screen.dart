import 'package:flutter/material.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tickets = [
      {
        "event": "REMA World Tour",
        "date": "13 Juin 2025",
        "location": "Stade Mohammed V",
        "type": "VIP",
        "quantity": 2,
        "price": "1000 MAD"
      },
      {
        "event": "Jazz Night Casablanca",
        "date": "24 Juin 2025",
        "location": "Villa des Arts",
        "type": "Standard",
        "quantity": 1,
        "price": "150 MAD"
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Tickets"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false, // supprime toutes les routes précédentes
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final t = tickets[index];
          return Card(
            child: ListTile(
              title: Text(t["event"] as String),
              subtitle: Text("${t["date"]} – ${t["location"]}"),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${t["type"]} x${t["quantity"]}"),
                  Text(t["price"] as String, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
