import 'package:flutter/material.dart';

class InputModel {
  final String name;
  final String? hint;
  final TextEditingController controller;
  final bool isObscure;

  InputModel({required this.name, required this.hint, required this.controller, this.isObscure = false});
}