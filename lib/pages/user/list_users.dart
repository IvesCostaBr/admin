import 'package:core_dashboard/common/routes_config.dart';
import 'package:core_dashboard/controllers/user.dart';
import 'package:core_dashboard/dtos/user.dart';
import 'package:core_dashboard/shared/helpers/table.dart';
import 'package:core_dashboard/shared/widgets/anothers/tags.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListUsersPage extends StatefulWidget {
  const ListUsersPage({super.key});

  @override
  State<ListUsersPage> createState() => _ListUsersPageState();
}

class _ListUsersPageState extends State<ListUsersPage> {
  final userService = Get.find<UserService>();
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
      child: FutureBuilder<List<UserDTO>>(
        future: userService.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Enquanto o Future está sendo resolvido, exibe um indicador de progresso
                            return const Column(
                  children: [
                    SizedBox(height: 240),
                    Center(child: CircularProgressIndicator()),
                  ],
                );
          } else if (snapshot.hasError) {
            // Se ocorrer um erro, exibe uma mensagem de erro
            return Center(child: Text('Erro ao carregar usuários: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Se não houver dados ou a lista estiver vazia, exibe uma mensagem apropriada
            return const Center(child: Text('Nenhum usuário encontrado.'));
          } else {
            // Quando os dados estiverem prontos, exibe a tabela de usuários
            final users = snapshot.data!;

            final rows = users.map((user) {          
              return DataRow(
                cells: [
                DataCell(
                  GestureDetector(
                    child: Text(user.name ?? 'Nome não fornecido'),
                    onTap: () {
                      Get.toNamed(AppRouter.userDetail, arguments: {"user": user.toJson()});
                })),
                DataCell(Text(user.document ?? 'Documento não fornecido')),
                DataCell(Text(user.email)),
                DataCell(Text(user.birthData ?? 'Data não fornecida')),
                DataCell(Text(user.createdAt != null ? DateTime.fromMillisecondsSinceEpoch(user.createdAt!.toInt() * 1000).toString() : '')),
                DataCell(PinTag(color: user.isAdmin ? Colors.redAccent : Colors.grey, text: user.isAdmin ? 'Admin' : 'Normal',)),
              ]);
            }).toList();

            return CustomDataTable(
              title: 'Usuários',
              columns: const [
                DataColumn(label: Text('NOME')),
                DataColumn(label: Text('DOCUMENTO')),
                DataColumn(label: Text('EMAIL')),
                DataColumn(label: Text('DATA DE NASCIMENTO')),
                DataColumn(label: Text('CRIADO EM')),
                DataColumn(label: Text('TIPO')),
              ],
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
        },
      ),
    );
  }
}
