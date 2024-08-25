class Screens {
  Map<String, Screen> screens;
  
  Screens({required this.screens});

  factory Screens.fromJson(Map<String, dynamic> json) {
    Map<String, Screen> screens = {};
    for (final screen in json.keys) {
      screens[screen] = Screen.fromJson(json[screen]);
    }
    return Screens(screens: screens);
  }

  Map<String, dynamic> toJson() {
    return {
      "screens": screens.map((key, value) => MapEntry(key, value.toJson())),
    };
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
  final List<dynamic>? listData;
  final Map<String, dynamic>? location;

  Screen({
    this.title,
    this.backgroundImage,
    this.backgroundBlur = false,
    this.type,
    this.widgets,
    this.inputs,
    this.formSteps,
    this.listData,
    this.description,
    this.location,
  });

  factory Screen.fromJson(Map<String, dynamic> json) {
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
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "background_image": backgroundImage,
      "background_blur": backgroundBlur,
      "type": type,
      "inputs": inputs != null ? inputs!.map((input) => input.toJson()).toList() : null,
      "form_steps": formSteps != null ? formSteps!.map((step) => step.toJson()).toList() : null,
      "description": description,
      "widgets": widgets,
      "list_data": listData,
      "location": location,
    };
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

  static FormStep isEmpty() {
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

  Map<String, dynamic> toJson() {
    return {
      'step': step,
      'title': title,
      'description': description,
      'inputs': inputs.map((input) => input.toJson()).toList(),
    };
  }
}

class FormInput {
  String? type;
  String? name;
  String label;
  String? placeHolder;
  bool? required;
  String? mask;
  String? svg;
  String? rgexValidator;

  FormInput({
    this.type,
    this.name,
    required this.label,
    this.placeHolder,
    this.required,
    this.mask,
    this.svg,
    this.rgexValidator,
  });

  factory FormInput.fromJson(Map<String, dynamic> json) {
    return FormInput(
      type: json['type'],
      name: json['name'],
      label: json['label'],
      placeHolder: json['place_holder'],
      required: json['required'],
      mask: json['mask'],
      svg: json['svg'],
      rgexValidator: json['rgex_validator'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'label': label,
      'place_holder': placeHolder,
      'required': required,
      'mask': mask,
      'svg': svg,
      'rgex_validator': rgexValidator,
    };
  }
}
