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
              color: Get.isDarkMode ? Colors.grey : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
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
