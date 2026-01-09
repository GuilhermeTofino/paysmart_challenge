import 'package:flutter/material.dart';

class RatingCircle extends StatelessWidget {
  final double voteAverage;
  final double size;
  final double fontSize;

  const RatingCircle({
    super.key,
    required this.voteAverage,
    this.size = 40,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final int percentage = (voteAverage * 10).round();

    Color progressColor;
    if (percentage >= 70) {
      progressColor = Colors.greenAccent;
    } else if (percentage >= 40) {
      progressColor = Colors.amber;
    } else {
      progressColor = Colors.redAccent;
    }

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF081C22),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: percentage / 100,
              strokeWidth: 3,
              backgroundColor: Colors.grey[800],
              color: progressColor,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$percentage',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
              Text(
                ' %',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: fontSize * 1,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
