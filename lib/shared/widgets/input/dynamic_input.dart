import 'package:core_dashboard/dtos/inputs/page_input.dart';
import 'package:flutter/material.dart';

class DynamicInputField extends StatelessWidget {
  final InputField input;

  const DynamicInputField({Key? key, required this.input}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (input.type) {
      case 'text':
        return TextField(
          decoration: InputDecoration(
            labelText: input.label,
            hintText: input.placeholder,
          ),
        );
      case 'obscure':
        return TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: input.label,
            hintText: input.placeholder,
          ),
        );
      // Adicione mais tipos de input conforme necessário
      default:
        return Container();
    }
  }
}

class DynamicPage extends StatelessWidget {
  final PageInput page;

  const DynamicPage({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(page.title ?? 'Dynamic Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (page.backgroundImage != null)
              Image.network(page.backgroundImage!),
            if (page.inputs != null)
              ...page.inputs!.map((input) => DynamicInputField(input: input)).toList(),
            // Adicione mais widgets conforme necessário
          ],
        ),
      ),
    );
  }
}