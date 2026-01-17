// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:vitasafe/reg_api.dart';

// class NearbyVolunteersPage extends StatefulWidget {
//   const NearbyVolunteersPage({super.key});

//   @override
//   State<NearbyVolunteersPage> createState() => _NearbyVolunteersPageState();
// }

// class _NearbyVolunteersPageState extends State<NearbyVolunteersPage> {
//   final Dio dio = Dio();

//   List<dynamic> nearbyVolunteers = [];
//   bool loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchNearbyVolunteers();
//   }

//   // 📍 Fetch volunteers and filter within 5 KM
//   Future<void> _fetchNearbyVolunteers() async {
//     try {
//       // Request location permission
//       LocationPermission permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         return;
//       }

//       // Get current position
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       // API call
//       Response response = await dio.get('$baseurl/UserViewVolunteers');

//       List<dynamic> allVolunteers = response.data;

//       // Filter volunteers within 5 KM
//       nearbyVolunteers = allVolunteers.where((v) {
//         if (v['latitude'] == null || v['longitude'] == null) return false;

//         double distance = Geolocator.distanceBetween(
//           position.latitude,
//           position.longitude,
//           v['latitude'],
//           v['longitude'],
//         );

//         return distance <= 5000; // 5 KM
//       }).toList();
//     } catch (e) {
//       debugPrint('Error: $e');
//     }

//     setState(() => loading = false);
//   }

//   // 📞 Open dialpad
//    Future<void> _makePhoneCall(String phoneNumber) async {
//   final Uri uri = Uri.parse('tel:$phoneNumber');
//   await launchUrl(uri, mode: LaunchMode.externalApplication);
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Nearby Volunteers'),
//         centerTitle: true,
//       ),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : nearbyVolunteers.isEmpty
//               ? const Center(
//                   child: Text(
//                     'No volunteers within 5 KM',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 )
//               : ListView.builder(
//                   itemCount: nearbyVolunteers.length,
//                   itemBuilder: (context, index) {
//                     final v = nearbyVolunteers[index];

//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 6),
//                       elevation: 3,
//                       child: ListTile(
//                         leading: const CircleAvatar(
//                           backgroundColor: Colors.green,
//                           child: Icon(Icons.volunteer_activism,
//                               color: Colors.white),
//                         ),
//                         title: Text(
//                           v['Name'] ?? 'Unknown',
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 4),
//                             Text('Skills: ${v['Skills'] ?? '-'}'),
//                             Text('Phone: ${v['Phone'] ?? '-'}'),
//                           ],
//                         ),
//                         trailing: IconButton(
//                           icon: const Icon(Icons.call, color: Colors.green),
//                           onPressed: () {
//                             if (v['Phone'] != null) {
//                               _makePhoneCall(v['Phone'].toString());
//                             }
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }




import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyVolunteersPage extends StatefulWidget {
  const NearbyVolunteersPage({super.key});

  @override
  State<NearbyVolunteersPage> createState() => _NearbyVolunteersPageState();
}

class _NearbyVolunteersPageState extends State<NearbyVolunteersPage> {
  final Dio dio = Dio();

