import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PartnerCreateEventScreen extends StatefulWidget {
  final Map<String, dynamic>? existingEvent;
  const PartnerCreateEventScreen({super.key, this.existingEvent});

  @override
  State<PartnerCreateEventScreen> createState() => _PartnerCreateEventScreenState();
}

class _PartnerCreateEventScreenState extends State<PartnerCreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _hourCtrl = TextEditingController();
  final _locationCtrl = TextEditingController(text: "Casablanca, Maroc");
  final _placesCtrl = TextEditingController();

  String eventType = "";
  String participationType = "Payant";
  String standardPrice = "";
  String vipPrice = "";
  String goldPrice = "";

  File? coverImage;
  File? profileImage;
  File? afficheImage;
  File? promoVideo;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.existingEvent != null) {
      final ev = widget.existingEvent!;
      _titleCtrl.text = ev['titre'] ?? ev['title'] ?? "";
      eventType = ev['type'] ?? "";
      _dateCtrl.text = ev['date'] ?? "";
      _hourCtrl.text = ev['heure'] ?? "";
      _locationCtrl.text = ev['lieu'] ?? "Casablanca, Maroc";
      _descCtrl.text = ev['description'] ?? "";
      _placesCtrl.text = (ev['places'] ?? "").toString();
      participationType = ev['participationType'] ?? "Payant";
      final tarifs = ev['tarifs'] ?? {};
      standardPrice = (tarifs['standard'] ?? "").toString();
      vipPrice = (tarifs['vip'] ?? "").toString();
      goldPrice = (tarifs['gold'] ?? "").toString();
      coverImage = ev['coverImage'];
      profileImage = ev['profileImage'];
      afficheImage = ev['afficheImage'];
      promoVideo = ev['promoVideo'];
    }
  }

  Future<void> pickImage(Function(File) setImage) async {
    final xfile = await _picker.pickImage(source: ImageSource.gallery);
    if (xfile != null) setImage(File(xfile.path));
  }

  Future<void> pickVideo(Function(File) setVideo) async {
    final xfile = await _picker.pickVideo(source: ImageSource.gallery);
    if (xfile != null) setVideo(File(xfile.path));
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    if (coverImage == null || profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Photo de profil et couverture obligatoires.")),
      );
      return;
    }
    final event = {
      "titre": _titleCtrl.text,
      "type": eventType,
      "date": _dateCtrl.text,
      "heure": _hourCtrl.text,
      "lieu": _locationCtrl.text,
      "description": _descCtrl.text,
      "places": int.tryParse(_placesCtrl.text) ?? 0,
      "participationType": participationType,
      "tarifs": {
        "standard": double.tryParse(standardPrice) ?? 0,
        "vip": double.tryParse(vipPrice) ?? 0,
        "gold": double.tryParse(goldPrice) ?? 0,
      },
      "coverImage": coverImage,
      "profileImage": profileImage,
      "afficheImage": afficheImage,
      "promoVideo": promoVideo,
    };
    Navigator.pop(context, event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingEvent == null
              ? "Créer un nouvel événement"
              : "Modifier l'événement",
          style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF6600),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Photos de couverture et profil
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text("Photo de couverture", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () => pickImage((file) => setState(() => coverImage = file)),
                          child: Container(
                            width: double.infinity,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                              image: coverImage != null
                                  ? DecorationImage(image: FileImage(coverImage!), fit: BoxFit.cover)
                                  : null,
                            ),
                            child: coverImage == null
                                ? const Icon(Icons.add_photo_alternate, size: 32, color: Colors.grey)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      const Text("Photo de profil", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => pickImage((file) => setState(() => profileImage = file)),
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
                          child: profileImage == null ? const Icon(Icons.person, size: 32, color: Colors.grey) : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Titre et type
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(labelText: "Titre de l'événement"),
                      validator: (v) => v == null || v.trim().isEmpty ? "Titre requis" : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: eventType.isNotEmpty ? eventType : null,
                      items: ["Événement", "Activité", "Restaurant"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      decoration: const InputDecoration(labelText: "Type"),
                      onChanged: (v) => setState(() => eventType = v ?? ""),
                      validator: (v) => v == null ? "Type requis" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Date, heure, lieu
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateCtrl,
                      decoration: const InputDecoration(labelText: "Date", hintText: "jj/mm/aaaa"),
                      keyboardType: TextInputType.datetime,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          _dateCtrl.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                        }
                      },
                      readOnly: true,
                      validator: (v) => v == null || v.isEmpty ? "Date requise" : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _hourCtrl,
                      decoration: const InputDecoration(labelText: "Heure", hintText: "--:--"),
                      keyboardType: TextInputType.datetime,
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          _hourCtrl.text = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                        }
                      },
                      readOnly: true,
                      validator: (v) => v == null || v.isEmpty ? "Heure requise" : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _locationCtrl,
                      decoration: const InputDecoration(labelText: "Lieu"),
                      validator: (v) => v == null || v.trim().isEmpty ? "Lieu requis" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Description
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: "Description", alignLabelWithHint: true),
                minLines: 3,
                maxLines: 5,
                validator: (v) => v == null || v.trim().isEmpty ? "Description requise" : null,
              ),
              const SizedBox(height: 12),

              // Places
              TextFormField(
                controller: _placesCtrl,
                decoration: const InputDecoration(labelText: "Nombre de places disponibles", hintText: "Ex : 100"),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.trim().isEmpty ? "Nombre de places requis" : null,
              ),
              const SizedBox(height: 12),

              // Type participation
              Row(
                children: [
                  const Text("Type de participation :", style: TextStyle(fontFamily: 'Poppins')),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Radio<String>(
                        value: "Gratuit",
                        groupValue: participationType,
                        onChanged: (v) => setState(() => participationType = v ?? "Gratuit"),
                      ),
                      const Text("Gratuit", style: TextStyle(fontFamily: 'Poppins')),
                      Radio<String>(
                        value: "Payant",
                        groupValue: participationType,
                        onChanged: (v) => setState(() => participationType = v ?? "Payant"),
                      ),
                      const Text("Payant", style: TextStyle(fontFamily: 'Poppins')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Tarifs
              if (participationType == "Payant") ...[
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tarifs", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Expanded(child: Text("Standard Pass", style: TextStyle(fontFamily: 'Poppins'))),
                          SizedBox(
                            width: 120,
                            child: TextFormField(
                              initialValue: standardPrice,
                              decoration: const InputDecoration(labelText: "Prix en MAD"),
                              keyboardType: TextInputType.number,
                              onChanged: (v) => standardPrice = v,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text("VIP Experience", style: TextStyle(fontFamily: 'Poppins'))),
                          SizedBox(
                            width: 120,
                            child: TextFormField(
                              initialValue: vipPrice,
                              decoration: const InputDecoration(labelText: "Prix en MAD"),
                              keyboardType: TextInputType.number,
                              onChanged: (v) => vipPrice = v,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text("Golden Pass", style: TextStyle(fontFamily: 'Poppins'))),
                          SizedBox(
                            width: 120,
                            child: TextFormField(
                              initialValue: goldPrice,
                              decoration: const InputDecoration(labelText: "Prix en MAD"),
                              keyboardType: TextInputType.number,
                              onChanged: (v) => goldPrice = v,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              // Affiche
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => pickImage((file) => setState(() => afficheImage = file)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6600),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Sélect. fichiers (affiche)"),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      afficheImage == null ? "Aucun fichier choisi" : afficheImage!.path.split('/').last,
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Vidéo promo
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => pickVideo((file) => setState(() => promoVideo = file)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6600),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Sélect. fichiers (vidéo)"),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      promoVideo == null ? "Aucun fichier choisi" : promoVideo!.path.split('/').last,
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              // Bouton créer/modifier
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6600),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    widget.existingEvent == null
                        ? "Créer l'évènement"
                        : "Enregistrer les modifications",
                    style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}