import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  final String text;

  const Overview(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(
          text,
          style: TextStyle(fontSize: 14, height: 1.6, color: Colors.grey[700]),
        ),
      ],
    );
  }
}
