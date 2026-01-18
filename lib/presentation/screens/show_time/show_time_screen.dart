import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tentwenty_assignment/core/utils/colors.dart';
import 'package:tentwenty_assignment/presentation/providers/seat_selection_provider.dart';
import 'package:tentwenty_assignment/presentation/screens/seat_selection/seat_selection_screen.dart';
import 'package:tentwenty_assignment/presentation/screens/show_time/widgets/show_time_card.dart';

class ShowtimeScreen extends ConsumerWidget {
  final String title;
  const ShowtimeScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(seatSelectionProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
            const Text(
              "In Theaters Jan 20, 2026",
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Date",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
          ),
          const SizedBox(height: 14),

          SizedBox(
            height: 35,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, index) {
                final date = DateFormat(
                  'd MMM',
                ).format(DateTime.now().add(Duration(days: index)));
                final isSelected = date == state.selectedDate;

                return GestureDetector(
                  onTap: () =>
                      ref.read(seatSelectionProvider.notifier).selectDate(date),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryBlue
                          : const Color(0xFFA6A6A6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      date,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.darkText,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 30),

          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                ShowtimeCard(
                  time: "12:30",
                  hall: "Cinetech + Hall 1",
                  price: "50\$",
                  bonus: "2500",
                  isSelected: state.selectedShowtime == "12:30",
                  onTap: () => ref
                      .read(seatSelectionProvider.notifier)
                      .selectShowtime("12:30"),
                ),
                const SizedBox(width: 15),
                ShowtimeCard(
                  time: "13:30",
                  hall: "Cinetech + Hall 1",
                  price: "75\$",
                  bonus: "3000",
                  isSelected: state.selectedShowtime == "13:30",
                  onTap: () => ref
                      .read(seatSelectionProvider.notifier)
                      .selectShowtime("13:30"),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: state.selectedShowtime == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SeatSelectionScreen(title: title),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  disabledBackgroundColor: Colors.grey.shade300,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Select Seats",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
