import 'dart:convert';
import 'package:core_dashboard/controllers/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_editor_flutter/json_editor_flutter.dart';

class EditScreenForm extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final String screeName;

  EditScreenForm({required this.initialData, required this.screeName});

  @override
  _EditScreenFormState createState() => _EditScreenFormState();
}

class _EditScreenFormState extends State<EditScreenForm> {
  late String jsonString;
  final TextEditingController _screenNameController = TextEditingController();
  final TextEditingController _jsonController = TextEditingController();
  final configController = Get.find<ConfigController>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _screenNameController.text = widget.screeName;
    jsonString = jsonEncode(widget.initialData);
    _jsonController.text = jsonString;
  }

  _updateFormData() async {
    try {
      final decodedJson = jsonDecode(_jsonController.text);
      if (decodedJson is Map<String, dynamic>) {
        final result = await configController.updateScreen(_screenNameController.text, decodedJson);
        if (result) {
          Get.snackbar("Sucesso", "Pagina Atualizada", backgroundColor: Colors.green);
        } else {
          throw Exception("");
        }
      } else {
        Get.snackbar("Error", "Estrutura JSON Invalida", backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", "Erro ao realizar decoding: $e", backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor de tela'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Editar tela ${widget.screeName}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _screenNameController,
                decoration: const InputDecoration(
                  labelText: 'screen name',
                  hintText: 'nome da tela',
                ),
                // onChanged: (value) => _screenNameController.text = value
              ),
              const SizedBox(height: 12,),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 600, // Ajuste o valor conforme necessário
                ),
                child: JsonEditor(
                  enableHorizontalScroll: true,
                  enableKeyEdit: true,
                  enableValueEdit: true,
                  onChanged: (updatedText) {
                    setState(() {
                      jsonString = jsonEncode(updatedText);
                      _jsonController.text = jsonString;
                    });
                  },
                  json: jsonString,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  _updateFormData();
                },
                child: const Text('Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
