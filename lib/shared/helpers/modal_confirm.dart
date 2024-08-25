import 'package:flutter/material.dart';

class ConfirmModal extends StatelessWidget {
  final String description;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmModal({
    required this.description,
    required this.onConfirm,
    this.onCancel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmação'),
      content: Wrap(
        children: [Text(
          description,
          style: const TextStyle(fontSize: 16,),
        ),]
      ),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: const Text('Voltar', style: TextStyle(color: Colors.black),),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();  // Fechar o modal
            onConfirm();  // E
          },
          child: const Text('Continuar'),
        ),
      ],
    );
  }
}
