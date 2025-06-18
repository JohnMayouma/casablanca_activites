import 'package:flutter/material.dart';

class TicketOption extends StatefulWidget {
  final String type;
  final int price;

  const TicketOption({
    super.key,
    required this.type,
    required this.price,
  });

  @override
  State<TicketOption> createState() => _TicketOptionState();
}

class _TicketOptionState extends State<TicketOption> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "${widget.type} - ${widget.price} MAD",
              style: const TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
            onPressed: quantity > 0 ? () => setState(() => quantity--) : null,
            icon: const Icon(Icons.remove),
          ),
          Text('$quantity', style: const TextStyle(fontSize: 16)),
          IconButton(
            onPressed: () => setState(() => quantity++),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
