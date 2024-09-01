// ignore_for_file: unused_field

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenScreenState createState() =>
      _EditProfileScreenScreenState();
}

class _EditProfileScreenScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _firstController = TextEditingController();
  final _lastController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String Fname = "";
  String Lname = "";
  String email = "";
  String phoneNumber = "";

  String password = "";
  String image = "";

  File? _image;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  _getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        Fname = doc['first_name'];
        Lname = doc['last_name'];
        email = doc['email'];
        phoneNumber = doc['phone_number'];
        image = doc['image'];
      });
    }
  }

  _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      print('Updating profile...');
      _formKey.currentState!.save();
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'first_name': Fname,
          'last_name': Lname,
          'email': email,
          'phone_number': phoneNumber,
          'image': image,
        });
        print('Firestore update successful');
        if (_image != null) {
          final ref = _storage.ref().child('pp/${user.uid}');
          await ref.putFile(_image!);
          final url = await ref.getDownloadURL();
          await _firestore.collection('users').doc(user.uid).update({
            'image': url,
          });
        }
      }
      Navigator.pop(context);
    }
  }

  _selectImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        _image = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : image.isNotEmpty
                        ? NetworkImage(image)
                        : null,
                child: _image != null
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.person),
                        onPressed: _selectImage,
                      ),
              ),
              TextFormField(
                // controller: _firstController,
                initialValue: Lname,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                onSaved: (value) => Fname = value!,
              ),
              TextFormField(
                // controller: _lastController,
                initialValue: Lname,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
                onSaved: (value) => Lname = value!,
              ),
              TextFormField(
                // controller: _emailController,
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                // controller: _phoneController,
                initialValue: phoneNumber,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) => phoneNumber = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _updateProfile();
                  
                },
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
