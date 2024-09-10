import 'package:camera/camera.dart';
import 'package:cameye/EditProfile.dart';
import 'package:cameye/Entries.dart';
import 'package:cameye/Home.dart';
import 'package:cameye/Notification.dart';
import 'package:flutter/material.dart';

class LiveMonitoringScreen extends StatefulWidget {
  @override
  _LiveMonitoringScreenState createState() => _LiveMonitoringScreenState();
}

class _LiveMonitoringScreenState extends State<LiveMonitoringScreen> {
  late List<CameraDescription> cameras;
  late CameraController controller;
  bool isCameraInitialized = false;
  int _currentIndex = 2;
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    controller = CameraController(
      cameras[1], // Use the first available camera
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
          'Live Feeding',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   icon: Icon(Icons.menu, color: Colors.black),
        //   onPressed: () {
        //     // Open Drawer
        //   },
        // ),
      ),
      body: SingleChildScrollView(
        child: isCameraInitialized
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 400,
                      child: _buildCameraPreviewWidget(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 400,
                    //   child: _buildCameraPreviewWidget(),
                    // ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
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
