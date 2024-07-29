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

    return  GenericContainer(
        content: Container(
          height: 300,
          width: 400,
          child: ListView.builder(
            itemCount: appData?.screens.length ?? 0,
            itemBuilder: (context, index) {
              final entry = appData!.screens.entries.elementAt(index);
              final screenName = entry.key;
              final screen = entry.value;
                  
              return ListTile(
                title: Text(screenName),
                subtitle: Text(screen.title?['value'] ?? 'No Title'),
                onTap: () {
                  Get.to(() => EditScreenForm(screenName: screenName, screen: screen));
                },
              );
            },
          ),
        ),
    
    );
  }
}
