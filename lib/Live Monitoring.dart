import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:typed_data';

class LiveMonitoringScreen extends StatefulWidget {
  @override
  _LiveMonitoringScreenState createState() => _LiveMonitoringScreenState();
}

class _LiveMonitoringScreenState extends State<LiveMonitoringScreen> {
  late WebSocketChannel channel;
  bool isLoading = true;
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
  }

  void _initializeWebSocket() {
    channel = IOWebSocketChannel.connect('ws://your_backend_ip:8000/video_feed');
    channel.stream.listen((event) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Live Feed',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildLiveFeed(Uint8List.fromList(snapshot.data));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildLiveFeed(Uint8List frame) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 400,
          child: Image.memory(frame),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      selectedItemColor: Colors.blue,
      onTap: (index) {
        if (index == 0) Navigator.pushNamed(context, '/home');
        if (index == 1) Navigator.pushNamed(context, '/entries');
        if (index == 3) Navigator.pushNamed(context, '/notifications');
        if (index == 4) Navigator.pushNamed(context, '/profile');
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Entries'),
        BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live Monitoring'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';

// class LiveMonitoringScreen extends StatefulWidget {
//   final String cameraIP;

//   const LiveMonitoringScreen({required this.cameraIP, Key? key}) : super(key: key);

//   @override
//   _LiveMonitoringScreenState createState() => _LiveMonitoringScreenState();
// }

// class _LiveMonitoringScreenState extends State<LiveMonitoringScreen> {
//   RTCVideoRenderer _videoRenderer = RTCVideoRenderer();

//   @override
//   void initState() {
//     super.initState();
//     _initializeRenderer();
//     _startLiveFeed();
//   }

//   Future<void> _initializeRenderer() async {
//     await _videoRenderer.initialize();
//   }

//   void _startLiveFeed() {
//     // Assuming the camera IP is a WebRTC stream, otherwise you'll need to adjust for RTSP or HTTP stream
//     final mediaConstraints = {
//       'audio': false,
//       'video': {
//         'mandatory': {
//           'minWidth': '640',
//           'minHeight': '480',
//           'minFrameRate': '30',
//         },
//         'optional': [],
//       },
//     };

//     navigator.mediaDevices.getUserMedia(mediaConstraints).then((stream) {
//       _videoRenderer.srcObject = stream;
//     }).catchError((e) {
//       print(e);
//     });
//   }

//   @override
//   void dispose() {
//     _videoRenderer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Live Monitoring'),
//       ),
//       body: Center(
//         child: _videoRenderer.srcObject == null
//             ? CircularProgressIndicator()
//             : RTCVideoView(_videoRenderer),
//       ),
//     );
//   }
// }

// // Function to open the live monitoring screen with a given camera IP
// void openLiveMonitoring(BuildContext context, String cameraIP) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => LiveMonitoringScreen(cameraIP: cameraIP),
//     ),
//   );
// }
