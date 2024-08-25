import 'package:core_dashboard/common/routes_config.dart';
import 'package:core_dashboard/controllers/config.dart';
import 'package:core_dashboard/dtos/consumer.dart';
import 'package:core_dashboard/shared/helpers/model_json.dart';
import 'package:core_dashboard/shared/helpers/table.dart';
import 'package:core_dashboard/shared/widgets/anothers/tags.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ListConsumerPage extends StatefulWidget {
  const ListConsumerPage({super.key});

  @override
  State<ListConsumerPage> createState() => _ListConsumerPageState();
}

class _ListConsumerPageState extends State<ListConsumerPage> {
  final configController = Get.find<ConfigController>();
  String selectedFilterKey = 'NOME';
  String filterValue = '';

  void _onAdd() {
    showDialog(
      context: context,
      builder: (context) => Dialog(child: SizedBox(width:620, child: FormModalWithJsonEditor(
        description: "Adicione os dados para criar um novo usuário admin.",
        function: configController.createConsumer,
        jsonEditors: [
          JsonEditorObj(label: "Consumer", initialData: {})
        ],
      ))),
    );
  }

  void _onExport() {
    // Lógica para exportar dados
  }

  void _onFilterChanged(String filter) {
    setState(() {
      filterValue = filter;
    });
  }

  void _onRowsPerPageChanged(int rowsPerPage) {
    // Lógica para alterar o número de linhas por página
  }

  void _onFilterKeyChanged(String? key) {
    if (key != null) {
      setState(() {
        selectedFilterKey = key;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)), 
      ),
      child: FutureBuilder<List<MinimunConsumer>>(
        future: configController.getConsumers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar consumers: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum consumer encontrado.'));
          } else {
            final consumers = snapshot.data!;
            final rows = consumers.map((consumer) {
              return DataRow(
                cells: [
                  DataCell(GestureDetector(
                    child: Text(consumer.id),
                    onTap: () {
                      Get.toNamed(AppRouter.userDetail, arguments: {"user": ''});
                    },
                  )),
                  DataCell(Text(consumer.name)),
                  DataCell(Text(
                    consumer.createdAt != null
                        ? consumer.createdAtFormated
                        : '-',
                  )),
                  DataCell(PinTag(
                    color: Colors.green,
                    text: 'ATIVADO',
                  )),
                  DataCell(Row(
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.delete))
                    ],
                  ))
                ],
              );
            }).toList();
      
            return CustomDataTable(
              title: 'Consumers',
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('NOME')),
                DataColumn(label: Text('CRIADO EM')),
                DataColumn(label: Text('STATUS')),
                DataColumn(label: Text('AÇÕES')),
              ],
              rows: rows,
              onAdd: _onAdd,
              onExport: _onExport,
              onFilterChanged: _onFilterChanged,
              onRowsPerPageChanged: _onRowsPerPageChanged,
              onFilterKeyChanged: _onFilterKeyChanged,
              filterKeys: ['ID', 'NOME', 'STATUS'],
              selectedFilterKey: selectedFilterKey,
            );
          }
        },
      ),
    );
  }
}
