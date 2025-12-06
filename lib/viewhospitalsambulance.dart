import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vitasafe/Doctorview.dart';
import 'package:vitasafe/reg_api.dart';
import 'package:vitasafe/vehicleview.dart';

class NearbyhospitalAmbulance extends StatefulWidget {
  const NearbyhospitalAmbulance({Key? key}) : super(key: key);

  @override
  State<NearbyhospitalAmbulance> createState() => _NearbyhospitalAmbulanceState();
}

class _NearbyhospitalAmbulanceState extends State<NearbyhospitalAmbulance> {
  List<dynamic> hospitals = [];
  bool isLoading = true;
  late Position userPosition;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _getUserLocation();
      await _fetchHospitals();
    } catch (e) {
      debugPrint('Initialization error: $e');
      setState(() => isLoading = false);
    }
  }

  /// Get current user's latitude and longitude
  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception("Location services are disabled.");

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are denied.");
    }

    userPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  /// Fetch hospital list from your API (replace URL)
  Future<void> _fetchHospitals() async {
    try {
      

      final response = await Dio().get('$baseurl/Hospital_view');
      print(response.data);

      if (response.statusCode == 200 && response.data is List) {
        List data = response.data;

        // Compute distance for each hospital
        List nearbyHospitals = [];
        for (var hospital in data) {
          double lat = double.tryParse(hospital['latitude'].toString()) ?? 0.0;
          double lng = double.tryParse(hospital['longitude'].toString()) ?? 0.0;

          double distance = _calculateDistance(
              userPosition.latitude, userPosition.longitude, lat, lng);

          if (distance <= 5.0) {
            // only include hospitals within 5 km
            hospital['distance'] = distance;
            nearbyHospitals.add(hospital);
          }
        }

        // Sort by distance ascending
        nearbyHospitals.sort((a, b) => a['distance'].compareTo(b['distance']));

        setState(() {
          hospitals = nearbyHospitals;
          isLoading = false;
        });
      } else {
        throw Exception("Invalid data format");
      }
    } catch (e) {
      debugPrint('API error: $e');
      setState(() => isLoading = false);
    }
  }

  /// Haversine distance (in km)
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Earth radius (km)
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180);

  /// Launch a phone call
  void _callHospital(String phone) async {
    final uri = Uri.parse("tel:$phone");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hospitals Within 5 KM"),
        backgroundColor: Colors.redAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hospitals.isEmpty
              ? const Center(
                  child: Text(
                    "No hospitals found within 5 km radius.",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: hospitals.length,
                  itemBuilder: (context, index) {
                    final hospital = hospitals[index];
                    return Card(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AmbulanceListPage(
          hospitalId: hospital['id'],   // adjust field name if needed
          hospitalName: hospital['HospitalName'] ?? 'Hospital',
        ),
      ),
    );
  },
  title: Text(
    hospital['HospitalName'] ?? 'Unnamed Hospital',
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.redAccent,
    ),
  ),
  subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(hospital['Email'] ?? ''),
      Text('Phone: ${hospital['Contact_no'] ?? 'N/A'}'),
      Text('Address: ${hospital['Address'] ?? ''}'),
      Text(
        'Distance: ${hospital['distance']?.toStringAsFixed(2)} km',
        style: const TextStyle(color: Colors.grey),
      ),
      // TextButton(onPressed: (){},
      // child: Text("BED-BOOK", style: TextStyle(color: Colors.black)),
      // style: TextButton.styleFrom(backgroundColor: Colors.grey),
      // )
    ],
  ),
  trailing: IconButton(
    icon: const Icon(Icons.call, color: Colors.green),
    onPressed: () => _callHospital(hospital['Contact_no']),
  ),
)

                    );
                  },
                ),
    );
  }
}
