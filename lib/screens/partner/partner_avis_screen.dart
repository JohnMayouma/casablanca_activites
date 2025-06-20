import 'package:flutter/material.dart';

class PartnerAvisScreen extends StatefulWidget {
  const PartnerAvisScreen({super.key});

  @override
  State<PartnerAvisScreen> createState() => _PartnerAvisScreenState();
}

class _PartnerAvisScreenState extends State<PartnerAvisScreen> {
  List<Map<String, dynamic>> avis = [
    // Tu peux commencer avec une liste vide si tu veux tout dynamique
  ];

  void _replyToAvis(int idx) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => ReplyFormDialog(),
    );
    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        avis[idx]['reply'] = result.trim();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: avis.isEmpty
          ? const Center(child: Text("Aucun avis pour le moment.", style: TextStyle(fontFamily: 'Poppins', color: Colors.grey)))
          : ListView.builder(
        itemCount: avis.length,
        itemBuilder: (context, idx) {
          final a = avis[idx];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                          child: Text((a['user'] as String)[0]),
                          backgroundColor: const Color(0xFFFF6600).withOpacity(0.18)),
                      const SizedBox(width: 10),
                      Text(
                        a['user'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: List.generate(
                          a['rating'] as int,
                          (i) => const Icon(Icons.star, size: 15, color: Color(0xFFFFAA00)),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        a['date'] as String,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(a['text'] as String, style: const TextStyle(fontFamily: 'Poppins')),
                  if (a['reply'] != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.reply, size: 15, color: Color(0xFFFF6600)),
                        const SizedBox(width: 6),
                        Text(
                          a['reply'] as String,
                          style: const TextStyle(fontFamily: 'Poppins', color: Color(0xFFFF6600)),
                        ),
                      ],
                    ),
                  ],
                  if (a['reply'] == null) ...[
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => _replyToAvis(idx),
                      icon: const Icon(Icons.reply, size: 16),
                      label: const Text(
                        "Répondre",
                        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6600),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ReplyFormDialog extends StatefulWidget {
  const ReplyFormDialog({super.key});

  @override
  State<ReplyFormDialog> createState() => _ReplyFormDialogState();
}

class _ReplyFormDialogState extends State<ReplyFormDialog> {
  final _formKey = GlobalKey<FormState>();
  String reply = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Répondre à l'avis"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: const InputDecoration(labelText: "Votre réponse"),
          onChanged: (val) => reply = val,
          validator: (val) => val == null || val.trim().isEmpty ? "Réponse requise" : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.pop(context, reply);
            }
          },
          child: const Text("Envoyer"),
        )
      ],
    );
  }
}