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
  final MapController _mapController = MapController(); // 👈 Added map controller

  final LatLng _initialCenter = LatLng(41.9981, 21.4254);
  final double _initialZoom = 14.0;

  void _saveLocation() async {
    if (_selectedLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a location on the map.')),
      );
      return;
    }

    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a name or note.')),
      );
      return;
    }

    await _firestoreService.addLocation(
      _selectedLatLng!,
      _nameController.text.trim(),
    );

    setState(() {
      _selectedLatLng = null;
      _nameController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Location saved successfully.')),
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
      appBar: AppBar(
        title: Text('Saved Locations'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Map
          Expanded(
            flex: 3,
            child: FlutterMap(
              mapController: _mapController, // 👈 Added controller
              options: MapOptions(
                center: _initialCenter,
                zoom: _initialZoom,
                onTap: (_, point) {
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
                  userAgentPackageName: 'com.studify.app',
                ),
                if (_selectedLatLng != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 40,
                        height: 40,
                        point: _selectedLatLng!,
                        builder: (_) => Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Input & Save
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Location Name or Note',
                    prefixIcon: Icon(Icons.edit_note),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveLocation,
                    icon: Icon(Icons.save),
                    label: Text('Save Location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(),

          // Saved locations list
          Expanded(
            flex: 2,
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _firestoreService.getLocationsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No saved locations yet.'));
                }

                final locations = snapshot.data!;
                return ListView.builder(
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    final loc = locations[index];
                    final LatLng latLng = loc['latLng'];
                    final String name = loc['name'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: Icon(Icons.place, color: Colors.indigo),
                          title: Text(name),
                          subtitle: Text(
                            'Lat: ${latLng.latitude.toStringAsFixed(4)}, '
                                'Lng: ${latLng.longitude.toStringAsFixed(4)}',
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await _firestoreService.deleteLocation(loc['id']);
                            },
                          ),
                          onTap: () {
                            setState(() {
                              _selectedLatLng = latLng;
                              _mapController.move(latLng, _initialZoom); // 👈 Center map
                            });
                          },
                        ),
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
