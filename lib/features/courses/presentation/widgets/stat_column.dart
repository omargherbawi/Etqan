import 'package:flutter/material.dart';

class StatColumn extends StatelessWidget {
  final String iconpath;
  final String mainText;
  final String subText;

  const StatColumn({
    super.key,
    required this.iconpath,
    required this.mainText,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconpath, height: 48),
          const SizedBox(height: 8),
          Text(
            mainText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subText,
            style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
