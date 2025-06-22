import 'package:flutter/material.dart';
import '../utils/constants.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Offset? _selectedPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location', style: AppConstants.headingStyle),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTapDown: (TapDownDetails details) {
                setState(() {
                  _selectedPosition = details.localPosition;
                });
              },
              child: Stack(
                children: [
                  Image.network(
                    'https://maps.googleapis.com/maps/api/staticmap?center=41.9981,21.4254&zoom=14&size=600x400&key=YOUR_GOOGLE_MAPS_API_KEY',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  if (_selectedPosition != null)
                    Positioned(
                      left: _selectedPosition!.dx - 12,
                      top: _selectedPosition!.dy - 24,
                      child: Icon(
                        Icons.location_pin,
                        color: AppConstants.primaryColor,
                        size: 40,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: ElevatedButton.icon(
              onPressed: () {
                if (_selectedPosition == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a location first!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Location saved at pixel position: (${_selectedPosition!.dx}, ${_selectedPosition!.dy})'),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.save),
              label: Text('Save Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
