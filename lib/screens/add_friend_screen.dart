import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/user_icon.dart';
import 'chat_screen.dart';

class AddFriendScreen extends StatelessWidget {
  final snapShot = FirebaseFirestore.instance.collection('users').where(
        'email',
        isNotEqualTo: FirebaseAuth.instance.currentUser!.email!,
      );

  AddFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Friend",
          style: TextStyle(fontSize: 24),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: snapShot.get(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData) {
            return Center(
              child: Text(
                'No users to add',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          final users = snap.data!.docs;
          return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final username = user['username'];
                String id = user.reference.id;
                String? imageUrl = user['profile_picture'];

                return _buildFriendCard(context, username, id, imageUrl);
              });
        },
      ),
    );
  }

  Widget _buildFriendCard(
    BuildContext context,
    String username,
    String id,
    String? imageUrl,
  ) {
    return Card(
      child: ListTile(
        leading: UserIcon(size: 25, imageUrl: imageUrl),
        title: Text(username, style: Theme.of(context).textTheme.bodyLarge),
        onTap: () {
          Get.off(
            () => ChatScreen(title: username, id: id),
            transition: Transition.rightToLeft,
          );
        },
      ),
    );
  }
}
