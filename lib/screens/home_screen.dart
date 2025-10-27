import 'package:flutter/material.dart';
import 'package:twitch_clone/firebase/auth_method.dart';

import 'package:twitch_clone/screens/feed_screen.dart';
import 'package:twitch_clone/screens/go_live.dart';
import 'package:twitch_clone/screens/onboarding_screen.dart';
import 'package:twitch_clone/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 0;
  void onPageChanged(int index) {
    setState(() {
      page = index;
    });
  }

  List<Widget> pages = [
    FeedScreen(),
    GoLiveScreen(),
    Center(child: Text('Browse')),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          AuthMethod().logOut().then((_){
            Navigator.pushNamed(context, OnboardingScreen.routeName);
          });
        }, 
        icon: Icon(Icons.logout),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: buttonColor,
        unselectedItemColor: primaryColor,
        backgroundColor: backgroundColor,
        unselectedFontSize: 12,
        onTap: onPageChanged,
        currentIndex: page,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Following',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_rounded),
            label: 'Go Live',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.copy), label: 'Browse'),
        ],
      ),
      body: pages[page],
    );
  }
}
