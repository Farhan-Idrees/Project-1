import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() {
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          notifications.add({
            'title': message.notification!.title,
            'body': message.notification!.body,
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index]['title'] ?? 'No title'),
            subtitle: Text(notifications[index]['body'] ?? 'No body'),
          );
        },
      ),
    );
  }
}















// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:timeago/timeago.dart' as timeago;

// class Notifications extends StatelessWidget {
//   const Notifications({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('notifications')
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No notifications found'));
//           }

//           final notifications = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: notifications.length,
//             itemBuilder: (context, index) {
//               final notification = notifications[index];
//               final message = notification['message'] ?? 'No message';
//               final imageUrl = notification['imageUrl'] ?? '';
//               final timestamp =
//                   notification['timestamp']?.toDate() ?? DateTime.now();

//               return ListTile(
//                 leading: CircleAvatar(
//                   radius: 30,
//                   backgroundImage: imageUrl.isNotEmpty
//                       ? NetworkImage(imageUrl)
//                       : const AssetImage('assets/default_avatar.png')
//                           as ImageProvider,
//                 ),
//                 title: Text(message),
//                 subtitle: Text(timeago.format(timestamp)),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
