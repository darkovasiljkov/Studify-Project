import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/constants.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart'; // ✅ Add this import

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _localImagePath;

  void _openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfileScreen()),
    );

    if (result != null) {
      await FirebaseAuth.instance.currentUser?.reload();
      setState(() {
        _localImagePath = result['imagePath'];
      });
    }
  }

  void _openChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName =
        user?.displayName ?? user?.email?.split('@')[0] ?? 'User';
    final email = user?.email ?? 'No email';

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppConstants.headingStyle),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: _localImagePath != null
                  ? ClipOval(
                child: kIsWeb
                    ? Image.network(
                  _localImagePath!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
                    : Image.file(
                  File(_localImagePath!),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              )
                  : CircleAvatar(
                radius: 50,
                backgroundColor: AppConstants.accentColor,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                child: user?.photoURL == null
                    ? Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(displayName, style: AppConstants.headingStyle),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                email,
                style:
                AppConstants.bodyStyle.copyWith(color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 30),
            Divider(),
            ListTile(
              leading: Icon(Icons.edit, color: AppConstants.primaryColor),
              title: Text('Edit Profile', style: AppConstants.bodyStyle),
              onTap: _openEditProfile,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.lock, color: AppConstants.primaryColor),
              title: Text('Change Password', style: AppConstants.bodyStyle),
              onTap: _openChangePassword, // ✅ Navigate to change password screen
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: AppConstants.primaryColor),
              title: Text('Logout', style: AppConstants.bodyStyle),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Logout'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
