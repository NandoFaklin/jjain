import 'package:flutter/material.dart';
import 'package:jhein_beta/UI/MainHome/Chat/Chat.dart';
import 'package:jhein_beta/UI/MainHome/Home/Home.dart';
import 'package:jhein_beta/UI/MainHome/Log/Log.dart';
import 'package:jhein_beta/UI/MainHome/Profile/Profile.dart';


class MainTab extends StatefulWidget {
  const MainTab({super.key});

  @override
  State<MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    LogSelesaiPage(),
    ChatPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.newspaper_rounded), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.email_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedIconTheme: IconThemeData(
        color: Colors.blueAccent, // Ubah warna ikon saat dipilih
      ),
    ),
    );
  }
}
