// ignore_for_file: prefer_const_constructors

import 'package:cameye/AddUser.dart';
import 'package:cameye/EProfile.dart';
import 'package:cameye/EditProfile.dart';
import 'package:cameye/ListUsers.dart';
import 'package:cameye/LiveFeed.dart';
import 'package:cameye/Notification.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Home",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Notifications(),
                      ));
                },
                icon: Icon(Icons.notification_important))
          ],
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: Text('Profile'),
                leading: Icon(Icons.person),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfile(),
                      ));
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: Center(
          child: CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage("assets/Logo.jpg"),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.blue,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListUsers()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddUsers()),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LiveMonitoringScreen()),
              );
            } else if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            }
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.list), label: 'List Users'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_add_alt_1), label: 'Add Users'),
            BottomNavigationBarItem(
                icon: Icon(Icons.live_tv), label: 'Live Streaming'),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.notification_important),
            //     label: 'Notification'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ));
  }
}
