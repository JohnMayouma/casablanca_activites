// lib/widgets/hotel_card.dart

import 'package:flutter/material.dart';

class HotelCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String price;
  final double rating;
  final bool vertical;

  const HotelCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.price,
    required this.rating,
    this.vertical = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: vertical ? 120 : null,
      width: vertical ? double.infinity : 160,
      margin: const EdgeInsets.only(right: 12, bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$$price',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.yellow, size: 14),
                          const SizedBox(width: 2),
                          Text(rating.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
