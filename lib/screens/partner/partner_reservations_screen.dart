import 'package:flutter/material.dart';

class PartnerReservationsScreen extends StatefulWidget {
  const PartnerReservationsScreen({super.key});

  @override
  State<PartnerReservationsScreen> createState() => _PartnerReservationsScreenState();
}

class _PartnerReservationsScreenState extends State<PartnerReservationsScreen> {
  List<Map<String, dynamic>> reservations = [];

  int selectedFilter = 0;
  final filterOptions = ['Tous', 'En attente', 'Confirmé', 'Annulé'];

  void _openReservationForm({Map<String, dynamic>? reservation, int? index}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => ReservationFormDialog(reservation: reservation),
    );
    if (result != null) {
      setState(() {
        if (index != null) {
          reservations[index] = result;
        } else {
          reservations.add(result);
        }
      });
    }
  }

  void _deleteReservation(int idx) {
    setState(() {
      reservations.removeAt(idx);
    });
  }

  List<Map<String, dynamic>> get _filteredList {
    if (selectedFilter == 0) return reservations;
    final status = filterOptions[selectedFilter];
    return reservations.where((r) => r['status'] == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Text(
            "Gestion des réservations",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(
              filterOptions.length,
              (idx) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(filterOptions[idx],
                      style: TextStyle(
                        color: idx == selectedFilter
                            ? Colors.white
                            : Colors.black,
                        fontFamily: 'Poppins',
                      )),
                  selected: idx == selectedFilter,
                  selectedColor: const Color(0xFFFF6600),
                  backgroundColor: const Color(0xFFF5F5F5),
                  onSelected: (selected) {
                    setState(() {
                      selectedFilter = idx;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _openReservationForm(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6600),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                elevation: 1,
              ),
              icon: const Icon(Icons.add),
              label: const Text(
                "Nouvelle réservation",
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _filteredList.isEmpty
              ? const Center(child: Text("Aucune réservation", style: TextStyle(fontFamily: 'Poppins', color: Colors.grey)))
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _filteredList.length,
            itemBuilder: (context, idx) {
              final res = _filteredList[idx];
              final int realIdx = reservations.indexOf(res);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              res['name'] as String? ?? '',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: (res['passColor'] ?? const Color(0xFFCEB8FF)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              res['pass'] ?? '',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 17, color: Colors.grey[700]),
                          const SizedBox(width: 4),
                          Text(
                            res['date'] ?? '',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: (res['statusColor'] as Color? ?? Colors.black).withOpacity(0.13),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              res['status'] ?? '',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: res['statusColor'] as Color? ?? Colors.black,
                              ),
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () => _openReservationForm(reservation: res, index: realIdx),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6600),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size(30, 36),
                              elevation: 0,
                            ),
                            child: const Text("Modifier"),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _deleteReservation(realIdx),
                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 24),
                            splashRadius: 20,
                          ),
                        ],
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

class ReservationFormDialog extends StatefulWidget {
  final Map<String, dynamic>? reservation;
  const ReservationFormDialog({this.reservation, super.key});

  @override
  State<ReservationFormDialog> createState() => _ReservationFormDialogState();
}

class _ReservationFormDialogState extends State<ReservationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String pass = "";
  Color passColor = const Color(0xFFCEB8FF);
  String status = "En attente";
  Color statusColor = const Color(0xFFFF6600);
  String date = "";

  @override
  void initState() {
    super.initState();
    if (widget.reservation != null) {
      name = widget.reservation!['name'] ?? "";
      pass = widget.reservation!['pass'] ?? "";
      passColor = widget.reservation!['passColor'] ?? const Color(0xFFCEB8FF);
      status = widget.reservation!['status'] ?? "En attente";
      statusColor = widget.reservation!['statusColor'] ?? const Color(0xFFFF6600);
      date = widget.reservation!['date'] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.reservation == null ? "Nouvelle réservation" : "Modifier la réservation"),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 310,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: "Nom du client"),
                validator: (val) => val == null || val.trim().isEmpty ? "Nom requis" : null,
                onSaved: (val) => name = val ?? "",
              ),
              DropdownButtonFormField<String>(
                value: pass.isNotEmpty ? pass : "VIP Experience",
                items: [
                  "VIP Experience",
                  "Standard Pass",
                  "Golden Pass",
                ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) {
                  setState(() {
                    pass = val ?? "";
                    if (pass == "VIP Experience") passColor = const Color(0xFFCEB8FF);
                    if (pass == "Standard Pass") passColor = const Color(0xFFC8F4CD);
                    if (pass == "Golden Pass") passColor = const Color(0xFFFFE59C);
                  });
                },
                decoration: const InputDecoration(labelText: "Type de pass"),
              ),
              DropdownButtonFormField<String>(
                value: status,
                items: [
                  "En attente",
                  "Confirmé",
                  "Annulé",
                ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) {
                  setState(() {
                    status = val ?? "En attente";
                    if (status == "En attente") statusColor = const Color(0xFFFF6600);
                    if (status == "Confirmé") statusColor = const Color(0xFF00C853);
                    if (status == "Annulé") statusColor = const Color(0xFFFF0000);
                  });
                },
                decoration: const InputDecoration(labelText: "Statut"),
              ),
              TextFormField(
                initialValue: date,
                decoration: const InputDecoration(labelText: "Date (ex: 20/06/2025, 18:00)"),
                onSaved: (val) => date = val ?? "",
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler")),
        ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                Navigator.pop(context, {
                  "name": name,
                  "pass": pass,
                  "passColor": passColor,
                  "status": status,
                  "statusColor": statusColor,
                  "date": date,
                });
              }
            },
            child: Text(widget.reservation == null ? "Créer" : "Modifier"))
      ],
    );
  }
}