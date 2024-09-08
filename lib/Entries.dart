// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Entries extends StatelessWidget {
  Entries({super.key});

  final User? users = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection("users")
                .doc(users?.uid)
                .collection('Authorized Users')
                .get(), // Fetching the data
            // Fetching the data from "User Data" collection
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              // Handle loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Handle error state
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              // Handle empty data
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "No authorized users found.",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              // Data is available, show the list
              return Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var userData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
// Document ID for deletion

                    return ListTile(
                      contentPadding: EdgeInsets.all(0),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          userData['Image'] ?? "https://picsum.photos/200/300",
                        ),
                      ),
                      title: Text(userData['Name'] ?? "Unknown Name"),
                      subtitle:
                          Text(userData['Relation'] ?? "No Relation Specified"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(DateTime.now().toString()),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
