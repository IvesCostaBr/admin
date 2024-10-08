import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:core_dashboard/controllers/user.dart';
import 'package:core_dashboard/dtos/user/document.dart';
import 'package:core_dashboard/shared/widgets/anothers/snack.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:html' as html;
import 'package:video_player/video_player.dart';

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

class DocumentSection extends StatelessWidget {
  final String userId;
  final userService = Get.find<UserService>();

  DocumentSection({super.key, required this.userId});
  
  void _showActionModal(BuildContext context, DocumentDTO document) {
    showDialog(
      context: context,
      builder: (context) => Dialog(child: SizedBox(width:620, child: DocumentModalViewer(fileData: document))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text('Documentos', style: TextStyle(fontSize: 35),),
          FutureBuilder<List<DocumentDTO>>(
            future: userService.getDocuments(userId),
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  children: [
                    SizedBox(height: 240),
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar documentos'));
                
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhuma documento encontrado.'));
              } else {
                final documents = snapshot.data!;
                return GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 4.2,
                    mainAxisSpacing: 1.4,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final document = documents[index];
                    return GestureDetector(
                      onTap: (){
                        _showActionModal(context, document);
                      },
                      child: Card(
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
                            Positioned(
                              top: 8.0,
                              right: 8.0,
                              child: Icon(
                                Icons.person,
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
                                      document.name,
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
                                          document.id,
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
                                          if (document.isValidated) ...[
                                            const Icon(Icons.check_circle_outline, color: Colors.green,)
                                          ] else ...[
                                            const Icon(Icons.zoom_in, color: Colors.orange,)
                                          ],
                                          Column(
                                            children: [
                                              const Text('Enviado em', style: TextStyle(color: Colors.white, fontSize: 12)),
                                              Text(document.createdAtFormated, style: const TextStyle(color: Colors.white, fontSize: 12)),
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
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class DocumentModalViewer extends StatefulWidget {
  final DocumentDTO fileData;

  const DocumentModalViewer({required this.fileData});

  @override
  _DocumentModalViewerState createState() => _DocumentModalViewerState();
}

class _DocumentModalViewerState extends State<DocumentModalViewer> {
  final Rx<bool> isLoading = false.obs;
  VideoPlayerController? _videoPlayerController;
  RxBool isPlaying = false.obs;
  final userService = Get.find<UserService>();

  Future<bool> sendEvent() async {
    isLoading.value = true;
    final result = true;
    if (result) {
      snackSuccess("Disparado", "Evento enviado com sucesso!");
    } else {
      snackError("Erro ao enviar evento, tente novamente!");
    }
    isLoading.value = false;

    return result;
  }

  Future<void> _downloadFile(String base64Content, String fileName) async {
    if (GetPlatform.isWeb) {
      final bytes = base64Decode(base64Content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      try {
        await Permission.storage.request();
        if (await Permission.storage.request().isGranted) {
          final bytes = base64Decode(base64Content);
          final dir = await getExternalStorageDirectory();
          final file = File('${dir?.path}/$fileName');

          await file.writeAsBytes(bytes);

          snackSuccess('Download completo', 'Arquivo salvo em ${file.path}');
        } else {
          snackError('Permissão de armazenamento foi negada');
        }
      } catch (e) {
        snackError('Falha ao salvar o arquivo');
      }
    }
  }

  bool _isImage(String extension) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageExtensions.contains(extension.toLowerCase());
  }

  bool _isVideo(String extension) {
    return extension.toLowerCase() == 'mp4';
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.fileData.data['extension'] as String;
    final base64Content = widget.fileData.data['value'] as String;
    final fileExtension = fileName.split('.').last;

    final isImage = _isImage(fileExtension);
    final isVideo = _isVideo(fileExtension);

    if (isVideo) {
      final videoBytes = base64Decode(base64Content);
      _videoPlayerController = VideoPlayerController.network(
        'data:video/mp4;base64,${base64Encode(videoBytes)}',
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.share_outlined, size: 40),
          const Text('* Abaixo está o conteúdo enviado'),
          const SizedBox(height: 10),
          if (isImage)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageZoomViewer(
                      imageBytes: base64Decode(base64Content),
                    ),
                  ),
                );
              },
              child: Image.memory(
                base64Decode(base64Content),
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            )
          else if (isVideo)
            FutureBuilder(
              future: _videoPlayerController!.initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Obx(() => Column(
                      children: [
                        SizedBox(
                          height: 320,
                          width: double.infinity,
                          child: AspectRatio(
                            aspectRatio: _videoPlayerController!.value.aspectRatio,
                            child: VideoPlayer(_videoPlayerController!),
                          ),
                        ),
                        IconButton(
                          icon: Icon(isPlaying.value ? Icons.pause : Icons.play_arrow, size: 15),
                          onPressed: () async {
                            if (_videoPlayerController!.value.position == _videoPlayerController!.value.duration) {
                              _videoPlayerController?.seekTo(Duration.zero);
                            }
                            if (isPlaying.value) {
                              await _videoPlayerController?.pause();
                              isPlaying.value = false;
                            } else {
                              try{
                                await _videoPlayerController?.play();
                                isPlaying.value = true;
                              }catch (e){
                                setState(() {
                              });
                              isPlaying.value = false;
                              } 
                            }
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )
          else
            Column(
              children: [
                const Text('Nome do Arquivo'),
                Text(fileName),
                const SizedBox(height: 6,),
                ElevatedButton(
                  onPressed: () => _downloadFile(base64Content, fileName),
                  child: const Text("Baixar Arquivo"),
                ),
              ],
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () async => await _approveDocument(context),
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text("Aprovar"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              const SizedBox(width: 8,),
              ElevatedButton.icon(
                onPressed: () async => await _rejectDocument(context) ,
                icon: const Icon(Icons.cancel, color: Colors.white),
                label: const Text("Rejeitar"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _approveDocument(BuildContext context) async {
    final result = await userService.updateStatusDocument(widget.fileData.id, 2);
    if (!result){
      snackError('Erro ao aprovar documento tente novamente');
    }else{
      snackSuccess('Aprovado', 'Documento aprovado com sucesso');
      Navigator.pop(context);
    }
    
  }

  Future<void> _rejectDocument(BuildContext context) async {
    final result = await userService.updateStatusDocument(widget.fileData.id, 3);
    if (!result){
      snackError('Erro ao rejeitar documento tente novamente');
    }else{
      snackSuccess('Rejeitado', 'Documento rejeitado');
      Navigator.pop(context);
    }
    
  }
}


class ImageZoomViewer extends StatelessWidget {
  final Uint8List imageBytes;

  const ImageZoomViewer({required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar Imagem'),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true, // Permite arrastar a imagem
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.memory(imageBytes),
        ),
      ),
    );
  }
}
