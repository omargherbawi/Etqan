import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';
import '../../../../core/core.dart';

class BlankSlot extends StatelessWidget {
  final String? text;
  final void Function(String word) onAccept;
  final VoidCallback onClear;

  const BlankSlot({
    super.key,
    required this.text,
    required this.onAccept,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasText = (text != null && text!.isNotEmpty);
    return DragTarget<String>(
      builder: (context, candidate, rejected) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasText ? AppLightColors.primaryColor : Colors.grey,
              width: 1.4,
              style: BorderStyle.solid,
            ),
            color: hasText ? AppLightColors.primaryColorLight : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 2),
              CustomTextWidget(
                text: hasText ? text! : 'Drag',
                fontSize: 11,
                color: hasText ? Colors.black87 : Colors.black38,
              ),
              if (hasText) ...[
                const SizedBox(width: 6),
                InkWell(
                  onTap: onClear,
                  child: const Icon(Icons.close, size: 16),
                )
              ]
            ],
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: onAccept,
    );
  }
}


