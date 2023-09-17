import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:send_it/services/chatting/send_image.dart';
import 'package:send_it/services/chatting/send_messages.dart';
import 'package:send_it/widgets/chat_bubble.dart';

import '../services/chatting/picture_uploader.dart';

class ChatScreen extends StatefulWidget {
  final String title;
  final String id;

  const ChatScreen({
    super.key,
    required this.title,
    required this.id,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String user1_id = FirebaseAuth.instance.currentUser!.uid;
  late String user2_id;
  late String chatId;
  late Query<Map<String, dynamic>> messages;
  TextEditingController _controller = TextEditingController();
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    user2_id = widget.id;

    if (user1_id.hashCode <= user2_id.hashCode) {
      chatId = '$user1_id-$user2_id';
    } else {
      chatId = '$user2_id-$user1_id';
    }

    messages = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white, fontSize: 28),
        ),
        // backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _uploading,
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: messages.snapshots(),
                builder: (context, snapShot) {
                  if (snapShot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapShot.hasData) {
                    return Center(
                      child: Text(
                        'No users to add',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }

                  final msgs = snapShot.data!.docs;
                  return ListView.builder(
                    itemCount: msgs.length,
                    shrinkWrap: true,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final msg = msgs[index];
                      final text = msg['text'];
                      final sender = msg['sender'];
                      String? imgUrl;
                      try {
                        imgUrl = msg['img'];
                      } catch (e) {
                        imgUrl = null;
                      }

                      final currentTime = Timestamp.fromMicrosecondsSinceEpoch(
                          DateTime.now().millisecondsSinceEpoch);
                      final serverTimeStamp = (msg['timestamp'] == null)
                          ? currentTime
                          : msg['timestamp'];

                      return ChatBubble(
                        text: text,
                        friend: sender == user1_id,
                        timestamp: serverTimeStamp,
                        imageUrl: imgUrl,
                      );
                    },
                  );
                },
              )),
              _buildInputField()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Type a message',
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.purpleAccent,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.purple,
              width: 2.0,
            ),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              String message = _controller.text.trim();
              if (message.isNotEmpty) {
                sendMessage(user1_id, user2_id, message);
                _controller.clear();
              }
            },
            icon: const Icon(Icons.send),
            color: Colors.purpleAccent,
          ),
          prefixIcon: IconButton(
            onPressed: () async {
              setState(() {
                _uploading = true;
              });
              String? imageUrl = await PictureUploader().uploadImage(chatId);
              if (imageUrl != null) {
                sendImage(user1_id, user2_id, imageUrl);
              }
              setState(() {
                _uploading = false;
              });
            },
            icon: const Icon(Icons.add),
            color: Colors.purpleAccent,
          ),
        ),
      ),
    );
  }
}
