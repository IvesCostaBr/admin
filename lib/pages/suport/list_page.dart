import 'package:core_dashboard/controllers/chat.dart';
import 'package:core_dashboard/dtos/suport.dart';
import 'package:core_dashboard/pages/suport/message_page.dart';
import 'package:core_dashboard/shared/helpers/modal_confirm.dart';
import 'package:core_dashboard/shared/helpers/table.dart';
import 'package:core_dashboard/shared/widgets/anothers/tags.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


void _showConfirmModal(BuildContext context, VoidCallback action) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmModal(
        description: 'Esse chamado já vinculado a outro admin, você deseja entrar na conversa?',
        onConfirm: action,
      );
    },
  );
}

class SupportListPage extends StatefulWidget {
  @override
  _SupportListPageState createState() => _SupportListPageState();
}

class _SupportListPageState extends State<SupportListPage> {
  final ChatService _chatService = Get.find<ChatService>();
  String selectedFilterKey = 'NOME';
  String filterValue = '';

  void _onAdd() {
  }

  void _onExport() {
    // Lógica para exportar dados
  }

  void _onFilterChanged(String filter) {
  }

  void _onRowsPerPageChanged(int rowsPerPage) {
    // Lógica para alterar o número de linhas por página
  }

  void _onFilterKeyChanged(String? key) {
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)), 
      ),
      child: FutureBuilder<List<Support>>(
          future: _chatService.getSuports("IN_OPEN"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                children: [
                  SizedBox(height: 240),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar atendimentos'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Erro ao carregar atendimentos'));
            }else{
              final rows = snapshot.data!.map((suport) {          
                return DataRow(
                  cells: [
                    DataCell(Text(suport.id)),
                    DataCell(Text(DateFormat('dd/MM/yyyy HH:mm').format(suport.createdAt!))),
                    DataCell(suport.updatedAt != null
                        ? Text(DateFormat('dd/MM/yyyy HH:mm').format(suport.updatedAt!))
                        : const Text('-')),
                    DataCell(
                      GestureDetector(
                        onTap: () {
                          print("detail user");
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(suport.owner["name"] ?? '-'),
                            Text(suport.owner["document"] ?? '-'),
                          ],
                        ),
                      ),
                    ),
                    DataCell(suport.admin != null ? classifyStatus("IN_PROGRESS") : classifyStatus(suport.status)),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.phone, color: Colors.green),
                        onPressed: () => _showConfirmModal(
                          context, 
                          () => Get.to(() => SupportChatPage(supportId: suport.id)),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList();

            final columns = [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Data de Criação')),
              DataColumn(label: Text('Data de Atualização')),
              DataColumn(label: Text('Usuário')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Ação')),
            ];

            return CustomDataTable(
                title: 'Atendimentos',
                columns: columns,
                rows: rows,
                onAdd: _onAdd,
                onExport: _onExport,
                onFilterChanged: _onFilterChanged,
                onRowsPerPageChanged: _onRowsPerPageChanged,
                onFilterKeyChanged: _onFilterKeyChanged,
                filterKeys: ['NOME', 'EMAIL', 'TIPO'],
                selectedFilterKey: selectedFilterKey,
              );
            }
          }
        )  
    );
  }

  Widget classifyStatus(String status) {
    switch (status) {
      case "IN_OPEN":
        return const PinTag(color: Colors.blueAccent, text: "EM ABERTO");
      case "COMPLETED":
        return const PinTag(color: Colors.green, text: "FINALIZADO");
      case "IN_PROGRESS":
        return const PinTag(color: Colors.orange, text: "EM ATENDIMENTO");
      default:
        return const PinTag(color: Colors.grey, text: "SEM STATUS");
    }
  }
}
