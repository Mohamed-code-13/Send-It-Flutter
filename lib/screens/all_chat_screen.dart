import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:send_it/models/friend.dart';
import 'package:send_it/screens/chat_screen.dart';
import 'package:rxdart/rxdart.dart';

import '../widgets/user_icon.dart';

class AllChatScreen extends StatefulWidget {
  const AllChatScreen({super.key});

  @override
  State<AllChatScreen> createState() => _AllChatScreenState();
}

class _AllChatScreenState extends State<AllChatScreen> {
  int activeIndex = 0;

  final String user1_id = FirebaseAuth.instance.currentUser!.uid;
  late Query<Map<String, dynamic>> query1;

  // late Stream<QuerySnapshot<Map<String, dynamic>>> query2;

  List<Friend> friends = [
    Friend(name: 'Mohamed Ashraf', lastMsg: 'Hello'),
    Friend(name: 'Mark Zuckerberg', lastMsg: 'How are you?'),
    Friend(name: 'Elon Musk', lastMsg: 'You wanna grab some pizza'),
    Friend(name: 'Bill Gates', lastMsg: 'Hey yo wassap'),
    Friend(
        name: 'Jeff Bezos',
        lastMsg:
            'Text me as soon as possible asdf  asdf m o la lk kasdfj io jfasd '),
  ];

  @override
  void initState() {
    super.initState();

    query1 = FirebaseFirestore.instance
        .collection('friends')
        .where('user1', isEqualTo: user1_id)
        .orderBy('lastChatTimestamp', descending: true);

    // query2 = FirebaseFirestore.instance
    //     .collection('friends')
    //     .where('user2', isEqualTo: user1_id)
    //     .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chats",
          style: TextStyle(
            color: Colors.purple,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: query1.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return Center(
                child: Text(
                  "You don't have any friends yet",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            final friendsDocs = snapshot.data!.docs;
            if (friendsDocs.isEmpty) {
              return Center(
                child: Text(
                  "You don't have any friends yet",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            return ListView.builder(
                itemCount: friendsDocs.length,
                itemBuilder: (context, index) {
                  final friendDoc = friendsDocs[index];
                  final user2 = friendDoc['user2'];
                  final friendId = user2;
                  final friendName = friendDoc['name2'];
                  final lastMsg = friendDoc['lastMsg'] ?? ' ';
                  final sender = (friendDoc['sender'] == user2);
                  final imageUrl = friendDoc['profile_picture'];

                  return _buildChat(
                    context,
                    lastMsg,
                    friendName,
                    friendId,
                    sender,
                    imageUrl,
                  );

                  // return FutureBuilder(
                  //     future: _getFriendImage(friendId),
                  //     builder: (ctx, snp) {
                  //       // if (snp.connectionState == ConnectionState.waiting) {
                  //       //   return const Center(
                  //       //       child: CircularProgressIndicator());
                  //       // }
                  //       if (snp.hasData) {
                  //         return _buildChat(
                  //           ctx,
                  //           lastMsg,
                  //           friendName,
                  //           friendId,
                  //           sender,
                  //           snp.data as String,
                  //         );
                  //       }
                  //       return const Center(child: Icon(Icons.person));
                  //     });
                });
          },
        ),
      ),
    );
  }

  Widget _buildChat(
    BuildContext context,
    String lastMsg,
    String name,
    String id,
    bool friend,
    String imageUrl,
  ) {
    String sender = (friend) ? name.split(' ')[0] : 'You';

    return Card(
      child: ListTile(
        title: Text(
          name,
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text(
          '$sender: $lastMsg',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: (friend) ? Colors.grey[600] : null,
            fontWeight: (friend) ? FontWeight.bold : null,
          ),
        ),
        leading: UserIcon(size: 25, imageUrl: imageUrl),
        // tileColor: Colors.orange,
        shape: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.purple, width: 2),
        ),
        onTap: () {
          Get.to(
            () => ChatScreen(title: name, id: id),
            transition: Transition.rightToLeft,
          );
        },
      ),
    );
  }

  _getFriendImage(String id) async {
    var user =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    var userData = user.data();
    return userData!['profile_picture'];
  }

  Stream<List<QueryDocumentSnapshot>> _getFriendStream() {
    final query1 = FirebaseFirestore.instance
        .collection('friends')
        .where('user1', isEqualTo: user1_id)
        .orderBy('lastChatTimestamp', descending: true)
        .snapshots();

    final query2 = FirebaseFirestore.instance
        .collection('friends')
        .where('user2', isEqualTo: user1_id)
        .orderBy('lastChatTimestamp', descending: true)
        .snapshots();

    final BehaviorSubject<List<QueryDocumentSnapshot>> _friendsSubject =
        BehaviorSubject<List<QueryDocumentSnapshot>>();

    query1.listen((querySnapshot1) {
      final List<QueryDocumentSnapshot> docs1 = querySnapshot1.docs;
      query2.listen((querySnapshot2) {
        final List<QueryDocumentSnapshot> docs2 = querySnapshot2.docs;
        _friendsSubject.add([...docs1, ...docs2]);
      });
    });

    return _friendsSubject.stream;
  }
}
