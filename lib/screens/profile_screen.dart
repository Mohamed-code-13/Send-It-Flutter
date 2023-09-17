import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../services/chatting/change_profile_pic.dart';
import '../widgets/user_icon.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;

  String? email;

  // String? imageUrl;

  bool _uploading = false;

  @override
  void initState() {
    super.initState();

    User? user = FirebaseAuth.instance.currentUser;
    name = user!.displayName;
    email = user.email;
    // imageUrl = user!.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.purple),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _uploading,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  UserIcon(
                    size: 80,
                    imageUrl: FirebaseAuth.instance.currentUser!.photoURL,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _uploading = true;
                      });
                      await ProfilePictureUploader().uploadImage();
                      setState(() {
                        _uploading = false;
                        // imageUrl = user!.photoURL;
                      });
                    },
                    child: const Text("Change"),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _showField(context, "Username", name!),
              _showField(context, "Email", email!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showField(BuildContext context, String name, String data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: Theme.of(context).textTheme.bodyMedium),
          Text(data, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _getProfilePic() {
    User user = FirebaseAuth.instance.currentUser!;

    NetworkImage image = const NetworkImage(
      'https://firebasestorage.googleapis.com/v0/b/chat-app-dc281.appspot.com/o/profile_pictures%2FpersonLogo.jpg?alt=media&token=cef46837-a270-472b-8f8e-658e5775a233',
    );

    if (user.photoURL != null) {
      image = NetworkImage(user.photoURL!);
    }

    return CircleAvatar(
      radius: 80,
      backgroundImage: image,
    );
  }
}
