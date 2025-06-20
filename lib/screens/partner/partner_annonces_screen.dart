import 'package:flutter/material.dart';
import 'partner_create_event_screen.dart';

class PartnerAnnoncesScreen extends StatefulWidget {
  const PartnerAnnoncesScreen({super.key});

  @override
  State<PartnerAnnoncesScreen> createState() => _PartnerAnnoncesScreenState();
}

class _PartnerAnnoncesScreenState extends State<PartnerAnnoncesScreen> {
  List<Map<String, dynamic>> annonces = [];

  void _openAnnonceForm({Map<String, dynamic>? annonce, int? index}) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => PartnerCreateEventScreen(
          existingEvent: annonce,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        if (index != null) {
          annonces[index] = result;
        } else {
          annonces.add(result);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(index == null ? 'Événement créé avec succès !' : 'Événement modifié avec succès !')),
      );
    }
  }

  void _deleteAnnonce(int idx) {
    setState(() {
      annonces.removeAt(idx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Text(
            "Gestion des annonces",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Création, modification et suppression d'activités, d'événements et de restaurants.",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _openAnnonceForm(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6600),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                elevation: 1,
              ),
              icon: const Icon(Icons.add),
              label: const Text(
                "Créer",
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: annonces.isEmpty
              ? const Center(
                  child: Text(
                    "Aucune annonce",
                    style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: annonces.length,
                  itemBuilder: (context, idx) {
                    final annonce = annonces[idx];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        leading: annonce['profileImage'] != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(annonce['profileImage']),
                                radius: 22,
                              )
                            : null,
                        title: Text(
                          annonce['titre'] ?? annonce['title'] ?? '',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6600).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    annonce['type'] ?? '',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      color: Color(0xFFFF6600),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.calendar_today, size: 15, color: Colors.grey),
                                const SizedBox(width: 3),
                                Text(
                                  annonce['date'] ?? '',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            if (annonce['lieu'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 15, color: Color(0xFFFF6600)),
                                    const SizedBox(width: 3),
                                    Text(
                                      annonce['lieu'],
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _openAnnonceForm(annonce: annonce, index: idx),
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text(
                                "Modifier",
                                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6600),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(30, 36),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _deleteAnnonce(idx),
                              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 24),
                              splashRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}