  List<dynamic> nearbyVolunteers = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  Position? userPosition;
  double radiusKm = 5.0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      await _getUserLocation();
      await _fetchNearbyVolunteers();
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled. Please enable location.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions denied. Please grant location access.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            "Location permissions are permanently denied. Please enable in settings.");
      }

      userPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      throw Exception("Failed to get location: ${e.toString()}");
    }
  }

  Future<void> _fetchNearbyVolunteers() async {
    if (userPosition == null) {
      throw Exception("User location not available");
    }

    try {
      final response = await dio.get(
        'YOUR_BASE_URL/UserViewVolunteers',
        options: Options(
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is! List) {
          throw Exception("Invalid data format received from server");
        }

        List<dynamic> allVolunteers = response.data;
        List<dynamic> filtered = [];

        for (var volunteer in allVolunteers) {
          if (volunteer['latitude'] == null || volunteer['longitude'] == null) {
            continue;
          }

          double lat = double.tryParse(volunteer['latitude'].toString()) ?? 0.0;
          double lng = double.tryParse(volunteer['longitude'].toString()) ?? 0.0;

          if (lat == 0.0 || lng == 0.0) continue;

          double distanceInMeters = Geolocator.distanceBetween(
            userPosition!.latitude,
            userPosition!.longitude,
            lat,
            lng,
          );

          double distanceInKm = distanceInMeters / 1000;

          if (distanceInKm <= radiusKm) {
            volunteer['distance'] = distanceInKm;
            filtered.add(volunteer);
          }
        }

        // Sort by distance
        filtered.sort((a, b) => a['distance'].compareTo(b['distance']));

        setState(() {
          nearbyVolunteers = filtered;
          isLoading = false;
        });
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } on DioException catch (e) {
      String message = "Network error";
      if (e.type == DioExceptionType.connectionTimeout) {
        message = "Connection timeout. Please check your internet.";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        message = "Server response timeout.";
      } else if (e.type == DioExceptionType.connectionError) {
        message = "No internet connection.";
      }
      throw Exception(message);
    } catch (e) {
      throw Exception("Failed to load volunteers: ${e.toString()}");
    }
  }

  Future<void> _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      _showSnackBar("Phone number not available", Colors.orange);
      return;
    }

    try {
      final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
      final Uri uri = Uri.parse('tel:$cleanNumber');
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showSnackBar("Cannot make phone calls", Colors.red);
      }
    } catch (e) {
      _showSnackBar("Error making call: ${e.toString()}", Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showVolunteerDetails(dynamic volunteer) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.volunteer_activism, 
                    color: Colors.green[700], size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        volunteer['Name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${volunteer['distance']?.toStringAsFixed(2)} km away",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildDetailRow(Icons.work, 'Skills', 
              volunteer['Skills']?.toString() ?? 'Not specified'),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.phone, 'Phone', 
              volunteer['Phone']?.toString() ?? 'Not available'),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.email, 'Email', 
              volunteer['Email']?.toString() ?? 'Not available'),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.location_on, 'Distance', 
              "${volunteer['distance']?.toStringAsFixed(2)} km"),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _makePhoneCall(volunteer['Phone']?.toString());
                },
                icon: const Icon(Icons.call),
                label: const Text("Call Volunteer"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Nearby Volunteers",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initialize,
            tooltip: "Refresh",
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Info Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[700]!, Colors.green[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.volunteer_activism, 
                      color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      "Within ${radiusKm.toStringAsFixed(0)} KM Radius",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (userPosition != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    "Your Location: ${userPosition!.latitude.toStringAsFixed(4)}, ${userPosition!.longitude.toStringAsFixed(4)}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 16),
            Text(
              "Finding nearby volunteers...",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                "Error",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _initialize,
                icon: const Icon(Icons.refresh),
                label: const Text("Try Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (nearbyVolunteers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_search, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "No Volunteers Found",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "No volunteers found within ${radiusKm.toStringAsFixed(0)} km radius of your location.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _initialize,
                icon: const Icon(Icons.refresh),
                label: const Text("Refresh"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: nearbyVolunteers.length,
      itemBuilder: (context, index) => _buildVolunteerCard(nearbyVolunteers[index], index),
    );
  }

  Widget _buildVolunteerCard(dynamic volunteer, int index) {
    final name = volunteer['Name']?.toString() ?? 'Unknown';
    final skills = volunteer['Skills']?.toString() ?? 'Not specified';
    final phone = volunteer['Phone']?.toString() ?? 'N/A';
    final email = volunteer['Email']?.toString() ?? 'N/A';
    final distance = volunteer['distance'] as double? ?? 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showVolunteerDetails(volunteer),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with ranking badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: index == 0 ? Colors.amber : Colors.green[700],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "#${index + 1}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green[200]!),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified, 
                                    size: 14, color: Colors.green[700]),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Verified",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              "${distance.toStringAsFixed(2)} km away",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 24),

              // Skills Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.work, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Skills",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          skills,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Contact Info
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.phone, size: 18, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            phone,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showVolunteerDetails(volunteer),
                      icon: const Icon(Icons.info_outline, size: 18),
                      label: const Text("Details"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green[700],
                        side: BorderSide(color: Colors.green[700]!),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _makePhoneCall(phone),
                      icon: const Icon(Icons.call, size: 18),
                      label: const Text("Call Now"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}