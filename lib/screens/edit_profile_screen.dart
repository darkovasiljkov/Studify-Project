import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'dart:io' show File;

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController nameController = TextEditingController();
  XFile? _image;

  @override
  void initState() {
    super.initState();
    nameController.text = _auth.currentUser?.displayName ?? '';
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> _saveProfile() async {
    final user = _auth.currentUser;

    // Update display name
    if (nameController.text.trim().isNotEmpty) {
      await user?.updateDisplayName(nameController.text.trim());
    }

    // Optional: Upload image to Firebase Storage and update photoURL

    // Reload user to refresh Firebase cache
    await user?.reload();

    Navigator.pop(context, {
      'displayName': nameController.text,
      'imagePath': _image?.path,
    });
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    if (_image != null) {
      imageProvider = kIsWeb
          ? NetworkImage(_image!.path)
          : FileImage(File(_image!.path)) as ImageProvider;
    }

    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[400],
                backgroundImage: imageProvider,
                child: imageProvider == null
                    ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                    : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Display Name'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
