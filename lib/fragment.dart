import 'package:acsv2/Profile.dart';
import 'package:acsv2/home.dart';
import 'package:flutter/material.dart';

class Fragment extends StatefulWidget {
  const Fragment({super.key});

  @override
  State<Fragment> createState() => _FragmentState();
}

class _FragmentState extends State<Fragment> {
  int _currenIndex = 0;
  final tabs = [
    Center(
      child: Home(),
    ),
    Center(
        // child: Listdata(),
        ),
    Center(
      child: Profile(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currenIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currenIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'List',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.blue),
        ],
        onTap: (index) {
          setState(() {
            _currenIndex = index;
          });
        },
      ),
    );
  }
}
