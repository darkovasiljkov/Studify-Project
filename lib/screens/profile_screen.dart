import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppConstants.accentColor,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Center(child: Text('John Doe', style: AppConstants.headingStyle)),
            SizedBox(height: 10),
            Center(
              child: Text('johndoe@example.com', style: AppConstants.bodyStyle.copyWith(color: Colors.grey)),
            ),
            SizedBox(height: 30),
            Divider(),
            ListTile(
              leading: Icon(Icons.edit, color: AppConstants.primaryColor),
              title: Text('Edit Profile', style: AppConstants.bodyStyle),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.lock, color: AppConstants.primaryColor),
              title: Text('Change Password', style: AppConstants.bodyStyle),
              onTap: () {},
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
                      TextButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: Text('Cancel')),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: Text('Logout'),
                        style: ElevatedButton.styleFrom(backgroundColor: AppConstants.primaryColor),
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
