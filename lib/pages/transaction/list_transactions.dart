import 'dart:ui';

import 'package:core_dashboard/controllers/transaction.dart';
import 'package:core_dashboard/dtos/transaction.dart';
import 'package:core_dashboard/shared/widgets/anothers/tags.dart';
import 'package:core_dashboard/shared/widgets/container.dart';
import 'package:core_dashboard/shared/widgets/tabs/table_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ListTransactionsPage extends StatefulWidget {
  const ListTransactionsPage({super.key});

  @override
  State<ListTransactionsPage> createState() => _ListTransactionsPageState();
}

class _ListTransactionsPageState extends State<ListTransactionsPage> {
  final transactionService = Get.find<TransactionService>();

  @override
  Widget build(BuildContext context) {
    Widget getPinTag(int status, String text) {
      switch (status) {
        case 0:
          return PinTag(
            color: Colors.orange,
            text: text,
          );

        case 1:
          return PinTag(
            color: Colors.green,
            text: text,
          );
        case 2:
          return PinTag(
            color: Colors.orange,
            text: text,
          );
        case 3:
          return PinTag(
            color: Colors.grey,
            text: text,
          );
        case 4:
          return PinTag(
            color: Colors.red,
            text: text,
          );
        default:
          return const Text('');
      }
    }

    Widget getAction(String action) {
      if (action == 'CASH_OUT') {
        return const PinTag(
          color: Colors.red,
          text: "Saida",
        );
      } else {
        return const PinTag(
          color: Colors.green,
          text: "Entrada",
        );
      }
    }

    return GenericContainer(
      text: "Transações",
      content: FutureBuilder<List<TransactionDTO>>(
        future: transactionService.getTransactions(),
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
            return Center(
                child: Text('Erro ao carregar transações: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Se não houver dados ou a lista estiver vazia, exibe uma mensagem apropriada
            return const Center(child: Text('Nenhuma transação encontrado.'));
          } else {
            // Quando os dados estiverem prontos, exibe a tabela de usuários
            final transactions = snapshot.data!;
            return ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
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
                          DataColumn(label: Text('Ação')),
                          DataColumn(label: Text('Criado em')),
                          DataColumn(label: Text('Ultima Atualização')),
                          DataColumn(label: Text('Tipo')),
                          DataColumn(label: Text('Descrição')),
                          DataColumn(label: Text('Usuário')),
                          DataColumn(label: Text('Valor')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: transactions.map((transaction) {
                          return DataRow(
                            cells: [
                            DataCell(Text(transaction.id)),
                            DataCell(getAction(transaction.action)),
                            DataCell(Text(transaction.createdAtFormated)),
                            DataCell(Text(transaction.updatedAtFormated)),
                            DataCell(Text(transaction.typeFormated)),
                            DataCell(Text(transaction.description != null
                                ? transaction.description!
                                : transaction.generateDescription)),
                            DataCell(transaction.owner != null
                                ? Column(
                                    children: [
                                      Text(transaction.owner!.name ?? ''),
                                      Text(transaction.owner!.email ?? ''),
                                    ],
                                  )
                                : Text('-')),
                            DataCell(Text(transaction.toMonetary())),
                            DataCell(getPinTag(
                                transaction.status, transaction.statusFormated)),
                          ]);
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
}
