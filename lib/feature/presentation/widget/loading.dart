import 'package:custom_map/core/config/appColor.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
