import 'dart:convert';

import 'package:core_dashboard/controllers/config.dart';
import 'package:core_dashboard/dtos/deploy.dart';
import 'package:core_dashboard/shared/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ConsumerDetailPage extends StatefulWidget {
  const ConsumerDetailPage({super.key});

  @override
  State<ConsumerDetailPage> createState() => _ConsumerDetailPageState();
}

class _ConsumerDetailPageState extends State<ConsumerDetailPage> {
  final ConfigController configController = Get.find<ConfigController>();
  bool isExecRequest = false;
  @override
  Widget build(BuildContext context) {
    final data = configController.appData.value;
    return GenericContainer(
      text: "Detalhes Consumer",
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: 
            Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Image.memory(base64Decode(data!.data.logo), fit: BoxFit.cover,)),            
                    ListTile(
                      title: const Text('Nomde do Aplicativo'),
                      subtitle: Text(data.data.appName),
                    ),
                    const SizedBox(height: 6),
                    ListTile(
                      title: const Text('Descrição'),
                      subtitle: Text(data.data.description),
                    ),
                    const SizedBox(height: 6),
                    ListTile(
                      title: const Text('CNPJ'),
                      subtitle: Text(data.data.nifName),
                    ),
                    const SizedBox(height: 6),
                    ListTile(
                      title: const Text('Versão'),
                      subtitle: Text(data.data.version),
                    ),
                    const SizedBox(height: 6),
                    ListTile(
                      title: const Text('Tela de Inicio'),
                      subtitle: Text(data.data.homePage),
                    ),
                                ],
                                ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Acessar Aplicação'),
                        const SizedBox(height: 12),
                        Column(children: [
                          const Text('WEB'),
                          QrImageView(
                            data: 'https://${data.name}-ivcs.web.app',
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                        ],),
                        Column(children: [
                          const Text('Lojas'),
                          QrImageView(
                            data: 'https://${data.name}-ivcs.web.app',
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                        ],)
                        
                      ],
                    ),
                  ),
                ],
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12,),
                Row(
                  children: [
                    const Text('Histórico de Deploy', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(onPressed: !isExecRequest ? () async {
                      setState(() {
                        isExecRequest = true;
                      });
                      await configController.execDeploy(data.consumerId);
                      setState(() {
                        isExecRequest = false;
                      });
                    } : null, icon: const Icon(Icons.system_update_rounded))
                  ],
                ),
                const SizedBox(height: 12,),
              ],
            ),
            FutureBuilder<List<DeployDTO>>(
              future: configController.getDeploys(data!.consumerId),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Column(
                    children: [
                      SizedBox(height: 50,),
                      Center(child: CircularProgressIndicator(),),
                    ],
                  );
                }else if (snapshot.data == null || snapshot.data!.isEmpty){
                  return const Text('Não foi executado nenhum deploy.');
            
                }else if (snapshot.hasError){
                  return const Text('Erro ao buscar deploys');
                }else {
                  final deploys = snapshot.data!.reversed.toList();
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Wrap( // Substituindo Row por Wrap
                      spacing: 6.0, // Espaçamento horizontal entre os itens
                      runSpacing: 5.0, // Espaçamento vertical entre as linhas
                      children: List.generate(deploys.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5, right: 6, left: 6),
                          child: Container(
                            width: 160,
                            decoration: BoxDecoration(
                              color: Get.isDarkMode ? Colors.white : Colors.black,
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.isDarkMode ? Colors.white : Colors.black,
                                  offset: const Offset(0.2, 0.5)
                                )
                              ]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    classifyDeployIcon(deploys[index].status),
                                    color: classifyDeployColor(deploys[index].status),
                                  ),
                                  const SizedBox(width: 8,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        classifyStatusDeploy(deploys[index].status),
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      Text(deploys[index].createdAtFormated, style: const TextStyle(fontSize: 12, color: Colors.white)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );

                    }
                  }),

                  
              ],
            )
      )
    );
  }

  IconData classifyDeployIcon(String githubStatus){
    switch (githubStatus){
      case 'completed':
        return Icons.check_circle_outline;
      case 'in_progress':
        return Icons.watch_later_outlined;
      case 'queued':
        return Icons.arrow_circle_left_outlined;
      default:
        return Icons.error_outline;
    }
  }



  Color classifyDeployColor(String githubStatus){
    switch (githubStatus){
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'queued':
        return Colors.blueAccent;
      default:
        return Colors.red;
    }
  }


  String classifyStatusDeploy(String githubStatus){
    switch (githubStatus){
      case 'completed':
        return 'Concluido';
      case 'in_progress':
        return 'Em Execução';
      case 'queued':
        return 'Na fila';
      default:
        return 'Error';
    }
  }
}