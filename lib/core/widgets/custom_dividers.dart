import 'package:flutter/material.dart';
import 'package:etqan_edu_app/config/config.dart';

class LightDivider extends StatelessWidget {
  final double? thickness;

  const LightDivider({super.key, this.thickness});

  @override
  Widget build(BuildContext context) {
    return Divider(color: SharedColors.grayColor, thickness: thickness ?? .5);
  }
}

class DarkDivider extends StatelessWidget {
  final double? thickness;

  const DarkDivider({super.key, this.thickness});

  @override
  Widget build(BuildContext context) {
    return Divider(color: SharedColors.grayColor, thickness: thickness ?? .5);
  }
}
