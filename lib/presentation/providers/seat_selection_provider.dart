import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'
    show StateNotifierProvider, StateNotifier;
import 'package:intl/intl.dart';

final seatSelectionProvider =
    StateNotifierProvider<SeatSelectionNotifier, SeatSelectionState>(
      (ref) => SeatSelectionNotifier(),
    );

class SeatSelectionState {
  final String selectedDate;
  final String? selectedShowtime;
  final Map<String, String> selectedSeats;

  const SeatSelectionState({
    required this.selectedDate,
    required this.selectedShowtime,
    required this.selectedSeats,
  });

  SeatSelectionState copyWith({
    String? selectedDate,
    String? selectedShowtime,
    Map<String, String>? selectedSeats,
  }) {
    return SeatSelectionState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedShowtime: selectedShowtime ?? this.selectedShowtime,
      selectedSeats: selectedSeats ?? this.selectedSeats,
    );
  }
}

class SeatSelectionNotifier extends StateNotifier<SeatSelectionState> {
  SeatSelectionNotifier()
    : super(
        SeatSelectionState(
          selectedDate: DateFormat('d MMM').format(DateTime.now()),
          selectedShowtime: null,
          selectedSeats: {},
        ),
      );

  static const int totalRows = 10;

  final Set<String> unavailableSeats = {
    '3_5',
    '3_6',
    '4_7',
    '5_10',
    '6_15',
    '7_8',
    '7_9',
    '8_12',
  };

  void selectDate(String date) {
    state = state.copyWith(selectedDate: date);
  }

  void selectShowtime(String showtime) {
    state = state.copyWith(selectedShowtime: showtime);
  }

  void toggleSeat(int row, int seat) {
    final key = '${row}_$seat';
    if (unavailableSeats.contains(key)) return;

    final seats = Map<String, String>.from(state.selectedSeats);

    if (seats.containsKey(key)) {
      seats.remove(key);
    } else {
      seats[key] = row == totalRows ? 'VIP' : 'Regular';
    }

    state = state.copyWith(selectedSeats: seats);
  }

  int totalPrice() {
    int total = 0;
    for (final entry in state.selectedSeats.entries) {
      final row = int.parse(entry.key.split('_')[0]);
      total += row == totalRows ? 150 : 50;
    }
    return total;
  }
}
