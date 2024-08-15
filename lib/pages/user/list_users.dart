import 'dart:convert';

import 'package:core_dashboard/controllers/user.dart';
import 'package:core_dashboard/dtos/user.dart';
import 'package:core_dashboard/shared/widgets/anothers/tags.dart';
import 'package:core_dashboard/shared/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListUsersPage extends StatefulWidget {
  const ListUsersPage({super.key});

  @override
  State<ListUsersPage> createState() => _ListUsersPageState();
}

class _ListUsersPageState extends State<ListUsersPage> {
  final userService = Get.find<UserService>();

  @override
  Widget build(BuildContext context) {
    return GenericContainer(
      text: "Usuários",
      content: FutureBuilder<List<UserDTO>>(
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
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Avatar')),
                    DataColumn(label: Text('Nome')),
                    DataColumn(label: Text('Documento')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Data de Nascimento')),
                    DataColumn(label: Text('Criado em')),
                    DataColumn(label: Text('Tipo')),
                  ],
                  rows: users.map((user) {
                    return DataRow(cells: [
                      DataCell(
                        user.avatar != null && user.avatar!.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(base64Decode(user.avatar!)),
                              )
                            : const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                      ),
                      DataCell(Text(user.name ?? 'Nome não fornecido')),
                      DataCell(Text(user.document ?? 'Documento não fornecido')),
                      DataCell(Text(user.email)),
                      DataCell(Text(user.birthData ?? 'Data não fornecida')),
                      DataCell(Text(user.createdAt != null ? DateTime.fromMillisecondsSinceEpoch(user.createdAt!.toInt() * 1000).toString() : '')),
                      DataCell(PinTag(color: user.isAdmin ? Colors.redAccent : Colors.grey, text: user.isAdmin ? 'ADMIN' : 'NORMAL',)),
                    ]);
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
