import 'package:flutter/material.dart';

class PartnerProfileScreen extends StatefulWidget {
  const PartnerProfileScreen({super.key});

  @override
  State<PartnerProfileScreen> createState() => _PartnerProfileScreenState();
}

class _PartnerProfileScreenState extends State<PartnerProfileScreen> {
  String name = "Le Marrakech";
  String description = "Organisateur & Restaurateur";
  String email = "contact@lemarrakech.com";

  void _openProfileForm() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => ProfileFormDialog(
        name: name,
        description: description,
        email: email,
      ),
    );
    if (result != null) {
      setState(() {
        name = result['name'] ?? name;
        description = result['description'] ?? description;
        email = result['email'] ?? email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: CircleAvatar(
              radius: 38,
              backgroundColor: Color(0xFFFF6600),
              child: Icon(Icons.person, color: Colors.white, size: 42),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              name,
              style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(height: 6),
          Center(child: Text(description, style: const TextStyle(fontFamily: 'Poppins', color: Colors.black54))),
          const SizedBox(height: 30),
          const Text("Email", style: TextStyle(fontFamily: 'Poppins', color: Colors.black54)),
          Text(email, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
          const SizedBox(height: 22),
          ElevatedButton.icon(
            onPressed: _openProfileForm,
            icon: const Icon(Icons.edit),
            label: const Text("Modifier le profil"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6600),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileFormDialog extends StatefulWidget {
  final String name;
  final String description;
  final String email;

  const ProfileFormDialog({
    required this.name,
    required this.description,
    required this.email,
    super.key,
  });

  @override
  State<ProfileFormDialog> createState() => _ProfileFormDialogState();
}

class _ProfileFormDialogState extends State<ProfileFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String description;
  late String email;

  @override
  void initState() {
    super.initState();
    name = widget.name;
    description = widget.description;
    email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Modifier le profil"),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: "Nom"),
                validator: (val) => val == null || val.trim().isEmpty ? "Nom requis" : null,
                onSaved: (val) => name = val ?? "",
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: "Description"),
                onSaved: (val) => description = val ?? "",
              ),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (val) =>
                  val == null || val.trim().isEmpty || !val.contains('@') ? "Email valide requis" : null,
                onSaved: (val) => email = val ?? "",
              ),
            ],
          ),
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
              _formKey.currentState?.save();
              Navigator.pop(context, {
                "name": name,
                "description": description,
                "email": email,
              });
            }
          },
          child: const Text("Enregistrer"),
        )
      ],
    );
  }
}