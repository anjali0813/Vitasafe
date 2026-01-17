
// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:vitasafe/blood_donation.dart';
// import 'package:vitasafe/login.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/volunteer.dart';
// import 'package:vitasafe/volunteer_feedback&ratings.dart';
// import 'package:vitasafe/volunteer_notifications.dart';
// import 'package:vitasafe/volunteer_taskassignment.dart';
// import 'package:vitasafe/volunteeracceptedbloodhistory.dart';
// import 'package:vitasafe/reg_api.dart'; // contains baseurl

// class VolunteerModulePage extends StatefulWidget {
//   const VolunteerModulePage({super.key});

//   @override
//   State<VolunteerModulePage> createState() => _VolunteerModulePageState();
// }

// class _VolunteerModulePageState extends State<VolunteerModulePage> {
//   final Dio dio = Dio();
//   Timer? _timer;
//   int? _lastAlertId;
//   double? volunteerLat;
//   double? volunteerLon;

//   @override
//   void initState() {
//     super.initState();
//     _fetchVolunteerLocation().then((_) => _fetchLatestAlert());
//     _timer = Timer.periodic(const Duration(minutes: 10), (_) => _fetchLatestAlert());
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   Future<void> _fetchVolunteerLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         volunteerLat = position.latitude;
//       volunteerLon = position.longitude;
//       });
//     } catch (e) {
//       debugPrint("Error getting location: $e");
//     }
//   }

//   double calculateDistance(lat1, lon1, lat2, lon2) {
//     const R = 6371; // km
//     final dLat = _deg2rad(lat2 - lat1);
//     final dLon = _deg2rad(lon2 - lon1);
//     final a = pow(sin(dLat / 2), 2) +
//         cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * pow(sin(dLon / 2), 2);
//     final c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c;
//   }

//   double _deg2rad(deg) => deg * (pi / 180);

//   double? _parseDouble(dynamic value) {
//     if (value == null) return null;
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     if (value is String) return double.tryParse(value);
//     return double.tryParse(value.toString());
//   }

//   Future<void> _fetchLatestAlert() async {
//     if (volunteerLat == null || volunteerLon == null) return;

//     try {
//       final response = await dio.get("$baseurl/alert");
//       if (response.statusCode == 200 && response.data['id'] != null) {
//         final alertData = response.data;

//         final alertLat = _parseDouble(alertData['Latitude']);
//         final alertLon = _parseDouble(alertData['Longitude']);

//         if (alertLat != null && alertLon != null) {
//           final distance = calculateDistance(volunteerLat, volunteerLon, alertLat, alertLon);

//           if (distance <= 5 && _lastAlertId != alertData['id']) {
//             _lastAlertId = alertData['id'];
//             // _showAlertDialog(alertData, alertLat, alertLon);
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint("Error fetching alert: $e");
//     }
//   }

//   // void _showAlertDialog(Map<String, dynamic> alertData, double alertLat, double alertLon) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       title: const Text("New Nearby Accident Alert!"),
//   //       content: Column(
//   //         mainAxisSize: MainAxisSize.min,
//   //         children: [
//   //           Text("Alert: ${alertData['Alert']}"),
//   //           Text("Distance: ${calculateDistance(volunteerLat!, volunteerLon!, alertLat, alertLon).toStringAsFixed(2)} km"),
//   //         ],
//   //       ),
//   //       actions: [
//   //         TextButton(
//   //           onPressed: () {
//   //             Navigator.pop(context);
//   //             _showMap(alertLat, alertLon);
//   //           },
//   //           child: const Text("View on Map"),
//   //         ),
//   //         TextButton(
//   //           onPressed: () => Navigator.pop(context),
//   //           child: const Text("Dismiss"),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   void _showMap(double lat, double lon) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => Scaffold(
//           appBar: AppBar(title: const Text("Alert Location"), backgroundColor: Colors.redAccent),
//           body: FlutterMap(
//             options: MapOptions(
//               initialCenter: LatLng(lat, lon),
//               initialZoom: 15,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
//               ),
//               MarkerLayer(
//                 markers: [
//                       Marker(
//                         width: 80,
//                         height: 80,
//                         point: LatLng(lat, lon),
//                         child: const Icon(Icons.location_on, color: Colors.red, size: 40),
//                       ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (volunteerLat == null || volunteerLon == null) {
//     return const Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Volunteer Module"),
//         backgroundColor: Colors.red,
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (context) => LoginScreen()),
//                 (route) => false,
//               );
//             },
//             icon: const Icon(Icons.logout),
//           ),
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
//           _buildCard(
//             context,
//             title: "Notifications & Alerts",
//             icon: Icons.notifications_active,
//             page: VolunteerNotificationsPage(currentLat: volunteerLat!, currentLng: volunteerLon!,),
//           ),
//           _buildCard(
//             context,
//             title: "Blood Donation Volunteering",
//             icon: Icons.bloodtype,
//             page: BloodDonationVolunteerPage(volunteerId: lid!),
//           ),
//           _buildCard(
//             context,
//             title: "Blood Donation History",
//             icon: Icons.bloodtype,
//             page: BloodDonationHistoryPage(volunteerId: lid!),
//           ),
//           _buildCard(
//             context,
//             title: "Feedback & Ratings",
//             icon: Icons.star_rate,
//             page: VolunteerFeedbackPage(),
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





