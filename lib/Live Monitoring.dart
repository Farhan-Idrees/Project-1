import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';



class LiveMonitoringScreen extends StatefulWidget {
  @override
  _LiveMonitoringScreenState createState() => _LiveMonitoringScreenState();
}

class _LiveMonitoringScreenState extends State<LiveMonitoringScreen> {
  late List<CameraDescription> cameras;
  late CameraController controller;
  bool isCameraInitialized = false;
  FaceDetector faceDetector = GoogleMlKit.vision.faceDetector();
  List<Face> faces = [];

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

    controller.startImageStream((CameraImage image) {
      _detectFaces(image);
    });
  }

  Future<void> _detectFaces(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    Future<void> _detectFaces(CameraImage image) async {
      try {
        final WriteBuffer allBytes = WriteBuffer();
        for (final Plane plane in image.planes) {
          allBytes.putUint8List(plane.bytes);
        }
        final bytes = allBytes.done().buffer.asUint8List();

        final InputImage inputImage = InputImage.fromBytes(
          bytes: bytes,
          inputImageData: InputImageData(
            size: Size(image.width.toDouble(), image.height.toDouble()),
            imageRotation: InputImageRotationMethods.fromRawValue(
                    controller.description.sensorOrientation) ??
                InputImageRotation.Rotation_0deg,
            inputImageFormat:
                InputImageFormatMethods.fromRawValue(image.format.raw) ??
                    InputImageFormat.NV21,
            planeData: image.planes.map(
              (Plane plane) {
                return InputImagePlaneMetadata(
                  bytesPerRow: plane.bytesPerRow,
                  height: plane.height,
                  width: plane.width,
                );
              },
            ).toList(),
          ),
        );

        final List<Face> detectedFaces =
            await faceDetector.processImage(inputImage);

        if (mounted) {
          setState(() {
            faces = detectedFaces;
          });
        }
      } catch (e) {
        print('Error in detecting faces: $e');
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    faceDetector.close();
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
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Stack(
                  children: [
                    _buildCameraPreviewWidget(),
                    ..._buildFaceBoxes(),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
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

  List<Widget> _buildFaceBoxes() {
    return faces.map((Face face) {
      final rect = face.boundingBox;
      return Positioned(
        left: rect.left,
        top: rect.top,
        width: rect.width,
        height: rect.height,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }).toList();
  }

  InputImageRotation _rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.Rotation_0deg;
      case 180:
        return InputImageRotation.Rotation_180deg;
      case 270:
        return InputImageRotation.Rotation_270deg;
      default:
        return InputImageRotation.Rotation_0deg;
    }
  }
}
