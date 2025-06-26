import 'package:flutter/material.dart';

enum TicketStatus { upcoming, completed, cancelled }

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  // Liste mockée pour l'exemple
  List<Map<String, dynamic>> allTickets = [
    {
      "event": "Atelier d'écriture créative",
      "organizer": "Maison des Arts",
      "date": "24 Juin 2025 – 21:00",
      "location": "Grand Parc, Casa",
      "type": "VIP",
      "quantity": 2,
      "price": "1000 MAD",
      "status": TicketStatus.upcoming,
      "img": "assets/images/rema.jpg",
      "free": false,
      "paid": true,
    },
    {
      "event": "Atelier de peinture acrylique",
      "organizer": "Centre d'Art",
      "date": "27 Déc. 2025 – 19:00",
      "location": "Art House, Casablanca",
      "type": "Standard",
      "quantity": 1,
      "price": "350 MAD",
      "status": TicketStatus.upcoming,
      "img": "assets/images/jazz.jpg",
      "free": false,
      "paid": true,
    },
    {
      "event": "Jazz Night Casablanca",
      "organizer": "Jazz Club",
      "date": "20 Août 2024 – 19:30",
      "location": "Villa des Arts",
      "type": "Standard",
      "quantity": 1,
      "price": "150 MAD",
      "status": TicketStatus.completed,
      "img": "assets/images/jazz.jpg",
      "paid": true,
    },
    {
      "event": "Session Yoga Zen",
      "organizer": "Zen Rooftop",
      "date": "15 Mai 2025 – 18:00",
      "location": "Rooftop Zen",
      "type": "Standard",
      "quantity": 1,
      "price": "100 MAD",
      "status": TicketStatus.cancelled,
      "img": "assets/images/cuisine.jpeg",
      "paid": false,
      "cancelReason": "Annulé par l'utilisateur",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _cancelTicket(int idx) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Annuler la réservation"),
        content: const Text(
          "Êtes-vous sûr de vouloir annuler cette réservation ?\n\n80% des fonds seront recrédités sur votre compte selon notre politique.",
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Non, garder")),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F38E9)),
              child: const Text("Oui, annuler")),
        ],
      ),
    );
    if (confirm == true) {
      setState(() {
        final ticket = allTickets[idx];
        ticket['status'] = TicketStatus.cancelled;
        ticket['cancelReason'] = "Annulé par l'utilisateur";
      });
    }
  }

  void _showReviewDialog(int idx) {
    double rating = 0;
    String reviewText = "";
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Laisser un avis"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Comment évalueriez-vous votre expérience ?"),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (i) => IconButton(
                  onPressed: () => setState(() => rating = i + 1.0),
                  icon: Icon(
                    rating >= i + 1 ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(hintText: "Votre avis..."),
              minLines: 2,
              maxLines: 4,
              onChanged: (val) => reviewText = val,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Plus tard")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                allTickets[idx]['reviewed'] = true;
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F38E9)),
            child: const Text("Envoyer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color evanoBlue = const Color(0xFF4F38E9);
    final Color orangeTicket = const Color(0xFFFF5B26);

    final tabs = [
      Tab(child: Text("À venir", style: TextStyle(fontWeight: FontWeight.bold))),
      Tab(child: Text("Terminés", style: TextStyle(fontWeight: FontWeight.bold))),
      Tab(child: Text("Annulés", style: TextStyle(fontWeight: FontWeight.bold))),
    ];

    List<Map<String, dynamic>> ticketsFiltered(TicketStatus status) =>
        allTickets.where((t) => t['status'] == status).toList();

    Widget buildEmptyState() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/empty_tickets.png", width: 120, height: 120, fit: BoxFit.contain),
            const SizedBox(height: 16),
            const Text(
              "Aucun ticket",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 6),
            const Text(
              "Vous n'avez pas encore de réservation.\nCommencez par explorer les événements !",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
              style: OutlinedButton.styleFrom(
                  foregroundColor: evanoBlue,
                  side: BorderSide(color: evanoBlue),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: const Text("Explorer les événements"),
            )
          ],
        );

    return WillPopScope(
  onWillPop: () async {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    return false;
  },
  child: Scaffold(

     
     
     
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Tickets", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
              icon: const Icon(Icons.search, color: Colors.black54),
              onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black54),
              onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(54),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: TabBar(
              controller: _tabController,
              labelColor: evanoBlue,
              unselectedLabelColor: Colors.grey[400],
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: evanoBlue, width: 3.5),
                insets: const EdgeInsets.symmetric(horizontal: 24),
              ),
              tabs: tabs,
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF6F5FA),
      body: TabBarView(
        controller: _tabController,
        children: [
          // À VENIR
          ticketsFiltered(TicketStatus.upcoming).isEmpty
              ? Center(child: buildEmptyState())
              : ListView.separated(
                  padding: const EdgeInsets.all(18),
                  itemCount: ticketsFiltered(TicketStatus.upcoming).length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (ctx, idx) {
                    final tkt = ticketsFiltered(TicketStatus.upcoming)[idx];
                    final realIdx = allTickets.indexOf(tkt);
                    return _TicketEvanoCard(
                      ticket: tkt,
                      color: evanoBlue,
                      badge: const _StatusBadge(
                        label: "Payé",
                        color: Color(0xFF4F38E9),
                        borderColor: Color(0xFF4F38E9),
                        textColor: Color(0xFF4F38E9),
                      ),
                      onCancel: () => _cancelTicket(realIdx),
                      onView: () {
                        // TODO: voir e-ticket
                      },
                      showCancel: true,
                      showView: true,
                      viewTicketButtonColor: orangeTicket, // Orange pour "Voir le ticket" ici uniquement
                    );
                  },
                ),
          // TERMINÉS
          ticketsFiltered(TicketStatus.completed).isEmpty
              ? Center(child: buildEmptyState())
              : ListView.separated(
                  padding: const EdgeInsets.all(18),
                  itemCount: ticketsFiltered(TicketStatus.completed).length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (ctx, idx) {
                    final tkt = ticketsFiltered(TicketStatus.completed)[idx];
                    final realIdx = allTickets.indexOf(tkt);
                    return _TicketEvanoCard(
                      ticket: tkt,
                      color: evanoBlue,
                      badge: const _StatusBadge(
                        label: "Terminé",
                        color: Color(0xFF1BC47D),
                        borderColor: Color(0xFF1BC47D),
                        textColor: Color(0xFF1BC47D),
                      ),
                      showCancel: false,
                      showView: true,
                      onReview: tkt['reviewed'] == true ? null : () => _showReviewDialog(realIdx),
                      viewTicketButtonColor: evanoBlue, // Bleu Evano pour les autres onglets
                    );
                  },
                ),
          // ANNULÉS
          ticketsFiltered(TicketStatus.cancelled).isEmpty
              ? Center(child: buildEmptyState())
              : ListView.separated(
                  padding: const EdgeInsets.all(18),
                  itemCount: ticketsFiltered(TicketStatus.cancelled).length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (ctx, idx) {
                    final tkt = ticketsFiltered(TicketStatus.cancelled)[idx];
                    return _TicketEvanoCard(
                      ticket: tkt,
                      color: evanoBlue,
                      badge: const _StatusBadge(
                        label: "Annulé",
                        color: Color(0xFFF44336),
                        borderColor: Color(0xFFF44336),
                        textColor: Color(0xFFF44336),
                      ),
                      showCancel: false,
                      showView: false,
                      viewTicketButtonColor: evanoBlue,
                    );
                  },
                ),
        ],
      ),
    ),
    );
  }
}

