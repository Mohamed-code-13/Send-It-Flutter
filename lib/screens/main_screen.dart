import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:send_it/screens/add_friend_screen.dart';
import 'package:send_it/screens/all_chat_screen.dart';
import 'package:send_it/screens/profile_screen.dart';
import 'package:send_it/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getScreens()[activeIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
            () => AddFriendScreen(),
            transition: Transition.downToUp,
          );
        },
        child: const Icon(Icons.person_add_alt_1_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.chat_bubble,
          Icons.person,
          Icons.settings,
          Icons.add,
        ],
        activeIndex: activeIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (ix) => setState(() => activeIndex = ix),
        activeColor: Colors.purpleAccent,
        inactiveColor: Colors.black,
        backgroundColor: Colors.grey,
      ),
    );
  }

  List<Widget> _getScreens() {
    return [
      const AllChatScreen(),
      const ProfileScreen(),
      const SettingsScreen(),
      AddFriendScreen(),
    ];
  }
}
