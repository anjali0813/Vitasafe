import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vitasafe/reg_api.dart';

class NearbyVolunteersPage extends StatefulWidget {
  const NearbyVolunteersPage({super.key});

  @override
  State<NearbyVolunteersPage> createState() => _NearbyVolunteersPageState();
}

class _NearbyVolunteersPageState extends State<NearbyVolunteersPage> {
  final Dio dio = Dio();

  List<dynamic> nearbyVolunteers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchNearbyVolunteers();
  }

  // 📍 Fetch volunteers and filter within 5 KM
  Future<void> _fetchNearbyVolunteers() async {
    try {
      // Request location permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // API call
      Response response = await dio.get('$baseurl/UserViewVolunteers');

      List<dynamic> allVolunteers = response.data;

      // Filter volunteers within 5 KM
      nearbyVolunteers = allVolunteers.where((v) {
        if (v['latitude'] == null || v['longitude'] == null) return false;

        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          v['latitude'],
          v['longitude'],
        );

        return distance <= 5000; // 5 KM
      }).toList();
    } catch (e) {
      debugPrint('Error: $e');
    }

    setState(() => loading = false);
  }

  // 📞 Open dialpad
   Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri uri = Uri.parse('tel:$phoneNumber');
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Volunteers'),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : nearbyVolunteers.isEmpty
              ? const Center(
                  child: Text(
                    'No volunteers within 5 KM',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: nearbyVolunteers.length,
                  itemBuilder: (context, index) {
                    final v = nearbyVolunteers[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      elevation: 3,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.volunteer_activism,
                              color: Colors.white),
                        ),
                        title: Text(
                          v['Name'] ?? 'Unknown',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Skills: ${v['Skills'] ?? '-'}'),
                            Text('Phone: ${v['Phone'] ?? '-'}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.call, color: Colors.green),
                          onPressed: () {
                            if (v['Phone'] != null) {
                              _makePhoneCall(v['Phone'].toString());
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
