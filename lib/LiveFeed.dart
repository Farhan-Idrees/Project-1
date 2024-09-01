import 'package:camera/camera.dart';
import 'package:cameye/AddUser.dart';
import 'package:cameye/EProfile.dart';
import 'package:cameye/ListUsers.dart';
import 'package:flutter/material.dart';

class LiveMonitoringScreen extends StatefulWidget {
  @override
  _LiveMonitoringScreenState createState() => _LiveMonitoringScreenState();
}

class _LiveMonitoringScreenState extends State<LiveMonitoringScreen> {
  late List<CameraDescription> cameras;
  late CameraController controller;
  bool isCameraInitialized = false;
  int _currentIndex = 3;
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    controller = CameraController(
      cameras[0], // Use the first available camera
      ResolutionPreset.high,
    );

    await controller.initialize();

    if (!mounted) {
      return;
    }

    setState(() {
      isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Live Monitoring',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              // Open Drawer
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.help_outline, color: Colors.black),
              onPressed: () {
                // Help action
              },
            ),
          ],
        ),
        body: isCameraInitialized
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildCameraPreviewWidget(),
                    SizedBox(height: 20),
                    _buildCameraPreviewWidget(),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
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

  Widget _buildCameraPreviewWidget() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CameraPreview(controller),
      ),
    );
  }
}
