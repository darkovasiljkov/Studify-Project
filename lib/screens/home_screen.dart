import 'package:flutter/material.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Studify',
          style: AppConstants.headingStyle.copyWith(color: Colors.white),
        ),
        backgroundColor: AppConstants.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AppConstants.settingsRoute);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeBanner(),
          Expanded(child: _buildFeaturesGrid(context)),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade100,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Back!',
              style: AppConstants.headingStyle.copyWith(
                color: Colors.black87,
                fontSize: 32,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'What do you want to manage today?',
              style: AppConstants.bodyStyle.copyWith(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 4 / 3,
        ),
        itemCount: featureList.length,
        itemBuilder: (context, index) {
          return _buildFeatureCard(context, featureList[index]);
        },
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, Map<String, dynamic> feature) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, feature['route']);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.lightBlue.shade200, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(feature['icon'], size: 40, color: Colors.white),
              SizedBox(height: 10),
              Text(
                feature['title'],
                style: AppConstants.buttonTextStyle.copyWith(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blue.shade300,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: (index) {
        if (index == 1) Navigator.pushNamed(context, AppConstants.calendarRoute);
        if (index == 2) Navigator.pushNamed(context, AppConstants.profileRoute);
      },
    );
  }

  final List<Map<String, dynamic>> featureList = [
    {'title': 'Calendar', 'icon': Icons.calendar_today, 'route': AppConstants.calendarRoute},
    {'title': 'Tasks', 'icon': Icons.task, 'route': AppConstants.taskListRoute},  // <-- Use taskListRoute here
    {'title': 'Add Event', 'icon': Icons.add, 'route': AppConstants.addEventRoute},
    {'title': 'Locations', 'icon': Icons.location_on, 'route': AppConstants.locationRoute},
    {'title': 'Profile', 'icon': Icons.person, 'route': AppConstants.profileRoute},
    {'title': 'Settings', 'icon': Icons.settings, 'route': AppConstants.settingsRoute},
  ];
}
