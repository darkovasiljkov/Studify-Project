import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/firestore_service.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  LatLng? _selectedLatLng;
  final TextEditingController _nameController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  final LatLng _initialCenter = LatLng(41.9981, 21.4254);
  final double _initialZoom = 14.0;

  void _saveLocation() async {
    if (_selectedLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a location first!')),
      );
      return;
    }
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a name or note for the location!')),
      );
      return;
    }

    await _firestoreService.addLocation(_selectedLatLng!, _nameController.text.trim());

    setState(() {
      _selectedLatLng = null;
      _nameController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Location saved to Firestore!')),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Locations')),
      body: Column(
        children: [
          Expanded(
            flex: 3,
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
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
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
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Location Name or Note',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.save),
            label: Text('Save Location'),
            onPressed: _saveLocation,
          ),
          Divider(height: 1),
          Expanded(
            flex: 2,
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _firestoreService.getLocationsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No saved locations yet'));
                }
                final locations = snapshot.data!;
                return ListView.builder(
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    final loc = locations[index];
                    final LatLng latLng = loc['latLng'];
                    final String name = loc['name'];
                    return ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(name),
                      subtitle: Text('Lat: ${latLng.latitude.toStringAsFixed(4)}, Lng: ${latLng.longitude.toStringAsFixed(4)}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _firestoreService.deleteLocation(loc['id']);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
