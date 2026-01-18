import 'package:flutter/material.dart';
import 'package:tentwenty_assignment/core/utils/colors.dart';
import 'package:tentwenty_assignment/presentation/screens/show_time/widgets/seat_widget.dart';

class ShowtimeCard extends StatelessWidget {
  final String time;
  final String hall;
  final String price;
  final String bonus;
  final bool isSelected;
  final VoidCallback onTap;

  const ShowtimeCard({
    super.key,
    required this.time,
    required this.hall,
    required this.price,
    required this.bonus,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color(0xFF202C43),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              hall,
              style: const TextStyle(color: Color(0xFF8F8F8F), fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 250,
            height: 145,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryBlue
                    : const Color(0xFFEFEFEF),
                width: 1,
              ),
              color: Colors.white,
            ),
            child: const Center(child: MiniSeatMap()),
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Color(0xFF8F8F8F), fontSize: 12),
            children: [
              const TextSpan(text: "From "),
              TextSpan(
                text: price,
                style: const TextStyle(
                  color: Color(0xFF202C43),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: " or "),
              TextSpan(
                text: "$bonus bonus",
                style: const TextStyle(
                  color: Color(0xFF202C43),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
