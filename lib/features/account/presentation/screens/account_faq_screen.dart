import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/shared.dart';
import '../../../../core/widgets/custom_appbar.dart';

class AccountFaqScreen extends StatelessWidget {
  const AccountFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "faq"),
      body: SingleChildScrollView(
        padding: UIConstants.mobileBodyPadding,
        child: ExpansionTile(
          title: const Text("data"),
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          collapsedBackgroundColor: Theme.of(context).colorScheme.onSurface,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          collapsedShape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          tilePadding: EdgeInsets.symmetric(horizontal: 12.w),
          children: const [Text("data")],
        ),
      ),
    );
  }
}
