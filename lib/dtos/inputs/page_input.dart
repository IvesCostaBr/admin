import 'package:flutter/material.dart';

class PageInput {
  String type;
  String? backgroundImage;
  Map<String, Map<String, String>>? location;
  String? title;
  List<Widget>? widgets;
  List<InputField>? inputs;

  PageInput({
    required this.type,
    this.backgroundImage,
    this.location,
    this.title,
    this.widgets,
    this.inputs,
  });
}

class InputField {
  String type;
  String name;
  String label;
  String? placeholder;
  bool required;
  String? svg;
  String? mask;
  String? rgexValidator;

  InputField({
    required this.type,
    required this.name,
    required this.label,
    this.placeholder,
    this.required = false,
    this.svg,
    this.mask,
    this.rgexValidator,
  });
}