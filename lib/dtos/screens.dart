import 'dart:convert';
import 'dart:typed_data';

class Screens {
  Map<String, Screen> screens;
  Screens({required this.screens});


  factory Screens.fromJson(Map<String, dynamic> json){
    Map<String, Screen> screens = {};
    for(final screen in json.keys){
      screens[screen] =  Screen.fromJson(json[screen]);
    }
    return Screens(screens: screens);
  }
}

class Screen {
  final Map<String, dynamic>? title;
  final String? backgroundImage;
  final bool? backgroundBlur;
  final String? type;
  final List<FormInput>? inputs;
  final List<FormStep>? formSteps;
  final Map<String, dynamic>? description;
  final Map<String, dynamic>? widgets;
  final List? listData;
  final Map<String, dynamic>? location;

  Screen({this.title, this.backgroundImage, this.backgroundBlur = false, this.type, this.widgets, this.inputs, this.formSteps, this.listData, this.description, this.location});

  factory Screen.fromJson(Map<String, dynamic> json){
    return Screen(
      title: json['title'] ?? {},
      backgroundBlur: json['background_blur'],
      backgroundImage: json['background_image'],
      description: json['description'],
      type: json['type'],
      listData: json['list_data'],
      widgets: json['widgets'],
      inputs: json['inputs'] != null
          ? List<FormInput>.from(
              (json['inputs'] as List<dynamic>).map((input) => FormInput.fromJson(input)))
          : [],
      formSteps: json['type'] == 'stepper_form' && json['data'] != null
          ? List<FormStep>.from(
              (json['data'] as List<dynamic>).map((value) => FormStep.fromJson(value)))
          : [],

      location: json['location']
    );
  }
}

class FormStep {
  final int step;
  final String title;
  final String description;
  final List<FormInput> inputs;

  FormStep({
    required this.step,
    required this.title,
    required this.description,
    required this.inputs,
  });

  static FormStep isEmpty(){
    return FormStep(step: 1, title: "", description: "", inputs: []);
  }

  factory FormStep.fromJson(Map<String, dynamic> json) {
    var inputs = (json['inputs'] as List)
        .map((input) => FormInput.fromJson(input))
        .toList();
    return FormStep(
      step: json['step'],
      title: json['title'],
      description: json['description'],
      inputs: inputs,
    );
  }
}

class FormInput {
  final String type;
  final String name;
  final String label;
  final Uint8List? svg;
  final String? mask;
  final bool? required;
  final String placeholder;
  final String? rgexValidator;

  FormInput({
    required this.type,
    required this.name,
    required this.label,
    required this.placeholder,
    this.svg,
    this.mask,
    this.required = false,
    this.rgexValidator
  });

  factory FormInput.fromJson(Map<String, dynamic> json) {
    return FormInput(
      type: json['type'],
      name: json['name'],
      label: json['label'],
      rgexValidator: json['rgex_validator'],
      svg: json['svg'] != null ? base64.decode(json['svg'].split(',')[1]) : null,
      mask: json['mask'],
      required: json['required'] ?? false,
      placeholder: json['place_holder'],
    );
  }
}