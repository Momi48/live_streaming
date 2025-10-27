import 'package:flutter/material.dart';
import 'package:twitch_clone/utils/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.color,
  });
  final String text;
  final VoidCallback onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: text == 'Log in' ?  buttonColor :color ,
        minimumSize: const Size(double.infinity, 40),
      ),
      onPressed: onTap,
      child: text == 'Log in' || color == buttonColor ? Text(text,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),) 
       : Text(text,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
    );
  }
}