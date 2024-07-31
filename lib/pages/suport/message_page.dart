import 'package:core_dashboard/controllers/chat.dart';
import 'package:core_dashboard/dtos/chat.dart';
import 'package:core_dashboard/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class SupportChatPage extends StatefulWidget {
  final String supportId;

  const SupportChatPage({super.key, required this.supportId});

  @override
  _SupportChatPageState createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  final  _webSocketService = Get.find<ChatService>();
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

  Future<void> _sendFile(File file) async {
    final bytes = await file.readAsBytes();
    final base64File = base64Encode(bytes);
    final fileName = file.path.split('/').last;
    final fileMessage = {
      "event": "file",
      "data": {
        "base64": base64File,
        "name": fileName
      }
    };
    _webSocketService.sendMessage(jsonEncode(fileMessage));
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      await _sendFile(file);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      await _sendFile(file);
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
                          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
                            margin: const EdgeInsets.symmetric(vertical: 5.0),
                            decoration: BoxDecoration(
                              color: isMine ? Colors.blue[200] : Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(8.0),
                                topRight: const Radius.circular(8.0),
                                bottomLeft: isMine ? const Radius.circular(8.0) : const Radius.circular(0),
                                bottomRight: isMine ? const Radius.circular(0) : const Radius.circular(8.0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  message.senderName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  message.value,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  DateTime.fromMillisecondsSinceEpoch((message.createdAt * 1000).toInt()).toString(),
                                  style: const TextStyle(
                                    fontSize: 10.0,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _isChatClosed
                      ? const Center(
                          child: Text(
                            'O Atendimento foi finalizado',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        )
                      : Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: 'Digite sua mensagem...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    borderSide: const BorderSide(
                                      color: Colors.blue,
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400]!,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.attach_file),
                              onPressed: _pickFile,
                            ),
                            IconButton(
                              icon: const Icon(Icons.camera_alt),
                              onPressed: _pickImage,
                            ),
                            const SizedBox(width: 8.0),
                            ElevatedButton.icon(
                              onPressed: () => {_sendMessage(userData!["name"], userData["id"])},
                              icon: const Icon(Icons.send),
                              label: const Text('Enviar', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                ],
              )
            : Center(
                child: _errorMessage.isNotEmpty
                    ? Text(_errorMessage)
                    : const CircularProgressIndicator(),
              ),
      ),
    );
  }
}
