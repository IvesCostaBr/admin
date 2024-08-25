import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenericContainer extends StatefulWidget {
  final Widget content;
  final String? text;
  const GenericContainer({super.key, required this.content,this.text});

  @override
  State<GenericContainer> createState() => _GenericContainerState();
}

class _GenericContainerState extends State<GenericContainer> {
  int _updateKey = 0;

  void _refreshContent() {
    setState(() {
      _updateKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
        child: Container(
          padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.black.withOpacity(0.4) : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox.shrink(),
                      Text(widget.text ?? '', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                      ElevatedButton(
                        onPressed: (){ _refreshContent();}, child: const Row(children: [Icon(Icons.refresh), Text('Atualizar')],))
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Expanded(
                child: ListView(
                  key: ValueKey(_updateKey),
                  children: [widget.content],
                ),
              ),
                ],
              ),
            ),
      );
  }
}
