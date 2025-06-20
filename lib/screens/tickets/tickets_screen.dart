import 'package:flutter/material.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

enum TicketStatus { upcoming, completed, cancelled }

class _TicketsScreenState extends State<TicketsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  // Exemple dynamique d'historique tickets (à remplacer par une liste issue API ou provider)
  List<Map<String, dynamic>> allTickets = [
    {
      "event": "National Music Festival",
      "date": "24 Juin 2025 – 21:00",
      "location": "Grand Park, Casa",
      "type": "VIP",
      "quantity": 2,
      "price": "1000 MAD",
      "status": TicketStatus.upcoming,
      "img": "assets/images/rema.jpg",
    },
    {
      "event": "Art & Mural Workshop",
      "date": "27 Déc. 2025 – 19:00",
      "location": "Art House",
      "type": "Standard",
      "quantity": 1,
      "price": "350 MAD",
      "status": TicketStatus.upcoming,
      "img": "assets/images/jazz.jpg",
    },
    {
      "event": "Jazz Night Casablanca",
      "date": "20 Août 2024 – 19:30",
      "location": "Villa des Arts",
      "type": "Standard",
      "quantity": 1,
      "price": "150 MAD",
      "status": TicketStatus.completed,
      "img": "assets/images/jazz.jpg",
      "reviewed": false,
    },
    {
      "event": "Yoga Zen Session",
      "date": "15 Mai 2025 – 18:00",
      "location": "Rooftop Zen",
      "type": "Standard",
      "quantity": 1,
      "price": "100 MAD",
      "status": TicketStatus.cancelled,
      "img": "assets/images/cuisine.jpeg",
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
        title: const Text("Cancel Booking"),
        content: const Text(
          "Are you sure you want to cancel this event?\n\nOnly 80% of funds will be returned to your account according to our policy.",
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("No, Don't Cancel")),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Yes, Cancel")),
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
        title: const Text("Leave a Review"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("How was your experience with this event?"),
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
              decoration: const InputDecoration(hintText: "Write your review"),
              minLines: 2,
              maxLines: 4,
              onChanged: (val) => reviewText = val,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Maybe Later")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                allTickets[idx]['reviewed'] = true;
              });
              Navigator.pop(ctx);
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimary = const Color.fromARGB(255, 247, 76, 73); // Violet comme sur l'image
    final colorInactive = Colors.grey[400];

    final tabs = [
      Tab(child: Text("Upcoming", style: TextStyle(fontWeight: FontWeight.bold))),
      Tab(child: Text("Completed", style: TextStyle(fontWeight: FontWeight.bold))),
      Tab(child: Text("Cancelled", style: TextStyle(fontWeight: FontWeight.bold))),
    ];

    List<Map<String, dynamic>> ticketsFiltered(TicketStatus status) =>
        allTickets.where((t) => t['status'] == status).toList();

    Widget buildEmptyState() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/empty_tickets.png", width: 140, height: 140, fit: BoxFit.contain),
            const SizedBox(height: 18),
            const Text(
              "Empty Tickets",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 8),
            const Text(
              "Looks like you don't have a ticket yet! Start searching for events now by clicking the button below.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 22),
            OutlinedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
              style: OutlinedButton.styleFrom(
                  foregroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: const Text("Find Events"),
            )
          ],
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tickets"),
        backgroundColor: Colors.white,
        elevation: 0.5,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: colorPrimary,
              unselectedLabelColor: colorInactive,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: colorPrimary.withOpacity(0.07),
                      blurRadius: 8,
                      spreadRadius: 1)
                ],
              ),
              tabs: tabs,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // UPCOMING
          ticketsFiltered(TicketStatus.upcoming).isEmpty
              ? Center(child: buildEmptyState())
              : ListView.separated(
                  padding: const EdgeInsets.all(18),
                  itemCount: ticketsFiltered(TicketStatus.upcoming).length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (ctx, idx) {
                    final tkt = ticketsFiltered(TicketStatus.upcoming)[idx];
                    final realIdx = allTickets.indexOf(tkt);
                    return _TicketCard(
                      ticket: tkt,
                      color: colorPrimary,
                      onCancel: () => _cancelTicket(realIdx),
                      onView: () {
                        // TODO: voir e-ticket
                      },
                      showCancel: true,
                      showView: true,
                    );
                  },
                ),
          // COMPLETED
          ticketsFiltered(TicketStatus.completed).isEmpty
              ? Center(child: buildEmptyState())
              : ListView.separated(
                  padding: const EdgeInsets.all(18),
                  itemCount: ticketsFiltered(TicketStatus.completed).length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (ctx, idx) {
                    final tkt = ticketsFiltered(TicketStatus.completed)[idx];
                    final realIdx = allTickets.indexOf(tkt);
                    return _TicketCard(
                      ticket: tkt,
                      color: colorPrimary,
                      showCancel: false,
                      showView: true,
                      onReview: tkt['reviewed'] == true ? null : () => _showReviewDialog(realIdx),
                    );
                  },
                ),
          // CANCELLED
          ticketsFiltered(TicketStatus.cancelled).isEmpty
              ? Center(child: buildEmptyState())
              : ListView.separated(
                  padding: const EdgeInsets.all(18),
                  itemCount: ticketsFiltered(TicketStatus.cancelled).length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (ctx, idx) {
                    final tkt = ticketsFiltered(TicketStatus.cancelled)[idx];
                    return _TicketCard(
                      ticket: tkt,
                      color: Colors.red,
                      showCancel: false,
                      showView: false,
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final Map<String, dynamic> ticket;
  final Color color;
  final VoidCallback? onCancel;
  final VoidCallback? onView;
  final VoidCallback? onReview;
  final bool showCancel;
  final bool showView;

  const _TicketCard({
    required this.ticket,
    required this.color,
    this.onCancel,
    this.onView,
    this.onReview,
    this.showCancel = false,
    this.showView = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.asset(ticket['img'] ?? "assets/images/rema.jpg", width: 60, height: 60, fit: BoxFit.cover),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ticket['event'] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 3),
                  Text(ticket['date'] ?? "", style: const TextStyle(fontSize: 13, color: Colors.black54)),
                  Text(ticket['location'] ?? "", style: const TextStyle(fontSize: 13, color: Colors.black54)),
                  Row(
                    children: [
                      Text(
                        "${ticket['type']} x${ticket['quantity']}",
                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ticket['price'] ?? "",
                        style: const TextStyle(fontSize: 13, color: Color(0xFF5735FF), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  if (ticket['cancelReason'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        ticket['cancelReason'],
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 7),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showCancel)
                  OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 36, 102, 215),
                      side: const BorderSide(color: Color.fromARGB(255, 67, 105, 242)),
                      minimumSize: const Size(90, 38),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                    ),
                    child: const Text("Annuler Réservation"),
                  ),
                if (showView)
                  OutlinedButton(
                    onPressed: onView,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: color,
                      side: BorderSide(color: color),
                      minimumSize: const Size(90, 38),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                    ),
                    child: const Text("Voir Le Ticket"),
                  ),
                if (onReview != null)
                  OutlinedButton(
                    onPressed: onReview,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 218, 38, 38),
                      side: const BorderSide(color: Color.fromARGB(255, 216, 35, 35)),
                      minimumSize: const Size(90, 38),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                    ),
                    child: const Text("Laisser un avis"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}