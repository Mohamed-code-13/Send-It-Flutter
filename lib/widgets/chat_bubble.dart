import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:send_it/screens/image_screen.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool friend;
  final Timestamp timestamp;
  final String? imageUrl;

  const ChatBubble({
    required this.text,
    required this.friend,
    required this.timestamp,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime serverDateTime = timestamp.toDate();
    final DateTime localDateTime = serverDateTime.toLocal();
    DateFormat dateFormat = DateFormat('HH:mm');

    String time = dateFormat.format(localDateTime);

    return Align(
      alignment: _getAlignment(),
      child: Column(
        crossAxisAlignment: _getCrossAxisAlignment(),
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
              minWidth: 1,
            ),
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: _getBackGroundColor(),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(22),
                topRight: const Radius.circular(22),
                bottomLeft: Radius.circular((friend) ? 0.0 : 22),
                bottomRight: Radius.circular((friend) ? 22 : 0.0),
              ),
            ),
            child: Column(
              children: [
                if (imageUrl != null)
                  GestureDetector(
                      onTap: () => Get.to(
                            () => ImageScreen(imgUrl: imageUrl!),
                            transition: Transition.topLevel,
                          ),
                      child: Image.network(imageUrl!)),
                if (imageUrl == null)
                  Text(
                    text,
                    style: TextStyle(fontSize: 18, color: _getTextColor()),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: (friend) ? 8.0 : 0.0, right: (friend) ? 0.0 : 8.0),
            child: Text(
              time,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTextColor() {
    if (friend) {
      return Colors.white;
    }
    return Colors.black;
  }

  Color _getBackGroundColor() {
    if (friend) {
      return Colors.purple;
    }
    return Colors.grey;
  }

  Alignment _getAlignment() {
    if (friend) return Alignment.centerLeft;
    return Alignment.centerRight;
  }

  CrossAxisAlignment _getCrossAxisAlignment() {
    if (friend) return CrossAxisAlignment.start;
    return CrossAxisAlignment.end;
  }
}
