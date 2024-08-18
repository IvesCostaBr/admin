import 'dart:io';

import 'package:core_dashboard/controllers/event.dart';
import 'package:core_dashboard/dtos/event.dart';
import 'package:core_dashboard/shared/widgets/anothers/snack.dart';
import 'package:core_dashboard/shared/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

Color generateRandomColor() {
  final random = Random();
  return Color.fromRGBO(
    random.nextInt(256), // Red
    random.nextInt(256), // Green
    random.nextInt(256), // Blue
    1.0, // Opacity (1.0 is fully opaque)
  );
}

List<Color> generateTwoRandomColors() {
  return [generateRandomColor(), generateRandomColor()];
}

class LisEventsPage extends StatefulWidget {
  const LisEventsPage({super.key});

  @override
  State<LisEventsPage> createState() => _LisEventsPageState();
}

class _LisEventsPageState extends State<LisEventsPage> {
  final eventService = Get.find<EventService>();
  
  void _showActionModal(BuildContext context, EventDTO action) {
    showDialog(
      context: context,
      builder: (context) => Dialog(child: SizedBox(width:620, child: ActionModal(action: action))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericContainer(
      text: "Eventos",
      content: FutureBuilder<List<EventDTO>>(
        future: eventService.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Column(
              children: [
                SizedBox(height: 240),
                Center(child: CircularProgressIndicator()),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar eventos: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum evento encontrado.'));
          } else {
            final events = snapshot.data!;
            return GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 4.2,
                mainAxisSpacing: 1.4,
                childAspectRatio: 1.5,
              ),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: generateTwoRandomColors(),
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      if (event.image.isNotEmpty)
                        Positioned.fill(
                          child: Image.network(
                            event.image,
                            fit: BoxFit.cover,
                            color: Colors.black.withOpacity(0.2),
                            colorBlendMode: BlendMode.darken,
                          ),
                        ),
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: Icon(
                          Icons.settings,
                          color: Colors.grey.withOpacity(0.4),
                          size: 120,
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    event.description,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14.0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _showActionModal(context, event);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: const Text('Configurar'),
                                    ),
                                    const Column(
                                      children: [
                                        Text('Última Atualização', style: TextStyle(color: Colors.white, fontSize: 12)),
                                        Text('02/06/2000 AM 12:45', style: TextStyle(color: Colors.white, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ActionModal extends StatefulWidget {
  final EventDTO action;

  const ActionModal({required this.action});

  @override
  _ActionModalState createState() => _ActionModalState();
}

class _ActionModalState extends State<ActionModal> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  final eventService = Get.find<EventService>();
  final Rx<bool> isLoading = false.obs;


  Future<bool> sendEvent() async{
    isLoading.value = true;
    final payload = {"data": _formData, "event_id": widget.action.id};
    final result = await eventService.sendEvent(payload);
    if(result){
      snackSuccess("Disparado", "Event enviado com sucesso!");
    }else{
      snackError("Erro ao enviar evento, tente novamente!");
    }
    isLoading.value = false;

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.share_outlined, size: 40,),
          const SizedBox(height: 10),
          Text(
            'Preencha as informações para disparar o evento ${widget.action.name}',
            style: const TextStyle(fontSize: 13,),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Icon(Icons.warning, color: Colors.orange,),
              Wrap(
                children: [Text(
                  'Esse evento vai ser enviado para todos os usuario online na plataforma!',
                  style: TextStyle(fontSize: 13,),
                ),]
              ),
            ],
          ),
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: Column(
              children: widget.action.requiredFields.map((field) {
                return Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: field),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, preencha o campo $field';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _formData[field] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8,)
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Obx((){
            return ElevatedButton(
              onPressed: !isLoading.value ? () async {
                if (_formKey.currentState!.validate()) {
                  await sendEvent();
                }
              } : null,
              child: isLoading.value ? const CircularProgressIndicator(): const Text('Disparar Evento'),
            );}
          )
        ],
      ),
    );
  }
}
