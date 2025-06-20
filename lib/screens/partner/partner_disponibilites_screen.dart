import 'package:flutter/material.dart';

class PartnerDisponibilitesScreen extends StatefulWidget {
  const PartnerDisponibilitesScreen({super.key});

  @override
  State<PartnerDisponibilitesScreen> createState() => _PartnerDisponibilitesScreenState();
}

class _PartnerDisponibilitesScreenState extends State<PartnerDisponibilitesScreen> {
  List<Map<String, dynamic>> disponibilites = [];

  void _openDispoForm({Map<String, dynamic>? dispo, int? index}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => DisponibiliteFormDialog(dispo: dispo),
    );
    if (result != null) {
      setState(() {
        if (index != null) {
          disponibilites[index] = result;
        } else {
          disponibilites.add(result);
        }
      });
    }
  }

  void _deleteDispo(int idx) {
    setState(() {
      disponibilites.removeAt(idx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Gestion des disponibilités et tarifs",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _openDispoForm(),
            icon: const Icon(Icons.add),
            label: const Text("Ajouter une disponibilité"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6600),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: disponibilites.isEmpty
                ? const Center(child: Text("Aucune disponibilité", style: TextStyle(fontFamily: 'Poppins', color: Colors.grey)))
                : ListView.builder(
                    itemCount: disponibilites.length,
                    itemBuilder: (context, idx) {
                      final d = disponibilites[idx];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 1,
                        child: ListTile(
                          leading: Icon(
                            d['type'] == 'Restaurant' ? Icons.restaurant : Icons.event_available,
                            color: const Color(0xFFFF6600),
                          ),
                          title: Text('${d['titre'] ?? ""} - ${d['date'] ?? ""}'),
                          subtitle: Text('${d['places']} places • ${d['tarif']} €'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () => _openDispoForm(dispo: d, index: idx),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF6600),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text("Modifier"),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () => _deleteDispo(idx),
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
      ),
    );
  }
}

class DisponibiliteFormDialog extends StatefulWidget {
  final Map<String, dynamic>? dispo;
  const DisponibiliteFormDialog({this.dispo, super.key});

  @override
  State<DisponibiliteFormDialog> createState() => _DisponibiliteFormDialogState();
}

class _DisponibiliteFormDialogState extends State<DisponibiliteFormDialog> {
  final _formKey = GlobalKey<FormState>();
  String type = "Activité";
  String titre = "";
  String date = "";
  String places = "";
  String tarif = "";

  @override
  void initState() {
    super.initState();
    if (widget.dispo != null) {
      type = widget.dispo!['type'] ?? "Activité";
      titre = widget.dispo!['titre'] ?? "";
      date = widget.dispo!['date'] ?? "";
      places = widget.dispo!['places']?.toString() ?? "";
      tarif = widget.dispo!['tarif']?.toString() ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.dispo == null ? "Ajouter une disponibilité" : "Modifier la disponibilité"),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: type,
                items: ["Activité", "Restaurant"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => type = val ?? "Activité"),
                decoration: const InputDecoration(labelText: "Type"),
              ),
              TextFormField(
                initialValue: titre,
                decoration: const InputDecoration(labelText: "Titre"),
                validator: (val) => val == null || val.trim().isEmpty ? "Titre requis" : null,
                onSaved: (val) => titre = val ?? "",
              ),
              TextFormField(
                initialValue: date,
                decoration: const InputDecoration(labelText: "Date (ex: 12/12/2025)"),
                onSaved: (val) => date = val ?? "",
              ),
              TextFormField(
                initialValue: places,
                decoration: const InputDecoration(labelText: "Nombre de places"),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.trim().isEmpty ? "Places requis" : null,
                onSaved: (val) => places = val ?? "",
              ),
              TextFormField(
                initialValue: tarif,
                decoration: const InputDecoration(labelText: "Tarif (€)"),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.trim().isEmpty ? "Tarif requis" : null,
                onSaved: (val) => tarif = val ?? "",
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
                "type": type,
                "titre": titre,
                "date": date,
                "places": int.tryParse(places) ?? 0,
                "tarif": double.tryParse(tarif) ?? 0.0,
              });
            }
          },
          child: Text(widget.dispo == null ? "Ajouter" : "Modifier"),
        )
      ],
    );
  }
}