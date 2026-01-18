import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tentwenty_assignment/core/utils/colors.dart';
import 'package:tentwenty_assignment/presentation/providers/seat_selection_provider.dart';
import 'package:tentwenty_assignment/presentation/screens/seat_selection/widgets/legend.dart';
import 'package:tentwenty_assignment/presentation/screens/seat_selection/widgets/screen_arc_painter.dart';

class SeatSelectionScreen extends ConsumerWidget {
  final String title;
  const SeatSelectionScreen({super.key, required this.title});

  static const int seatsPerRow =
      24; // Increased to match the dense look in image
  static const int leftAisle = 4;
  static const int rightAisle = 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(seatSelectionProvider.notifier);
    final state = ref.watch(seatSelectionProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.darkText,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${state.selectedDate}  |  ${state.selectedShowtime} Hall 1",
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),

          /// Cinema Screen Arc
          Column(
            children: [
              CustomPaint(
                size: const Size(300, 20),
                painter: ScreenArcPainter(),
              ),
              const SizedBox(height: 8),
              const Text(
                "SCREEN",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          /// Seat Grid (Responsive)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  children: List.generate(10, (rowIndex) {
                    final row = rowIndex + 1;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$row",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ...List.generate(seatsPerRow, (seatIndex) {
                            // Logic for Aisle Gaps
                            if (seatIndex == leftAisle ||
                                seatIndex == rightAisle) {
                              return const SizedBox(width: 15);
                            }

                            final seat = seatIndex + 1;
                            final key = '${row}_$seat';

                            Color color;
                            if (state.selectedSeats.containsKey(key)) {
                              color = const Color(0xFFCD9D0F); // Orange/Amber
                            } else if (notifier.unavailableSeats.contains(
                              key,
                            )) {
                              color = const Color(0xFFE5E5E5); // Light Grey
                            } else if (row == 10) {
                              color = const Color(0xFF564CA3); // Purple VIP
                            } else {
                              color = AppColors.primaryBlue;
                            }

                            return GestureDetector(
                              onTap: () => notifier.toggleSeat(row, seat),
                              child: Container(
                                width: 12,
                                height: 12,
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          /// Legend Section (Responsive Wrap)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            color: const Color(0xFFF6F6FA),
            child: Wrap(
              spacing: 30,
              runSpacing: 15,
              children: const [
                Legend(color: Color(0xFFCD9D0F), text: "Selected"),
                Legend(color: Color(0xFFE5E5E5), text: "Not available"),
                Legend(color: Color(0xFF564CA3), text: "VIP (150\$)"),
                Legend(color: AppColors.primaryBlue, text: "Regular (50\$)"),
              ],
            ),
          ),

          /// Bottom Payment Bar
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEFEF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Price",
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.darkText,
                        ),
                      ),
                      Text(
                        "\$ ${notifier.totalPrice()}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state.selectedSeats.isEmpty ? null : () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        disabledBackgroundColor: Colors.grey.shade300,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Proceed to pay",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
