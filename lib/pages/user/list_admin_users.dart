import 'package:core_dashboard/common/routes_config.dart';
import 'package:core_dashboard/dtos/inputs/field_input.model.dart';
import 'package:core_dashboard/shared/helpers/modal_form.dart';
import 'package:core_dashboard/shared/helpers/table.dart';
import 'package:core_dashboard/shared/widgets/anothers/tags.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core_dashboard/controllers/user.dart';
import 'package:core_dashboard/dtos/user.dart';

class ListUsersAdminPage extends StatefulWidget {
  const ListUsersAdminPage({super.key});

  @override
  State<ListUsersAdminPage> createState() => _ListUsersAdminPageState();
}

class _ListUsersAdminPageState extends State<ListUsersAdminPage> {
  final userService = Get.find<UserService>();
  String selectedFilterKey = 'NOME';
  String filterValue = '';

  void _onAdd() {
    showDialog(
      context: context,
      builder: (context) => Dialog(child: SizedBox(width:620, child: FormModal(
        description: "Adicione os dados para criar um novo usuário admin.",
        function: userService.createUserAdmin,
        inputs: [
          InputModel(
            name: "email",
            hint: "E-mail",
            controller: TextEditingController()
          ),
          InputModel(
            name: "name",
            hint: "Nome",
            controller: TextEditingController()
          ),
          InputModel(
            name: "password",
            hint: "Senha",
            isObscure: true,
            controller: TextEditingController()
          ),
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
      child: FutureBuilder<List<UserDTO>>(
        future: userService.getUsersAdmin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar usuários: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum usuário encontrado.'));
          } else {
            final users = snapshot.data!;
            final rows = users.map((user) {
              return DataRow(
                cells: [
                  DataCell(GestureDetector(
                    child: Text(user.name ?? 'Nome não fornecido'),
                    onTap: () {
                      Get.toNamed(AppRouter.userDetail, arguments: {"user": user.toJson()});
                    },
                  )),
                  DataCell(Text(user.email)),
                  DataCell(Text(
                    user.createdAt != null
                        ? DateTime.fromMillisecondsSinceEpoch(user.createdAt!.toInt() * 1000).toString()
                        : '-',
                  )),
                  DataCell(PinTag(
                    color: user.isAdmin ? Colors.redAccent : Colors.grey,
                    text: user.isAdmin ? 'ADM' : 'Normal',
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
              title: 'Usuários Administradores',
              columns: const [
                DataColumn(label: Text('NOME')),
                DataColumn(label: Text('EMAIL')),
                DataColumn(label: Text('CRIADO EM')),
                DataColumn(label: Text('TIPO')),
                DataColumn(label: Text('AÇÕES')),
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
