import 'package:cloud_firestore/cloud_firestore.dart';

void sendImage(String sender, String recipient, String imgUrl) async {
  String chatId = '';
  String user1 = '';
  String user2 = '';

  if (sender.hashCode <= recipient.hashCode) {
    user1 = sender;
    user2 = recipient;
    chatId = '$sender-$recipient';
  } else {
    user1 = recipient;
    user2 = sender;
    chatId = '$recipient-$sender';
  }

  final messageData = {
    'sender': sender,
    'img': imgUrl,
    'text': '',
    'timestamp': FieldValue.serverTimestamp(),
  };

  await FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .add(messageData);
  await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
    'user1': user1,
    'user2': user2,
  });

  var temp1 =
      await FirebaseFirestore.instance.collection('users').doc(sender).get();
  var temp2 =
      await FirebaseFirestore.instance.collection('users').doc(recipient).get();

  String name1 = temp1['username'];
  String name2 = temp2['username'];
  await FirebaseFirestore.instance
      .collection('friends')
      .doc('$sender-$recipient')
      .set({
    'user1': sender,
    'user2': recipient,
    'name1': name1,
    'name2': name2,
    'lastMsg': "Photo",
    'sender': sender,
    'lastChatTimestamp': FieldValue.serverTimestamp(),
    'profile_picture': temp2['profile_picture'],
  });
  await FirebaseFirestore.instance
      .collection('friends')
      .doc('$recipient-$sender')
      .set({
    'user1': recipient,
    'user2': sender,
    'name1': name2,
    'name2': name1,
    'lastMsg': "Photo",
    'sender': sender,
    'lastChatTimestamp': FieldValue.serverTimestamp(),
    'profile_picture': temp1['profile_picture'],
  });
}
