
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
  Get.snackbar(titleText!, message, backgroundColor: Colors.green);
}

void snackWarning(String? title, String message){
  String? titleText = title;
  if(title == null){
    titleText = "Sucesso";
  }
  Get.snackbar(titleText!, message, backgroundColor: Colors.orange);
}