import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  LatLng? _selectedLatLng;

  // Initial map center point
  final LatLng _initialCenter = LatLng(41.9981, 21.4254);
  final double _initialZoom = 14.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: _initialCenter,
                zoom: _initialZoom,
                onTap: (tapPosition, point) {
                  setState(() {
                    _selectedLatLng = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.app',
                ),
                if (_selectedLatLng != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedLatLng!,
                        width: 40,
                        height: 40,
                        builder: (ctx) => Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text('Save Location'),
              onPressed: () {
                if (_selectedLatLng == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a location first!')),
                  );
                } else {
                  // Return the selected LatLng to previous screen
                  Navigator.pop(context, _selectedLatLng);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
