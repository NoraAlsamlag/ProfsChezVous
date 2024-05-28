// pages/discussion_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profschezvousfrontend/api/message/message_api.dart';
import 'dart:async';
import 'dart:io';
import '../../models/message_model.dart';

class DiscussionPage extends StatefulWidget {
  final int adminId;
  final String adminName;

  DiscussionPage({required this.adminId, required this.adminName});

  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  final TextEditingController _controller = TextEditingController();
  final MessageApi _messageService = MessageApi();
  late Future<List<Message>> futureMessages;
  final ScrollController _scrollController = ScrollController();
  String? errorMessage;
  bool isLoading = false;
  File? _imageFile;
  late Timer _timer;
  bool _timerInitialized = false;

  @override
  void initState() {
    super.initState();
    futureMessages = _messageService.fetchMessages();
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        futureMessages = _messageService.fetchMessages();
      });
    });
    _timerInitialized = true;
  }

  @override
  void dispose() {
    if (_timerInitialized) {
      _timer.cancel();
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty || _imageFile != null) {
      try {
        setState(() {
          isLoading = true;
        });
        String? imageUrl;
        if (_imageFile != null) {
          imageUrl = await _messageService.uploadImage(_imageFile!);
          _imageFile = null;
        }
        await _messageService.sendMessage(_controller.text, widget.adminId,
            imageUrl: imageUrl);
        setState(() {
          futureMessages = _messageService.fetchMessages();
          _controller.clear();
          errorMessage = null;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.adminName),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Message>>(
              future: futureMessages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun message trouvé'));
                } else {
                  // Trier les messages par date
                  snapshot.data!
                      .sort((a, b) => a.dateEnvoi.compareTo(b.dateEnvoi));
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _scrollToBottom());
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Message message = snapshot.data![index];
                      bool isSent = message.expediteur == widget.adminId;
                      return ListTile(
                        title: Align(
                          alignment: isSent
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSent ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: isSent
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                if (message.imageUrl != null) ...[
                                  Image.network(message.imageUrl!),
                                  SizedBox(height: 5),
                                ],
                                Text(
                                  message.contenu,
                                  style: TextStyle(
                                      color:
                                          isSent ? Colors.white : Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        subtitle: Align(
                          alignment: isSent
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Text(
                            DateFormat('dd/MM/yyyy HH:mm')
                                .format(message.dateEnvoi),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (errorMessage != null) ...[
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 8),
                ],
                if (_imageFile != null) ...[
                  Image.file(_imageFile!),
                  SizedBox(height: 8),
                ],
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.image),
                      onPressed: _pickImage,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration:
                            InputDecoration(hintText: 'Écrire un message'),
                      ),
                    ),
                    IconButton(
                      icon: isLoading
                          ? CircularProgressIndicator()
                          : Icon(Icons.send),
                      onPressed: isLoading ? null : _sendMessage,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
