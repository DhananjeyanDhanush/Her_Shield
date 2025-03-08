import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LiveLocationPage extends StatefulWidget {
  @override
  _LiveLocationPageState createState() => _LiveLocationPageState();
}

class _LiveLocationPageState extends State<LiveLocationPage> {
  final Location _location = Location();
  final MapController _mapController = MapController();
  LatLng _currentPosition = LatLng(12.9716, 77.5946); // Default location (Bangalore)

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  /// Requests location permission and fetches the user's location
  Future<void> _requestLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Check if location service is enabled
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Request permission if not granted
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _getUserLocation();
  }

  /// Fetches the user's current location and updates the map
  Future<void> _getUserLocation() async {
    try {
      var userLocation = await _location.getLocation();
      if (userLocation.latitude != null && userLocation.longitude != null) {
        LatLng newLocation = LatLng(userLocation.latitude!, userLocation.longitude!);
        
        setState(() {
          _currentPosition = newLocation;
        });

        // Move the map to the new location
        _mapController.move(newLocation, 15);
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.jpg', height: 40, width: 40, fit: BoxFit.cover),
            SizedBox(width: 10),
            Text("Live Location"),
          ],
        ),
        backgroundColor: Colors.purple,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentPosition, // Updated to `initialCenter`
          initialZoom: 15.0, // Updated to `initialZoom`
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.her', // Required by OpenStreetMap
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _currentPosition,
                width: 50.0,
                height: 50.0,
                child: Icon(Icons.location_pin, color: Colors.red, size: 40),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _getUserLocation,
        child: Icon(Icons.location_searching, color: Colors.purple),
      ),
    );
  }
}
