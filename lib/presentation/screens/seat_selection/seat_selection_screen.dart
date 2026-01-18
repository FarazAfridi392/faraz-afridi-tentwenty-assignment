import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tentwenty_assignment/core/utils/colors.dart';
import 'package:tentwenty_assignment/presentation/providers/seat_selection_provider.dart';
import 'package:tentwenty_assignment/presentation/screens/seat_selection/widgets/legend.dart';

class SeatSelectionScreen extends ConsumerWidget {
  String title;
  SeatSelectionScreen({super.key, required this.title});

  static const int seatsPerRow = 20;
  static const int aisleAfter = 10;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(seatSelectionProvider.notifier);
    final state = ref.watch(seatSelectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Text(
              "${state.selectedDate} | ${state.selectedShowtime}",
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(10, (rowIndex) {
                  final row = rowIndex + 1;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(seatsPerRow, (seatIndex) {
                        if (seatIndex == aisleAfter) {
                          return const SizedBox(width: 16);
                        }

                        final seat = seatIndex + 1;
                        final key = '${row}_$seat';

                        Color color;
                        if (state.selectedSeats.containsKey(key)) {
                          color = Colors.amber;
                        } else if (notifier.unavailableSeats.contains(key)) {
                          color = Colors.grey.shade400;
                        } else if (row == SeatSelectionNotifier.totalRows) {
                          color = Colors.purple;
                        } else {
                          color = AppColors.primaryBlue;
                        }

                        return GestureDetector(
                          onTap: () => notifier.toggleSeat(row, seat),
                          child: Container(
                            width: 14,
                            height: 14,
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Wrap(
              spacing: 16,
              children: const [
                Legend(color: Colors.amber, text: "Selected"),
                Legend(color: Colors.grey, text: "Not available"),
                Legend(color: Colors.purple, text: "VIP (150\$)"),
                Legend(color: AppColors.primaryBlue, text: "Regular (50\$)"),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Price",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "\$ ${notifier.totalPrice()}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: state.selectedSeats.isEmpty ? null : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text("Proceed to pay"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
