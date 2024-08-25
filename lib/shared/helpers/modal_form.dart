import 'package:core_dashboard/dtos/inputs/field_input.model.dart';
import 'package:core_dashboard/shared/widgets/anothers/snack.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class FormModal extends StatefulWidget {
  final String description;
  final List<InputModel> inputs;
  final Future<bool> Function(Map<String, dynamic>) function;

  FormModal({
    required this.inputs,
    required this.description,
    required this.function, // A função assíncrona é passada por argumento
  });

  @override
  // ignore: library_private_types_in_public_api
  _FormModalState createState() => _FormModalState();
}

class _FormModalState extends State<FormModal> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  final Rx<bool> isLoading = false.obs;


  Future<void> sendEvent(context) async {
    try {
      isLoading.value = true;
      final result = await widget.function(_formData); 
      if(result){
        snackSuccess("Enviado", "Formulario Enviado");
        Navigator.pop(context);
      }else{
        snackError("Erro ao enviar Formulario, tente novamente!");
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
              const Icon(Icons.warning, color: Colors.orange,),
              const SizedBox(width: 12,),
              Wrap(
                children: [Text(
                  widget.description,
                  style: const TextStyle(fontSize: 16,),
                ),]
              ),
            ],
          ),
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: Column(
              children: widget.inputs.map((field) {
                return Column(
                  children: [
                    TextFormField(
                      obscureText: field.isObscure,
                      decoration: InputDecoration(labelText: field.hint),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, preencha o campo ${field.hint}';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _formData[field.name] = value;
                        });
                      },
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
