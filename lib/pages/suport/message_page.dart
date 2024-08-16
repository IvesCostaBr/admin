import 'dart:convert';
import 'dart:io' as io;
import 'dart:html';
import 'dart:typed_data';
import 'package:core_dashboard/controllers/chat.dart';
import 'package:core_dashboard/dtos/chat.dart';
import 'package:core_dashboard/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_platform/universal_platform.dart'; // Para verificar a plataforma

class SupportChatPage extends StatefulWidget {
  final String supportId;

  const SupportChatPage({super.key, required this.supportId});

  @override
  _SupportChatPageState createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  final _webSocketService = Get.find<ChatService>();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isConnected = false;
  String _errorMessage = '';
  List<Message> _messages = [];
  bool _isChatClosed = false;

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _connectToWebSocket() async {
    try {
      await _webSocketService.connectToWebSocket(widget.supportId);
      setState(() {
        _isConnected = true;
      });

      _webSocketService.channel!.stream.listen((message) {
        final decodedMessage = json.decode(message);
        if (decodedMessage['event'] == 'history') {
          final List<dynamic> history = decodedMessage['messages'];
          setState(() {
            _messages = history.map((msg) => Message.fromJson(msg)).toList();
            _scrollToBottom();
          });
        } else if (decodedMessage['event'] == 'closed') {
          _webSocketService.disconnect();
          setState(() {
            _isChatClosed = true;
          });
        } else {
          final newMessage = Message.fromJson(decodedMessage);
          setState(() {
            _messages.add(newMessage);
            _scrollToBottom();
          });
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao conectar ao WebSocket: $e';
      });
      print('Erro ao conectar ao WebSocket: $e');
    }
  }

  void _sendMessage(String senderName, String id) {
    if (_isChatClosed) return;

    final message = _messageController.text;
    if (message.isNotEmpty) {
      final messageObject = Message(
        event: 'message',
        value: message,
        createdAt: (DateTime.now().millisecondsSinceEpoch / 1000).round(),
        senderId: id,
        senderName: senderName,
      );
      _webSocketService.sendMessage(message);
      setState(() {
        _messages.add(messageObject);
      });
      _messageController.clear();
    }
  }

  Future<void> _sendFile(String senderName, String id, io.File file) async {
    final bytes = await file.readAsBytes();
    final base64File = base64Encode(bytes);
    final fileName = file.path.split('/').last;
    final fileExtension = fileName.split('.').last.toLowerCase();
    final messageObject = Message(
      event: 'file',
      createdAt: (DateTime.now().millisecondsSinceEpoch / 1000).round(),
      fileData: {
        "base64": base64File,
        "name": fileName,
        "extension": fileExtension
      },
      senderId: id,
      senderName: senderName,
    );

    _webSocketService.sendMessage(jsonEncode(messageObject.toJson()));
    setState(() {
      _messages.add(messageObject);
    });
  }

  Future<void> _pickFile(String userName, String userId) async {
    if (UniversalPlatform.isWeb) {
      // Web: Use FilePicker for web
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
          allowMultiple: false,
          onFileLoading: (FilePickerStatus status) => print(status),
          allowedExtensions: ['png', 'jpg', 'jpeg', 'heic']
      );
      if (picked != null) {
        final bytes = picked.files.single.bytes;
        await _sendFile(userName, userId, io.File.fromRawPath(bytes!));
    
      }
    } else {
      // Mobile: Use FilePicker for mobile
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        io.File file = io.File(result.files.single.path!);
        await _sendFile(userName, userId, file);
      }
    }
  }

  Future<void> _pickImage(String userName, String userId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      io.File file = io.File(pickedFile.path);
      await _sendFile(userName, userId, file);
    }
  }

  void _showFullImage(String base64Image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(base64Decode(base64Image)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _downloadFile(String base64File, String fileName) async {
    if (UniversalPlatform.isWeb) {
      // Web: Use dart:html to download the file
      final bytes = base64Decode(base64File);
      final blob = Blob([Uint8List.fromList(bytes)]);
      final url = Url.createObjectUrlFromBlob(blob);
      final anchor = AnchorElement(href: url)
        ..setAttribute("download", fileName)
        ..click();
      Url.revokeObjectUrl(url);
    } else {
      // Mobile: Show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download concluído: $fileName')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Get.find<UserProvider>();
    final userData = userProvider.userData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suporte'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isConnected
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isMine = message.senderId == userData!["id"];
                        return Align(
                          alignment: isMine
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 14.0),
                            margin: const EdgeInsets.symmetric(vertical: 5.0),
                            decoration: BoxDecoration(
                              color: isMine
                                  ? Colors.blue[200]
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(8.0),
                                topRight: const Radius.circular(8.0),
                                bottomLeft: isMine
                                    ? const Radius.circular(8.0)
                                    : const Radius.circular(0),
                                bottomRight: isMine
                                    ? const Radius.circular(0)
                                    : const Radius.circular(8.0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: isMine
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  message.senderName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                if (message.event == 'file' && message.fileData != null && ["jpg", "jpeg", "png"].contains(message.fileData!["extension"]))
                                  // Renderiza a imagem base64
                                  GestureDetector(
                                    onTap: () => _showFullImage(message.fileData!["base64"]!),
                                    child: Image.memory(
                                      base64Decode(message.fileData!["base64"]!),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                else if (message.event == 'file')
                                  // Renderiza o link para download do arquivo
                                  TextButton(
                                    onPressed: () {
                                      _downloadFile(
                                          message.fileData!["base64"]!,
                                          message.fileData!["name"]!,
                                      );
                                    },
                                    child: Text('Download ${message.fileData!["name"]}'),
                                  )
                                else
                                  Text(message.value),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (!_isChatClosed)
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () =>
                              _pickImage(userData!["name"], userData["id"]),
                        ),
                        IconButton(
                          icon: const Icon(Icons.attach_file),
                          onPressed: ()  async =>
                              await _pickFile(userData!["name"], userData["id"]),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Digite uma mensagem...',
                            ),
                            onSubmitted: (_) => _sendMessage(
                              userData!["name"],
                              userData["id"],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () => _sendMessage(
                            userData!["name"],
                            userData["id"],
                          ),
                        ),
                      ],
                    ),
                ],
              )
            : Center(
                child: Text(_errorMessage.isNotEmpty
                    ? _errorMessage
                    : 'Conectando...'),
              ),
      ),
    );
  }
}
