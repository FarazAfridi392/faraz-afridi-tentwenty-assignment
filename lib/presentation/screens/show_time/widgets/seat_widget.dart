import 'package:flutter/material.dart';
import 'package:tentwenty_assignment/core/utils/colors.dart';

class MiniSeatMap extends StatelessWidget {
  const MiniSeatMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(10, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(24, (col) {
            if (col == 4 || col == 20) return const SizedBox(width: 4);

            Color seatColor;

            if (row == 9) {
              seatColor = const Color(0xFF564CA3);
            } else if ((row == 2 && col == 6) ||
                (row == 4 && col == 12) ||
                (row == 0 && col == 18)) {
              seatColor = Colors.grey.shade300;
            } else {
              seatColor = AppColors.primaryBlue;
            }

            return Container(
              width: 5,
              height: 5,
              margin: const EdgeInsets.all(0.8),
              decoration: BoxDecoration(
                color: seatColor,
                borderRadius: BorderRadius.circular(1),
              ),
            );
          }),
        );
      }),
    );
  }
}
