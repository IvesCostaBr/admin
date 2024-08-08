import 'dart:ui';
import 'package:core_dashboard/dtos/screens.dart';
import 'package:flutter/material.dart';

class EditScreenForm extends StatefulWidget {
  final Screen screen;

  EditScreenForm({required this.screen});

  @override
  _EditScreenFormState createState() => _EditScreenFormState();
}

class _EditScreenFormState extends State<EditScreenForm> {
  late List<FormInput> inputs;

  @override
  void initState() {
    super.initState();
    inputs = widget.screen.inputs ?? [];
  }

  void addInput() {
    setState(() {
      inputs.add(FormInput(
        type: 'text',
        name: '',
        svg: null,
        mask: null,
        label: 'New Input',
        placeHolder: 'Enter text',
        required: false,
        rgexValidator: null,
      ));
    });
  }

  void removeInput(int index) {
    setState(() {
      inputs.removeAt(index);
    });
  }

  void saveChanges() {
    // Implement your logic to send the modified data
    print('Inputs saved: $inputs');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (widget.screen.backgroundImage != null)
            Image.network(
              widget.screen.backgroundImage!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          if (widget.screen.backgroundBlur ?? false)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          buildScreenContent(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addInput,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildScreenContent() {
    switch (widget.screen.type) {
      case 'static':
        return buildStaticScreen();
      case 'stepper_form':
        return buildStaticScreen(); // Exibir inputs sem o Stepper
      case 'stepper_page':
        return buildStepperPageScreen();
      default:
        return buildDefaultScreen();
    }
  }

  Widget buildStaticScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.screen.title != null)
            Text(
              widget.screen.title!['value'] ?? '',
              style: TextStyle(
                fontSize: widget.screen.title!['size']?.toDouble() ?? 16.0,
                fontWeight: widget.screen.title!['bold'] ?? false
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          if (widget.screen.description != null)
            Text(widget.screen.description!['value'] ?? ''),
          ...buildInputs(inputs),
          ElevatedButton(
            onPressed: saveChanges,
            child: Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  Widget buildStepperPageScreen() {
    return PageView(
      children: widget.screen.listData!.map((data) {
        return Column(
          children: [
            Image.network(data['image']),
            Text(data['title']),
            Text(data['description']),
            ElevatedButton(
              onPressed: () {
                if (data['button'] != null) {
                  final url = data['button']['action_link'];
                  if (url != null) {
                    // Launch URL logic here
                  }
                }
              },
              child: Text(data['button']['title']),
            ),
          ],
        );
      }).toList(),
    );
  }

  List<Widget> buildInputs(List<FormInput> inputs) {
    return inputs.asMap().entries.map((entry) {
      int index = entry.key;
      FormInput input = entry.value;
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: input.label),
                  decoration: InputDecoration(
                    labelText: 'Label',
                    hintText: input.placeHolder,
                  ),
                  onChanged: (value) {
                    setState(() {
                      input.label = value;
                    });
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => removeInput(index),
              ),
            ],
          ),
          TextField(
            controller: TextEditingController(text: input.name),
            decoration: InputDecoration(labelText: 'Name'),
            onChanged: (value) {
              setState(() {
                input.name = value;
              });
            },
          ),
          TextField(
            controller: TextEditingController(text: input.svg ?? ''),
            decoration: InputDecoration(labelText: 'SVG'),
            onChanged: (value) {
              setState(() {
                input.svg = value;
              });
            },
          ),
          TextField(
            controller: TextEditingController(text: input.mask ?? ''),
            decoration: InputDecoration(labelText: 'Mask'),
            onChanged: (value) {
              setState(() {
                input.mask = value;
              });
            },
          ),
          TextField(
            controller: TextEditingController(text: input.placeHolder),
            decoration: InputDecoration(labelText: 'Placeholder'),
            onChanged: (value) {
              setState(() {
                input.placeHolder = value;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Required'),
            value: input.required,
            onChanged: (value) {
              setState(() {
                input.required = value ?? false;
              });
            },
          ),
          TextField(
            controller: TextEditingController(text: input.rgexValidator ?? ''),
            decoration: InputDecoration(labelText: 'Regex Validator'),
            onChanged: (value) {
              setState(() {
                input.rgexValidator = value;
              });
            },
          ),
        ],
      );
    }).toList();
  }

  Widget buildDefaultScreen() {
    return const Center(
      child: Text("Unsupported screen type"),
    );
  }
}