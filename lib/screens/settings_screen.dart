import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: AppConstants.headingStyle),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          Text('General Settings', style: AppConstants.headingStyle),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.notifications, color: AppConstants.primaryColor),
            title: Text('Notifications', style: AppConstants.bodyStyle),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language, color: AppConstants.primaryColor),
            title: Text('Language', style: AppConstants.bodyStyle),
            trailing: Text('English', style: AppConstants.bodyStyle.copyWith(color: Colors.grey)),
            onTap: () {},
          ),
          Divider(),
          Text('Account Settings', style: AppConstants.headingStyle),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.security, color: AppConstants.primaryColor),
            title: Text('Privacy Policy', style: AppConstants.bodyStyle),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help, color: AppConstants.primaryColor),
            title: Text('Help & Support', style: AppConstants.bodyStyle),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info, color: AppConstants.primaryColor),
            title: Text('About', style: AppConstants.bodyStyle),
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
    );
  }
}
