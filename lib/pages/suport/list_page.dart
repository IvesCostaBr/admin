import 'package:core_dashboard/controllers/chat.dart';
import 'package:core_dashboard/dtos/suport.dart';
import 'package:core_dashboard/pages/suport/message_page.dart';
import 'package:core_dashboard/shared/widgets/anothers/tags.dart';
import 'package:core_dashboard/shared/widgets/container.dart';
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
    return Column(
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
        Expanded(
          child: FutureBuilder<List<Support>>(
            future: _chatService.getSuports(_selectedStatus),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar suportes'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhum suporte encontrado'));
              } else {
                final supports = snapshot.data!;
                return GenericContainer(
                  content: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Data de Criação')),
                        DataColumn(label: Text('Data de Atualização')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: supports.map((support) {
                        return DataRow(
                          cells: [
                            DataCell(
                              GestureDetector(
                                child: Text(support.id),
                                onTap: () {
                                  Get.to(() => SupportChatPage(supportId: support.id));
                                },
                              ),
                            ),
                            DataCell(Text(DateFormat('dd/MM/yyyy HH:mm').format(support.createdAt!))),
                            DataCell(support.updatedAt != null
                                ? Text(DateFormat('dd/MM/yyyy HH:mm').format(support.updatedAt!))
                                : const Text('')),
                            DataCell(classifyStatus(support.status)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget classifyStatus(String status) {
    switch (status) {
      case "IN_OPEN":
        return const PinTag(color: Colors.yellow, text: "EM ABERTO");
      case "COMPLETED":
        return const PinTag(color: Colors.green, text: "FINALIZADO");
      case "IN_PROGRESS":
        return const PinTag(color: Colors.orange, text: "EM ATENDIMENTO");
      default:
        return const PinTag(color: Colors.grey, text: "SEM STATUS");
    }
  }
}

