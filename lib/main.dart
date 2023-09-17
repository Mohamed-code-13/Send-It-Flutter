import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:send_it/screens/main_screen.dart';

import 'firebase_options.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ChatApp());
}

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  Widget initPage = const LoginScreen();
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? currUser;

  @override
  void initState() {
    super.initState();
    try {
      currUser = auth.currentUser;
      if (currUser != null) {
        initPage = MainScreen();
      }
    } catch (e) {
      initPage = const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // useMaterial3: true,
        primaryColor: const Color(0xff9336B4),
        primarySwatch: Colors.purple,
        textTheme: TextTheme(
          titleLarge: GoogleFonts.inter(
            textStyle: const TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          bodyLarge: GoogleFonts.inter(
            textStyle: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          bodyMedium: GoogleFonts.inter(
            textStyle: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          bodySmall: GoogleFonts.inter(
            textStyle: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ),
      home: initPage,
    );
  }
}
