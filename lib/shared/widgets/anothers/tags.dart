import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinTag extends StatelessWidget {
  final Color color;
  final String text;
  
  const PinTag({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(15))
        
      ),
      child: Text(text.capitalizeFirst!, style: const TextStyle(fontSize: 10, color: Colors.white)),
    );
  }
}