class _TicketEvanoCard extends StatelessWidget {
  final Map<String, dynamic> ticket;
  final Color color;
  final Widget? badge;
  final VoidCallback? onCancel;
  final VoidCallback? onView;
  final VoidCallback? onReview;
  final bool showCancel;
  final bool showView;
  final Color? viewTicketButtonColor;

  const _TicketEvanoCard({
    required this.ticket,
    required this.color,
    this.badge,
    this.onCancel,
    this.onView,
    this.onReview,
    this.showCancel = false,
    this.showView = false,
    this.viewTicketButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFree = ticket['free'] == true;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3E4A5940).withOpacity(0.10),
            blurRadius: 14,
            offset: const Offset(0, 6),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ligne du haut : image + titre + badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  ticket['img'] ?? "assets/images/rema.jpg",
                  width: 62,
                  height: 62,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ticket['event'] ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                        ),
                        if (isFree)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.13),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "GRATUIT",
                              style: TextStyle(
                                  color: color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5),
                            ),
                          ),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          badge!,
                        ]
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(ticket['organizer'] ?? "",
                        style: const TextStyle(fontSize: 13, color: Colors.black54)),
                    if (ticket['date'] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 1.5),
                        child: Text(
                          ticket['date'],
                          style: TextStyle(
                              color: color,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          // Infoline location + type + badge
          Row(
            children: [
              const Icon(Icons.place, color: Colors.grey, size: 16),
              const SizedBox(width: 3),
              Expanded(
                child: Text(ticket['location'] ?? "",
                    style: const TextStyle(fontSize: 13, color: Colors.black54)),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Text(
                "${ticket['type']} x${ticket['quantity']}",
                style: const TextStyle(color: Colors.black87, fontSize: 13),
              ),
              const SizedBox(width: 7),
              Text(
                ticket['price'] ?? "",
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          // Boutons action
          const SizedBox(height: 11),
          Row(
            children: [
              if (showCancel)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                        foregroundColor: color,
                        side: BorderSide(color: color),
                        minimumSize: const Size(0, 42),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text("Annuler la réservation"),
                  ),
                ),
              if (showCancel && showView)
                const SizedBox(width: 12),
              if (showView)
                Expanded(
                  child: ElevatedButton(
                    onPressed: onView,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: viewTicketButtonColor ?? color,
                        minimumSize: const Size(0, 42),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text("Voir le ticket"),
                  ),
                ),
              if (onReview != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReview,
                    style: OutlinedButton.styleFrom(
                        foregroundColor: color,
                        side: BorderSide(color: color),
                        minimumSize: const Size(0, 42),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text("Laisser un avis"),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color borderColor;
  final Color textColor;

  const _StatusBadge({
    required this.label,
    required this.color,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
          fontSize: 12.5,
        ),
      ),
    );
  }
}