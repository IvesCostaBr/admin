import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core_dashboard/controllers/config.dart';
import 'package:core_dashboard/pages/consumer/forms/screen_form.dart';
import 'package:core_dashboard/shared/widgets/container.dart';

class ConsumePagesConfigPage extends StatefulWidget {
  const ConsumePagesConfigPage({super.key});

  @override
  State<ConsumePagesConfigPage> createState() => _ConsumePagesConfigPageState();
}

class _ConsumePagesConfigPageState extends State<ConsumePagesConfigPage> {
  final configController = Get.find<ConfigController>();

  @override
  Widget build(BuildContext context) {
    final appData = configController.appData.value;

    return GenericContainer(
      text: "Telas",
      content: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // Desabilita o scroll interno
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6, // Número de colunas no grid
          crossAxisSpacing: 4.2, // Espaçamento horizontal entre os itens
          mainAxisSpacing: 1.8, // Espaçamento vertical entre os itens
          childAspectRatio: 1.2, // Proporção dos itens (largura/altura)
        ),
        itemCount: appData?.screens.length ?? 0,
        itemBuilder: (context, index) {
          final entry = appData!.screens.entries.elementAt(index);
          final screenName = entry.key;
          final screen = entry.value;

          return GestureDetector(
            onTap: () {
              Get.to(() => EditScreenForm(
                    initialData: screen.toJson(),
                    screeName: screenName,
                  ));
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), // Contorno cinza
                borderRadius: BorderRadius.circular(8), // Bordas arredondadas
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.screen_share, size: 40, color: Colors.grey), // Ícone no topo
                  const SizedBox(height: 10),
                  Text(
                    screenName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    screen.title?['value'] ?? 'No Title',
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
