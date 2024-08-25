import 'dart:convert';

import 'package:core_dashboard/shared/widgets/anothers/snack.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_editor_flutter/json_editor_flutter.dart';

class JsonEditorObj {
  final String label;
  final Map<String, dynamic> initialData;

  JsonEditorObj({
    required this.label,
    required this.initialData,
  });
}

// ignore: must_be_immutable
class FormModalWithJsonEditor extends StatefulWidget {
  final String description;
  final List<JsonEditorObj> jsonEditors;
  final Future<bool> Function(Map<String, dynamic>) function;

  FormModalWithJsonEditor({
    required this.jsonEditors,
    required this.description,
    required this.function,
  });

  @override
  _FormModalWithJsonEditorState createState() =>
      _FormModalWithJsonEditorState();
}

class _FormModalWithJsonEditorState extends State<FormModalWithJsonEditor> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  final Rx<bool> isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    for (var editor in widget.jsonEditors) {
      _formData[editor.label] = editor.initialData;
    }
  }

  Future<void> sendEvent(BuildContext context) async {
    try {
      
      Map<String, dynamic> payload = {};
      for (var each in _formData.keys.toList()){
        payload[each] = jsonDecode(_formData[each]);
      }
      isLoading.value = true;
      final result = await widget.function(payload);
      if (result) {
        snackSuccess("Enviado", "Formulário Enviado");
        Navigator.pop(context);
      } else {
        snackError("Erro ao enviar Formulário, tente novamente!");
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.warning, color: Colors.orange),
              const SizedBox(width: 12),
              Wrap(
                children: [
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: Column(
              children: widget.jsonEditors.map((editor) {
                return Column(
                  children: [
                    Text(
                      editor.label,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SingleChildScrollView(
                      child: SizedBox(
                        height: 300, // ou um valor adequado para sua UI
                        child: JsonEditor(
                          enableHorizontalScroll: true,
                          enableKeyEdit: true,
                          enableValueEdit: true,
                          onChanged: (updatedText) {
                            setState(() {
                              try {
                                _formData[editor.label] = jsonEncode(updatedText);
                              } catch (e) {
                                print('error: $e');
                              }
                            });
                          },
                          json: jsonEncode(editor.initialData),
                        ),
                      ),
                    ),  
                    const SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Obx(() {
            return ElevatedButton(
              onPressed: !isLoading.value
                  ? () async {
                      if (_formKey.currentState!.validate()) {
                        await sendEvent(context);
                      }
                    }
                  : null,
              child: isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text('Enviar'),
            );
          }),
        ],
      ),
    );
  }
}
