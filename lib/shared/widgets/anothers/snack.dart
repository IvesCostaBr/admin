
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void snackError(String error){
  Get.snackbar('Erro', error, backgroundColor: Colors.red, colorText: Colors.white);
}

void snackSuccess(String? title, String message){
  String? titleText = title;
  if(title == null){
    titleText = "Sucesso";
  }
  Get.snackbar(
    icon: const Icon(Icons.check_box_rounded),
    padding: const EdgeInsets.only(top: 12, bottom: 12),
    margin: EdgeInsets.only(left: 1200),
    titleText!, message, backgroundColor: Colors.green, colorText: Colors.white);
}

void snackWarning(String? title, String message){
  String? titleText = title;
  if(title == null){
    titleText = "Sucesso";
  }
  Get.snackbar(
    icon: const Icon(Icons.error),
    titleText!, message, backgroundColor: Colors.orange, colorText: Colors.white);
}