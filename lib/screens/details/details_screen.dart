import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Map<String, dynamic> args;
  late List<Map<String, dynamic>> tickets;
  late Map<String, int> quantities;
  late List<Map<String, String>> comments;
  late Function(List<Map<String, String>>) updateComments;
  int? eventIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    tickets = List<Map<String, dynamic>>.from(args['tickets'] ?? []);
    quantities = {for (var t in tickets) t['type']: 0};

    comments = List<Map<String, String>>.from(args['comments'] ?? []);
    eventIndex = args['eventIndex'];
    updateComments = args['updateComments'] ?? (List<Map<String, String>> newComments) {};
  }

  void updateQuantity(String type, int change) {
    setState(() {
      final current = quantities[type] ?? 0;
      final newQty = current + change;
      quantities[type] = newQty < 0 ? 0 : newQty;
    });
  }

  void _addComment(String comment) {
    setState(() {
      comments.insert(0, {"user": "Vous", "text": comment});
      if (updateComments != null && eventIndex != null) {
        updateComments(comments);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title = args['title'];
    final String imageUrl = args['imageUrl'];
    final String date = args['date'];
    final String location = args['location'];
    final String description = args['description'];
    final String planImage = args['planImage'] ?? "assets/images/plan_salle.png";
    final String videoThumb = args['videoThumb'] ?? "assets/images/rema_video_thumb.jpg";

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- Partie EXISTANTE -----
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  bottom: -40,
                  left: 20,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 56),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(date),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(location),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(description, style: const TextStyle(height: 1.5)),
                  const SizedBox(height: 24),
                  const Text("Choisissez votre billet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  for (var ticket in tickets)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ticket['type'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(location, style: const TextStyle(color: Colors.grey)),
                                const SizedBox(height: 2),
                                Text(date, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                onPressed: () => updateQuantity(ticket['type'], -1),
                              ),
                              Text('${quantities[ticket['type']]}', style: const TextStyle(fontSize: 16)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                onPressed: () => updateQuantity(ticket['type'], 1),
                              ),
                            ],
                          ),
                          Text("${ticket['price']} MAD", style: const TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        final selectedTickets = tickets
                            .where((t) => quantities[t['type']]! > 0)
                            .map((t) => {
                                  "type": t['type'],
                                  "price": t['price'],
                                  "quantity": quantities[t['type']],
                                })
                            .toList();

                        Navigator.pushNamed(
                          context,
                          '/book_event',
                          arguments: {
                            'title': title,
                            'selectedTickets': selectedTickets,
                            'imageUrl': imageUrl,
                            'date': date,
                            'location': location,
                            'description': description,
                          },
                        );
                      },
                      child: const Text("Acheter", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  // ----- NOUVELLES SECTIONS -----
                  const SizedBox(height: 32),
                  // PLAN & LOCALISATION
                  const Text("Plan de la salle et Localisation", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            image: DecorationImage(
                              image: AssetImage(planImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.grey[200],
                          ),
                          child: const Center(child: Icon(Icons.map, size: 40, color: Colors.red)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // AVIS UTILISATEURS
                  const Text("Votre avis ...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ListView.builder(
                    itemCount: comments.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, idx) {
                      final c = comments[idx];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Colors.red[100],
                          child: Text(c['user']![0], style: const TextStyle(color: Colors.red)),
                        ),
                        title: Text(c['user']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(c['text']!),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  // Bouton d'ajout d'avis
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.chat, color: Colors.red),
                      label: const Text("Écrire un avis", style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        final result = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            String commentText = '';
                            return AlertDialog(
                              title: const Text("Votre avis"),
                              content: TextField(
                                autofocus: true,
                                decoration: const InputDecoration(hintText: "Votre commentaire..."),
                                onChanged: (val) => commentText = val,
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, commentText),
                                  child: const Text("Envoyer"),
                                ),
                              ],
                            );
                          },
                        );
                        if (result != null && result.trim().isNotEmpty) {
                          _addComment(result);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black,
                      image: DecorationImage(
                        image: AssetImage(videoThumb),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.black.withOpacity(0.6),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_circle, color: Colors.white, size: 32),
                            SizedBox(width: 10),
                            Text("Vidéo promotionnelle", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}