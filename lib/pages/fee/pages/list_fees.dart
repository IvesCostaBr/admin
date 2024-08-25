import 'package:core_dashboard/controllers/fee.dart';
import 'package:core_dashboard/dtos/fee.dart';
import 'package:core_dashboard/shared/widgets/anothers/tags.dart';
import 'package:core_dashboard/shared/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListFeesPage extends StatefulWidget {
  @override
  _ListFeesPageState createState() => _ListFeesPageState();
}

class _ListFeesPageState extends State<ListFeesPage> {
  final FeeService _feeService = Get.find<FeeService>();

  @override
  Widget build(BuildContext context) {
    return 
        GenericContainer(
          text: "Taxas",
          content: FutureBuilder<List<FeeDTO>>(
            future: _feeService.getFees(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  children: [
                    SizedBox(height: 240),
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar Taxas'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhuma taxa encontrada'));
              } else {
                final fees = snapshot.data!;
                return  SingleChildScrollView(
                  scrollDirection: Axis.vertical,
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
                        DataColumn(label: Text('Valores')),
                        DataColumn(label: Text('Tipo')),
                        DataColumn(label: Text('Ações')),
                      ],
                      rows: fees.map((fee) {
                        return DataRow(
                          cells: [
                            DataCell(Text(fee.id)),
                            DataCell(Text(fee.createdAtFormated)),
                             DataCell(Text(fee.updatedAtFormated)),
                            DataCell(GestureDetector(
                              onTap: () {print("detail user");},
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: const BorderRadius.all(Radius.circular(12))
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  Text('Ver Valores'),
                                  SizedBox(width: 4,),
                                  Icon(Icons.remove_red_eye)
                                ],),
                              ),
                            )),
                            DataCell(classifyType(fee.action)),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.change_circle_outlined, color: Colors.green,),
                                    onPressed: () => {},
                                  ),
                                ],
                              )
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              }
            },
          ),
        );
  }

  Widget classifyType(int type){
    switch (type){
      case 1:
        return const PinTag(color: Colors.blueGrey, text: "PIX ENTRADA");
      case 2:
        return const PinTag(color: Colors.green, text: "PIX SAIDA");
      case 3:
        return const PinTag(color: Colors.grey, text: "CRIPTO ENTRADA");
      case 4:
        return const PinTag(color: Colors.orange, text: "CRIPTO SAIDA");
      case 5:
        return const PinTag(color: Colors.black, text: "BOLETO ENTRADA");
      case 6:
        return const PinTag(color: Colors.pink, text: "BOLETO SAIDA");
      default:
      return const Text('');
    }
  }
}