import 'package:core_dashboard/dtos/screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditScreenForm extends StatefulWidget {
  final String screenName;
  final Screen screen;

  const EditScreenForm({Key? key, required this.screenName, required this.screen}) : super(key: key);

  @override
  _EditScreenFormState createState() => _EditScreenFormState();
}

class _EditScreenFormState extends State<EditScreenForm> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.screen.title?['value'] ?? '');
    _descriptionController = TextEditingController(text: widget.screen.description?['value'] ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedScreen = Screen(
      title: {'value': _titleController.text},
      description: {'value': _descriptionController.text},
      backgroundImage: widget.screen.backgroundImage,
      backgroundBlur: widget.screen.backgroundBlur,
      type: widget.screen.type,
      inputs: widget.screen.inputs,
      formSteps: widget.screen.formSteps,
      widgets: widget.screen.widgets,
      listData: widget.screen.listData,
      location: widget.screen.location,
    );

    // Atualizar a tela na lista e retornar para a tela anterior
    Get.back(result: updatedScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Screen: ${widget.screenName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            // Adicione mais campos conforme necessário
          ],
        ),
      ),
    );
  }
}
