import 'package:core_dashboard/controllers/chat.dart';
import 'package:core_dashboard/dtos/suport.dart';
import 'package:core_dashboard/pages/suport/message_page.dart';
import 'package:core_dashboard/shared/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SupportListPage extends StatelessWidget {
  final ChatService _chatService = Get.find<ChatService>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Support>>(
      future: _chatService.getSuports(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar suportes'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum suporte encontrado'));
        } else {
          final supports = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(15),
            child: GenericContainer(
              content: ListView.builder(
                itemCount: supports.length,
                itemBuilder: (context, index) {
                  final support = supports[index];
                  return ListTile(
                    title: Text('Status: ${support.status}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Criado em: ${DateFormat('dd/MM/yyyy HH:mm').format(support.createdAt!)}'),
                        if (support.updatedAt != null)
                          Text('Atualizado em: ${DateFormat('dd/MM/yyyy HH:mm').format(support.updatedAt!)}'),
                      ],
                    ),
                    onTap: () {
                      Get.to(() => SupportChatPage(supportId: support.id));
                    },
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
