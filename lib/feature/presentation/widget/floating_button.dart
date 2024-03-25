import 'package:flutter/material.dart';
import '../../../core/config/appColor.dart';

class FloatingButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool iSprimaryButton;
  const FloatingButton({required this.icon,required this.onPressed,this.iSprimaryButton=false,super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor:iSprimaryButton?AppColor.blue:AppColor.black,
      onPressed: onPressed,
      child:Icon(
        icon,
        color: AppColor.white,
      ),
    );
  }
}
