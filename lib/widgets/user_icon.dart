import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget {
  final double size;
  final String? imageUrl;
  const UserIcon({super.key, required this.size, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    print('Updating');

    NetworkImage image = const NetworkImage(
      'https://firebasestorage.googleapis.com/v0/b/chat-app-dc281.appspot.com/o/profile_pictures%2FpersonLogo.jpg?alt=media&token=cef46837-a270-472b-8f8e-658e5775a233',
    );

    if (imageUrl != null) {
      image = NetworkImage(imageUrl!);
    }

    return CircleAvatar(
      radius: size,
      backgroundImage: image,
    );
  }
}
