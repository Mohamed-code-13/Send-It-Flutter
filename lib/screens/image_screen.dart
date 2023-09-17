import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final String imgUrl;

  const ImageScreen({required this.imgUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
        child: Image.network(imgUrl),
      )),
    );
  }
}
