import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenericContainer extends StatelessWidget {
  final Widget content;
  final String? text;
  const GenericContainer({super.key, required this.content,this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
        child: Container(
          padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Column(
                children: [
                  Text(text ?? '', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 15,),
                  Expanded(
                child: ListView(
                  children: [content],
                ),
              ),
                ],
              ),
            ),
      );
  }
}
