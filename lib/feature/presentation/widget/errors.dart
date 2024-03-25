import 'package:custom_map/core/config/appColor.dart';
import 'package:flutter/material.dart';

class Errors extends StatelessWidget {
  final String error;
  const Errors({required this.error,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text("Xatolik yuzaga keldi.\n$error"),
        ),
      ),
    );
  }
}
