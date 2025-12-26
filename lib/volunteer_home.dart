// import 'package:flutter/material.dart';
// import 'package:vitasafe/blood_donation.dart';
// import 'package:vitasafe/emergency_support.dart';
// import 'package:vitasafe/login.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/volunteer.dart';
// import 'package:vitasafe/volunteer_feedback&ratings.dart';
// import 'package:vitasafe/volunteer_notifications.dart';
// import 'package:vitasafe/volunteer_taskassignment.dart';
// import 'package:vitasafe/volunteeracceptedbloodhistory.dart';

// class VolunteerModulePage extends StatelessWidget {
//   const VolunteerModulePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Volunteer Module"),
//         backgroundColor: Colors.red,
//         actions: [
//           IconButton(onPressed: (){
//             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen(),), (route)=>false);
//           }, icon: Icon(Icons.logout))
//         ],
//       ),
//       body: GridView.count(
//         crossAxisCount: 2,
//         padding: const EdgeInsets.all(16),
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         children: [
//           _buildCard(
//             context,
//             title: "Profile Management",
//             icon: Icons.person,
//             page: VolunteerProfilePage(),
//           ),
//           _buildCard(
//             context,
//             title: "Task Assignment",
//             icon: Icons.assignment,
//             page: VolunteerTaskAssignmentPage(),
//           ),
//           // _buildCard(
//           //   context,
//           //   title: "Emergency Support",
//           //   icon: Icons.warning,
//           //   page: VolunteerEmergencySupportPage(),
//           // ),
//           _buildCard(
//             context,
//             title: "Notifications & Alerts",
//             icon: Icons.notifications_active,
//             page:VolunteerNotificationsPage(),
//           ),
//           _buildCard(
//             context,
//             title: "Blood Donation Volunteering",
//             icon: Icons.bloodtype,
//             page: BloodDonationVolunteerPage(volunteerId: lid!,),
//           ),
//            _buildCard(
//             context,
//             title: "Blood Donation History",
//             icon: Icons.bloodtype,
//             page: BloodDonationHistoryPage(volunteerId: lid!,),
//           ),
//           _buildCard(
//             context,
//             title: "Feedback & Ratings",
//             icon: Icons.star_rate,
//             page:VolunteerFeedbackPage(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCard(BuildContext context, {required String title, required IconData icon, required Widget page}) {
//     return GestureDetector(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => page),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade300,
//               blurRadius: 6,
//               offset: const Offset(2, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: Colors.redAccent),
//             const SizedBox(height: 10),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PlaceholderPage extends StatelessWidget {
//   final String title;
//   const PlaceholderPage({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Center(
//         child: Text(
//           "$title Page (To be implemented)",
//           style: const TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vitasafe/blood_donation.dart';
import 'package:vitasafe/emergency_support.dart';
import 'package:vitasafe/login.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/volunteer.dart';
import 'package:vitasafe/volunteer_feedback&ratings.dart';
import 'package:vitasafe/volunteer_notifications.dart';
import 'package:vitasafe/volunteer_taskassignment.dart';
import 'package:vitasafe/volunteeracceptedbloodhistory.dart';
import 'package:vitasafe/reg_api.dart'; // contains baseurl

class VolunteerModulePage extends StatefulWidget {
  const VolunteerModulePage({super.key});

  @override
  State<VolunteerModulePage> createState() => _VolunteerModulePageState();
}

class _VolunteerModulePageState extends State<VolunteerModulePage> {
  final Dio dio = Dio();
  Timer? _timer;
  int? _lastAlertId;
  double? volunteerLat;
  double? volunteerLon;

  @override
  void initState() {
    super.initState();
    _fetchVolunteerLocation().then((_) => _fetchLatestAlert());
    _timer = Timer.periodic(const Duration(minutes: 10), (_) => _fetchLatestAlert());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchVolunteerLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      volunteerLat = position.latitude;
      volunteerLon = position.longitude;
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // km
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = pow(sin(dLat / 2), 2) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * pow(sin(dLon / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(deg) => deg * (pi / 180);

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return double.tryParse(value.toString());
  }

  Future<void> _fetchLatestAlert() async {
    if (volunteerLat == null || volunteerLon == null) return;

    try {
      final response = await dio.get("$baseurl/alert");
      if (response.statusCode == 200 && response.data['id'] != null) {
        final alertData = response.data;

        final alertLat = _parseDouble(alertData['Latitude']);
        final alertLon = _parseDouble(alertData['Longitude']);

        if (alertLat != null && alertLon != null) {
          final distance = calculateDistance(volunteerLat, volunteerLon, alertLat, alertLon);

          if (distance <= 5 && _lastAlertId != alertData['id']) {
            _lastAlertId = alertData['id'];
            _showAlertDialog(alertData, alertLat, alertLon);
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching alert: $e");
    }
  }

  void _showAlertDialog(Map<String, dynamic> alertData, double alertLat, double alertLon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Nearby Accident Alert!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Alert: ${alertData['Alert']}"),
            Text("Distance: ${calculateDistance(volunteerLat!, volunteerLon!, alertLat, alertLon).toStringAsFixed(2)} km"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showMap(alertLat, alertLon);
            },
            child: const Text("View on Map"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Dismiss"),
          ),
        ],
      ),
    );
  }

  void _showMap(double lat, double lon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text("Alert Location"), backgroundColor: Colors.redAccent),
          body: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(lat, lon),
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(
                markers: [
                      Marker(
                        width: 80,
                        height: 80,
                        point: LatLng(lat, lon),
                        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Volunteer Module"),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _buildCard(
            context,
            title: "Profile Management",
            icon: Icons.person,
            page: VolunteerProfilePage(),
          ),
          _buildCard(
            context,
            title: "Task Assignment",
            icon: Icons.assignment,
            page: VolunteerTaskAssignmentPage(),
          ),
          _buildCard(
            context,
            title: "Notifications & Alerts",
            icon: Icons.notifications_active,
            page: VolunteerNotificationsPage(),
          ),
          _buildCard(
            context,
            title: "Blood Donation Volunteering",
            icon: Icons.bloodtype,
            page: BloodDonationVolunteerPage(volunteerId: lid!),
          ),
          _buildCard(
            context,
            title: "Blood Donation History",
            icon: Icons.bloodtype,
            page: BloodDonationHistoryPage(volunteerId: lid!),
          ),
          _buildCard(
            context,
            title: "Feedback & Ratings",
            icon: Icons.star_rate,
            page: VolunteerFeedbackPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required IconData icon, required Widget page}) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.redAccent),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
