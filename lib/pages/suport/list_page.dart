import 'package:core_dashboard/controllers/chat.dart';
import 'package:core_dashboard/dtos/suport.dart';
import 'package:core_dashboard/pages/suport/message_page.dart';
import 'package:core_dashboard/shared/widgets/anothers/tags.dart';
import 'package:core_dashboard/shared/widgets/container.dart';
import 'package:core_dashboard/shared/widgets/tabs/table_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SupportListPage extends StatefulWidget {
  @override
  _SupportListPageState createState() => _SupportListPageState();
}

class _SupportListPageState extends State<SupportListPage> {
  final ChatService _chatService = Get.find<ChatService>();
  String _selectedStatus = 'IN_OPEN';

  @override
  Widget build(BuildContext context) {
    return GenericContainer(
      text: "Atendimentos",
      content: FutureBuilder<List<Support>>(
        future: _chatService.getSuports(_selectedStatus),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Column(
              children: [
                SizedBox(height: 240),
                Center(child: CircularProgressIndicator()),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar suportes'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: DropdownButton<String>(
                      value: _selectedStatus,
                      items: const [
                        DropdownMenuItem(
                          value: 'IN_OPEN',
                          child: Text('EM ABERTO'),
                        ),
                        DropdownMenuItem(
                          value: 'COMPLETED',
                          child: Text('FINALIZADO'),
                        ),
                        DropdownMenuItem(
                          value: 'IN_PROGRESS',
                          child: Text('EM ATENDIMENTO'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value!;
                        });
                      },
                    ),
                  ),
                  const Center(child: Text('Nenhum suporte encontrado')),
                ],
              ),
            );
          } else {
            final supports = snapshot.data!;
            return ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: Scrollbar(
                  thumbVisibility: true,
                  trackVisibility: true,
                  interactive: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                              borderRadius: const BorderRadius.all(Radius.circular(5))
                          ),
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Data de Criação')),
                            DataColumn(label: Text('Data de Atualização')),
                            DataColumn(label: Text('Usuário')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Ação')),
                          ],
                          rows: supports.map((support) {
                            return DataRow(
                              cells: [
                                DataCell(Text(support.id)),
                                DataCell(Text(DateFormat('dd/MM/yyyy HH:mm').format(support.createdAt!))),
                                DataCell(support.updatedAt != null
                                    ? Text(DateFormat('dd/MM/yyyy HH:mm').format(support.updatedAt!))
                                    : const Text('-')),
                                DataCell(
                                  GestureDetector(
                                    onTap: () {
                                      print("detail user");
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(support.owner["name"] ?? '-'),
                                        Text(support.owner["document"] ?? '-'),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(classifyStatus(support.status)),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.phone, color: Colors.green),
                                    onPressed: () => Get.to(() => SupportChatPage(supportId: support.id)),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
            );
          }
        },
      ),
    );
  }

  Widget classifyStatus(String status) {
    switch (status) {
      case "IN_OPEN":
        return const PinTag(color: Colors.orange, text: "EM ABERTO");
      case "COMPLETED":
        return const PinTag(color: Colors.green, text: "FINALIZADO");
      case "IN_PROGRESS":
        return const PinTag(color: Colors.orange, text: "EM ATENDIMENTO");
      default:
        return const PinTag(color: Colors.grey, text: "SEM STATUS");
    }
  }
}
