import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class Legend extends StatelessWidget {
  final Color color;
  final String text;

  const Legend({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Keeps the row tight around content
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        // Flexible allows the text to behave correctly in tight spaces
        Flexible(
          child: Text(
            text,
            overflow:
                TextOverflow.ellipsis, // Prevents text from breaking layout
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF8F8F8F),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