import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:vitasafe/blood_donation.dart';
import 'package:vitasafe/login.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/volunteer.dart';
import 'package:vitasafe/volunteer_feedback&ratings.dart';
import 'package:vitasafe/volunteer_notifications.dart';
import 'package:vitasafe/volunteer_taskassignment.dart';
import 'package:vitasafe/volunteeracceptedbloodhistory.dart';
import 'package:vitasafe/reg_api.dart';

class VolunteerModulePage extends StatefulWidget {
  const VolunteerModulePage({super.key});

  @override
  State<VolunteerModulePage> createState() => _VolunteerModulePageState();
}

class _VolunteerModulePageState extends State<VolunteerModulePage> {
  final Dio _dio = Dio();
  Timer? _locationTimer;
  Timer? _alertTimer;
  Timer? _statsTimer;
  int? _lastAlertId;
  double? _volunteerLat;
  double? _volunteerLon;
  bool _isLoading = true;
  bool _hasLocationPermission = false;
  bool _isLocationEnabled = false;
  String _locationStatus = 'Fetching location...';
  int _totalTasks = 0;
  int _completedTasks = 0;
  int _activeAlerts = 0;
  int _bloodDonations = 0;
  String _volunteerName = 'Volunteer';
  Position? _currentPosition;

  final List<VolunteerFeature> _features = [
    VolunteerFeature(
      title: 'Profile Management',
      subtitle: 'Update your volunteer profile',
      icon: Icons.person,
      color: Colors.blue,
      page: VolunteerProfilePage(),
    ),
    VolunteerFeature(
      title: 'Task Assignment',
      subtitle: 'View and manage tasks',
      icon: Icons.task_alt,
      color: Colors.green,
      page: VolunteerTaskAssignmentPage(),
    ),
    VolunteerFeature(
      title: 'Notifications & Alerts',
      subtitle: 'Emergency alerts and updates',
      icon: Icons.notifications_active,
      color: Colors.orange,
      page: VolunteerNotificationsPage(currentLat: 0, currentLng: 0),
    ),
    VolunteerFeature(
      title: 'Blood Donation',
      subtitle: 'Volunteer for blood donation',
      icon: Icons.bloodtype,
      color: Colors.red,
      page: BloodDonationVolunteerPage(volunteerId: 0),
    ),
    VolunteerFeature(
      title: 'Donation History',
      subtitle: 'View your donation records',
      icon: Icons.history,
      color: Colors.purple,
      page: BloodDonationHistoryPage(volunteerId: 0),
    ),
    VolunteerFeature(
      title: 'Feedback & Ratings',
      subtitle: 'Share your experience',
      icon: Icons.star_rate,
      color: Colors.amber,
      page: VolunteerFeedbackPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeVolunteer();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _alertTimer?.cancel();
    _statsTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeVolunteer() async {
    await _loadVolunteerData();
    await _checkLocationServices();
    await _fetchVolunteerLocation();
    await _loadVolunteerStats();
    
    // Set up timers
    _locationTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _fetchVolunteerLocation(),
    );
    
    _alertTimer = Timer.periodic(
      const Duration(minutes: 2),
      (_) => _fetchLatestAlert(),
    );
    
    _statsTimer = Timer.periodic(
      const Duration(minutes: 10),
      (_) => _loadVolunteerStats(),
    );
  }

  Future<void> _loadVolunteerData() async {
    try {
      // Load volunteer name from API or local storage
      // For now, we'll use a placeholder
      setState(() {
        _volunteerName = 'Volunteer ${lid.toString()}';
      });
    } catch (e) {
      debugPrint('Error loading volunteer data: $e');
    }
  }

  Future<void> _checkLocationServices() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      final permission = await Geolocator.checkPermission();
      
      setState(() {
        _isLocationEnabled = serviceEnabled;
        _hasLocationPermission = permission == LocationPermission.always ||
                                 permission == LocationPermission.whileInUse;
        
        if (!serviceEnabled) {
          _locationStatus = 'Location services disabled';
        } else if (!_hasLocationPermission) {
          _locationStatus = 'Location permission needed';
        } else {
          _locationStatus = 'Ready for emergencies';
        }
      });
    } catch (e) {
      debugPrint('Error checking location services: $e');
    }
  }

  Future<void> _fetchVolunteerLocation() async {
    try {
      if (!_hasLocationPermission) {
        await _requestLocationPermission();
      }
      
      if (_hasLocationPermission) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        
        setState(() {
          _volunteerLat = position.latitude;
          _volunteerLon = position.longitude;
          _currentPosition = position;
          _locationStatus = 'Location updated ${DateFormat('hh:mm a').format(DateTime.now())}';
        });
        
        // Update location on server (if needed)
        await _updateLocationOnServer();
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      setState(() {
        _locationStatus = 'Location error: ${e.toString()}';
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    setState(() {
      _hasLocationPermission = permission == LocationPermission.always ||
                              permission == LocationPermission.whileInUse;
    });
  }

  Future<void> _updateLocationOnServer() async {
    try {
      if (_volunteerLat != null && _volunteerLon != null) {
        await _dio.post(
          '$baseurl/volunteer-location/$lid',
          data: {
            'latitude': _volunteerLat,
            'longitude': _volunteerLon,
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
      }
    } catch (e) {
      debugPrint('Error updating location on server: $e');
    }
  }

  Future<void> _loadVolunteerStats() async {
    try {
      final tasksResponse = await _dio.get('$baseurl/volunteer-tasks/$lid');
      final alertsResponse = await _dio.get('$baseurl/volunteer-alerts/$lid');
      final donationsResponse = await _dio.get('$baseurl/volunteer-donations/$lid');
      
      setState(() {
        _totalTasks = tasksResponse.data['total'] ?? 0;
        _completedTasks = tasksResponse.data['completed'] ?? 0;
        _activeAlerts = alertsResponse.data['active'] ?? 0;
        _bloodDonations = donationsResponse.data['total'] ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading volunteer stats: $e');
      setState(() => _isLoading = false);
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // km
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = pow(sin(dLat / 2), 2) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * pow(sin(dLon / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180);

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return double.tryParse(value.toString());
  }

  Future<void> _fetchLatestAlert() async {
    if (_volunteerLat == null || _volunteerLon == null) return;

    try {
      final response = await _dio.get("$baseurl/alert");
      if (response.statusCode == 200 && response.data['id'] != null) {
        final alertData = response.data;

        final alertLat = _parseDouble(alertData['Latitude']);
        final alertLon = _parseDouble(alertData['Longitude']);

        if (alertLat != null && alertLon != null) {
          final distance = _calculateDistance(_volunteerLat!, _volunteerLon!, alertLat, alertLon);

          if (distance <= 5 && _lastAlertId != alertData['id']) {
            _lastAlertId = alertData['id'];
            _showEmergencyAlert(alertData, alertLat, alertLon, distance);
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching alert: $e");
    }
  }

  void _showEmergencyAlert(Map<String, dynamic> alertData, double alertLat, double alertLon, double distance) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EmergencyAlertDialog(
        alertData: alertData,
        distance: distance,
        onViewMap: () {
          Navigator.pop(context);
          _showMap(alertLat, alertLon, alertData['Alert'] ?? 'Emergency');
        },
        onRespond: () {
          Navigator.pop(context);
          _respondToEmergency(alertData);
        },
        onDismiss: () => Navigator.pop(context),
      ),
    );
  }

  void _showMap(double lat, double lon, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(title),
            backgroundColor: Colors.redAccent,
          ),
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
                  if (_volunteerLat != null && _volunteerLon != null)
                    Marker(
                      width: 60,
                      height: 60,
                      point: LatLng(_volunteerLat!, _volunteerLon!),
                      child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
                    ),
                ],
              ),
              // PolylineLayer(
              //   polylines: _volunteerLat != null && _volunteerLon != null
              //       ? [
              //           Polyline(
              //             points: [
              //               LatLng(_volunteerLat!, _volunteerLon!),
              //               LatLng(lat, lon),
              //             ],
              //             color: Colors.red,
              //             strokeWidth: 3,
              //           ),
              //         ]
              //       : [],
              // ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pop(context),
            child: Icon(Icons.close),
            backgroundColor: Colors.redAccent,
          ),
        ),
      ),
    );
  }

  Future<void> _respondToEmergency(Map<String, dynamic> alertData) async {
    try {
      await _dio.post(
        '$baseurl/emergency-response/$lid',
        data: {
          'alert_id': alertData['id'],
          'volunteer_lat': _volunteerLat,
          'volunteer_lon': _volunteerLon,
          'response_time': DateTime.now().toIso8601String(),
          'status': 'responding',
        },
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Emergency response initiated'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      debugPrint('Error responding to emergency: $e');
    }
  }

  Widget _buildLocationCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _volunteerLat != null ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _volunteerLat != null ? Icons.location_on : Icons.location_off,
                    color: _volunteerLat != null ? Colors.green : Colors.orange,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _locationStatus,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      if (_volunteerLat != null)
                        Text(
                          'Lat: ${_volunteerLat!.toStringAsFixed(4)}, Lng: ${_volunteerLon!.toStringAsFixed(4)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _fetchVolunteerLocation,
              icon: Icon(Icons.refresh, size: 18),
              label: Text('Refresh Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Volunteer Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(Icons.task, '$_completedTasks/$_totalTasks', 'Tasks'),
                _buildStatItem(Icons.warning, '$_activeAlerts', 'Alerts'),
                _buildStatItem(Icons.bloodtype, '$_bloodDonations', 'Donations'),
                _buildStatItem(Icons.star, '4.8', 'Rating'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
          ),
          child: Icon(icon, size: 24, color: Colors.redAccent),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(VolunteerFeature feature) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToFeature(feature),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: feature.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  feature.icon,
                  size: 28,
                  color: feature.color,
                ),
              ),
              SizedBox(height: 12),
              Text(
                feature.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 4),
              Text(
                feature.subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToFeature(VolunteerFeature feature) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          if (feature.page is VolunteerNotificationsPage) {
            return VolunteerNotificationsPage(
              currentLat: _volunteerLat ?? 0,
              currentLng: _volunteerLon ?? 0,
            );
          } else if (feature.page is BloodDonationVolunteerPage) {
            return BloodDonationVolunteerPage(volunteerId: lid!);
          } else if (feature.page is BloodDonationHistoryPage) {
            return BloodDonationHistoryPage(volunteerId: lid!);
          }
          return feature.page;
        },
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 10),
            Text('Logout'),
          ],
        ),
        content: Text('Are you sure you want to logout from the volunteer module?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _performLogout() {
    // Clear timers
    _locationTimer?.cancel();
    _alertTimer?.cancel();
    _statsTimer?.cancel();
    
    // Navigate to login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Volunteer Module',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _volunteerName,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            onPressed: _showLogoutConfirmation,
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.redAccent),
                  SizedBox(height: 20),
                  Text(
                    'Loading volunteer data...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.volunteer_activism,
                              size: 35,
                              color: Colors.redAccent,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome, $_volunteerName!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Ready to serve your community',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.circle, size: 8, color: Colors.white),
                                SizedBox(width: 6),
                                Text(
                                  'ACTIVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Location Card
                  _buildLocationCard(),

                  SizedBox(height: 16),

                  // Stats Card
                  _buildStatsCard(),

                  SizedBox(height: 24),

                  // Features Header
                  Text(
                    'Volunteer Features',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Access all volunteer tools and services',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Features Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: _features.length,
                    itemBuilder: (context, index) {
                      return _buildFeatureCard(_features[index]);
                    },
                  ),

                  SizedBox(height: 30),

                  // Emergency Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.emergency, size: 30, color: Colors.redAccent),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Emergency Response',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Be prepared for nearby emergencies',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (_volunteerLat != null) {
                              _fetchLatestAlert();
                            }
                          },
                          icon: Icon(Icons.warning, size: 18),
                          label: Text('Check Alerts'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
      floatingActionButton: _volunteerLat == null
          ? FloatingActionButton.extended(
              onPressed: _fetchVolunteerLocation,
              icon: Icon(Icons.location_on),
              label: Text('Enable Location'),
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }
}

// Data Models
class VolunteerFeature {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget page;

  const VolunteerFeature({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.page,
  });
}

class EmergencyAlertDialog extends StatelessWidget {
  final Map<String, dynamic> alertData;
  final double distance;
  final VoidCallback onViewMap;
  final VoidCallback onRespond;
  final VoidCallback onDismiss;

  const EmergencyAlertDialog({
    super.key,
    required this.alertData,
    required this.distance,
    required this.onViewMap,
    required this.onRespond,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
          SizedBox(width: 10),
          Text('EMERGENCY ALERT!'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            alertData['Alert'] ?? 'Emergency Reported',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('Distance: ${distance.toStringAsFixed(2)} km'),
          if (alertData['description'] != null)
            Text('Details: ${alertData['description']}'),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Urgent assistance needed nearby',
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: Text('Dismiss'),
        ),
        ElevatedButton(
          onPressed: onViewMap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: Text('View Map'),
        ),
        ElevatedButton(
          onPressed: onRespond,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: Text('Respond'),
        ),
      ],
    );
  }
}