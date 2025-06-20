import 'package:flutter/material.dart';

class PartnerPromotionsScreen extends StatefulWidget {
  const PartnerPromotionsScreen({super.key});

  @override
  State<PartnerPromotionsScreen> createState() => _PartnerPromotionsScreenState();
}

class _PartnerPromotionsScreenState extends State<PartnerPromotionsScreen> {
  List<Map<String, dynamic>> promos = [];

  void _openPromoForm({Map<String, dynamic>? promo, int? index}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => PromoFormDialog(promo: promo),
    );
    if (result != null) {
      setState(() {
        if (index != null) {
          promos[index] = result;
        } else {
          promos.add(result);
        }
      });
    }
  }

  void _deletePromo(int idx) {
    setState(() {
      promos.removeAt(idx);
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
            "Outils de promotion",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _openPromoForm(),
            icon: const Icon(Icons.add),
            label: const Text("Ajouter une promo"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6600),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: promos.isEmpty
                ? const Center(child: Text("Aucune promotion", style: TextStyle(fontFamily: 'Poppins', color: Colors.grey)))
                : ListView.builder(
                    itemCount: promos.length,
                    itemBuilder: (context, idx) {
                      final p = promos[idx];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        child: ListTile(
                          title: Text(
                            p['title'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                          ),
                          subtitle: Text(
                            p['type'] ?? '',
                            style: const TextStyle(fontFamily: 'Poppins'),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: (p['color'] as Color? ?? Colors.orange).withOpacity(0.13),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  p['promo'] ?? '',
                                  style: TextStyle(
                                    color: p['color'] as Color? ?? Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => _openPromoForm(promo: p, index: idx),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF6600),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Icon(Icons.edit, size: 18),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () => _deletePromo(idx),
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

class PromoFormDialog extends StatefulWidget {
  final Map<String, dynamic>? promo;
  const PromoFormDialog({this.promo, super.key});

  @override
  State<PromoFormDialog> createState() => _PromoFormDialogState();
}

class _PromoFormDialogState extends State<PromoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  String title = "";
  String type = "Activité";
  String promo = "";
  Color color = const Color(0xFFFF6600);

  @override
  void initState() {
    super.initState();
    if (widget.promo != null) {
      title = widget.promo!['title'] ?? "";
      type = widget.promo!['type'] ?? "Activité";
      promo = widget.promo!['promo'] ?? "";
      color = widget.promo!['color'] ?? const Color(0xFFFF6600);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.promo == null ? "Ajouter une promotion" : "Modifier la promotion"),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: "Titre"),
                validator: (val) => val == null || val.trim().isEmpty ? "Titre requis" : null,
                onSaved: (val) => title = val ?? "",
              ),
              DropdownButtonFormField<String>(
                value: type,
                items: ["Activité", "Restaurant"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => type = val ?? "Activité"),
                decoration: const InputDecoration(labelText: "Type"),
              ),
              TextFormField(
                initialValue: promo,
                decoration: const InputDecoration(labelText: "Libellé promo (ex: 'Promo -20%')"),
                onSaved: (val) => promo = val ?? "",
              ),
              DropdownButtonFormField<Color>(
                value: color,
                items: [
                  DropdownMenuItem(value: const Color(0xFFFF6600), child: const Text('Orange')),
                  DropdownMenuItem(value: const Color(0xFF00C853), child: const Text('Vert')),
                  DropdownMenuItem(value: const Color(0xFFCEB8FF), child: const Text('Violet')),
                  DropdownMenuItem(value: const Color(0xFFFFE59C), child: const Text('Jaune')),
                ],
                onChanged: (val) => setState(() => color = val ?? const Color(0xFFFF6600)),
                decoration: const InputDecoration(labelText: "Couleur"),
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
                "title": title,
                "type": type,
                "promo": promo,
                "color": color,
              });
            }
          },
          child: Text(widget.promo == null ? "Ajouter" : "Modifier"),
        )
      ],
    );
  }
}