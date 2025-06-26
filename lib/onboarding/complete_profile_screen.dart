import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfileScreen extends StatefulWidget {
  final void Function({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String gender,
    required DateTime? birthDate,
    File? profileImage,
  }) onProfileFilled;

  const CompleteProfileScreen({super.key, required this.onProfileFilled});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  File? _profileImage;
  final _formKey = GlobalKey<FormState>();

  String _firstName = '';
  String _lastName = '';
  DateTime? _birthDate;
  String _email = '';
  String _phone = '';
   String _gender = 'Masculin';


  final List<String> _genders = ['Masculin', 'Féminin', 'Autre'];

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onProfileFilled(
        firstName: _firstName,
        lastName: _lastName,
        email: _email,
        phone: _phone,
        gender: _gender,
        birthDate: _birthDate,
        profileImage: _profileImage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        title: const Text("Compléter le profil"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickProfileImage,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                      child: _profileImage == null
                          ? const Icon(Icons.person, size: 54, color: Colors.grey)
                          : null,
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.edit, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                decoration: const InputDecoration(labelText: "Prénom"),
                textCapitalization: TextCapitalization.words,
                validator: (v) => v == null || v.isEmpty ? "Entrer votre prénom" : null,
                onSaved: (v) => _firstName = v ?? '',
              ),
              const SizedBox(height: 18),
              TextFormField(
                decoration: const InputDecoration(labelText: "Nom de famille"),
                textCapitalization: TextCapitalization.words,
                validator: (v) => v == null || v.isEmpty ? "Entrer votre nom de famille" : null,
                onSaved: (v) => _lastName = v ?? '',
              ),
              const SizedBox(height: 18),
              TextFormField(
                decoration: const InputDecoration(labelText: "Date de naissance"),
                readOnly: true,
                controller: TextEditingController(
                  text: _birthDate != null
                      ? "${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}"
                      : "",
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _birthDate = picked);
                },
                validator: (v) => _birthDate == null ? "Choisissez votre date de naissance" : null,
              ),
              const SizedBox(height: 18),
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    v == null || !v.contains('@') ? "Entrer un email valide" : null,
                onSaved: (v) => _email = v!.trim(),
              ),
              const SizedBox(height: 18),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Numéro de téléphone", prefixText: "+"),
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.length < 6 ? "Entrer un numéro de téléphone valide" : null,
                onSaved: (v) => _phone = v!.trim(),
              ),
              const SizedBox(height: 18),
              DropdownButtonFormField<String>(
                value: _gender,
                items: _genders
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setState(() => _gender = v ?? "Masculin"),
                decoration: const InputDecoration(labelText: "Genre"),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 252, 62, 62),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Continuer", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}