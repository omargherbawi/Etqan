import 'package:flutter/material.dart';

class BlankPage extends StatelessWidget {
  const BlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("لا يمكن استخدام البرنامج اثناء استخدام احد تطبيقات تسجيل الشاشة او التحكم في الاجهزة"),
      ),
    );
  }
}
