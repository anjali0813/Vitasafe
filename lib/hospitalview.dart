// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:vitasafe/Doctorview.dart';
// import 'package:vitasafe/reg_api.dart';

// class HospitalView extends StatefulWidget {
//   const HospitalView({super.key});

//   @override
//   State<HospitalView> createState() => _HospitalViewState();
// }

// class _HospitalViewState extends State<HospitalView> {
//   List<dynamic> hospitals = [];
//   bool isLoading = true;
//   late Position userPosition;

//   @override
//   void initState() {
//     super.initState();
//     _initialize();
//   }

//   Future<void> _initialize() async {
//     try {
//       await _getUserLocation();
//       await _fetchHospitals();
//     } catch (e) {
//       debugPrint('Initialization error: $e');
//       setState(() => isLoading = false);
//     }
//   }

//   /// Get current user's latitude and longitude
//   Future<void> _getUserLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) throw Exception("Location services are disabled.");

//     LocationPermission permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       throw Exception("Location permissions are denied.");
//     }

//     userPosition = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }

//   /// Fetch hospital list from your API (replace URL)
//   Future<void> _fetchHospitals() async {
//     try {
      

//       final response = await Dio().get('$baseurl/Hospital_view');
//       print(response.data);

//       if (response.statusCode == 200 && response.data is List) {
//         List data = response.data;

//         // Compute distance for each hospital
//         List nearbyHospitals = [];
//         for (var hospital in data) {
//           double lat = double.tryParse(hospital['latitude'].toString()) ?? 0.0;
//           double lng = double.tryParse(hospital['longitude'].toString()) ?? 0.0;

//           double distance = _calculateDistance(
//               userPosition.latitude, userPosition.longitude, lat, lng);

//           if (distance <= 5.0) {
//             // only include hospitals within 5 km
//             hospital['distance'] = distance;
//             nearbyHospitals.add(hospital);
//           }
//         }

//         // Sort by distance ascending
//         nearbyHospitals.sort((a, b) => a['distance'].compareTo(b['distance']));

//         setState(() {
//           hospitals = nearbyHospitals;
//           isLoading = false;
//         });
//       } else {
//         throw Exception("Invalid data format");
//       }
//     } catch (e) {
//       debugPrint('API error: $e');
//       setState(() => isLoading = false);
//     }
//   }

//   /// Haversine distance (in km)
//   double _calculateDistance(
//       double lat1, double lon1, double lat2, double lon2) {
//     const R = 6371; // Earth radius (km)
//     final dLat = _deg2rad(lat2 - lat1);
//     final dLon = _deg2rad(lon2 - lon1);
//     final a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
//             sin(dLon / 2) * sin(dLon / 2);
//     final c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c;
//   }

//   double _deg2rad(double deg) => deg * (pi / 180);

//   /// Launch a phone call
//   void _callHospital(String phone) async {
//     final uri = Uri.parse("tel:$phone");
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Hospitals Within 5 KM"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : hospitals.isEmpty
//               ? const Center(
//                   child: Text(
//                     "No hospitals found within 5 km radius.",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 )
//               : ListView.builder(
//                   itemCount: hospitals.length,
//                   itemBuilder: (context, index) {
//                     final hospital = hospitals[index];
//                     return Card(
//                       margin:
//                           const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: ListTile(
//   onTap: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => HospitalDoctorsPage(
//           hospitalId: hospital['id'],   // adjust field name if needed
//           hospitalName: hospital['HospitalName'] ?? 'Hospital',
//         ),
//       ),
//     );
//   },
//   title: Text(
//     hospital['HospitalName'] ?? 'Unnamed Hospital',
//     style: const TextStyle(
//       fontWeight: FontWeight.bold,
//       color: Colors.redAccent,
//     ),
//   ),
//   subtitle: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(hospital['Email'] ?? ''),
//       Text('Phone: ${hospital['Contact_no'] ?? 'N/A'}'),
//       Text('Address: ${hospital['Address'] ?? ''}'),
//       Text(
//         'Distance: ${hospital['distance']?.toStringAsFixed(2)} km',
//         style: const TextStyle(color: Colors.grey),
//       ),
//       // TextButton(onPressed: (){},
//       // child: Text("BED-BOOK", style: TextStyle(color: Colors.black)),
//       // style: TextButton.styleFrom(backgroundColor: Colors.grey),
//       // )
//     ],
//   ),
//   trailing: IconButton(
//     icon: const Icon(Icons.call, color: Colors.green),
//     onPressed: () => _callHospital(hospital['Contact_no']),
//   ),
// )

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

class HospitalView extends StatefulWidget {
  const HospitalView({super.key});

  @override
  State<HospitalView> createState() => _HospitalViewState();
}

class _HospitalViewState extends State<HospitalView> {
  List<dynamic> hospitals = [];
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
      await _fetchHospitals();
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

  Future<void> _fetchHospitals() async {
    if (userPosition == null) {
      throw Exception("User location not available");
    }

    try {
      final response = await Dio().get(
        'YOUR_BASE_URL/Hospital_view',
        options: Options(
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is! List) {
          throw Exception("Invalid data format received from server");
        }

        List data = response.data;
        List nearbyHospitals = [];

        for (var hospital in data) {
          if (hospital['latitude'] == null || hospital['longitude'] == null) {
            continue;
          }

          double lat = double.tryParse(hospital['latitude'].toString()) ?? 0.0;
          double lng = double.tryParse(hospital['longitude'].toString()) ?? 0.0;

          if (lat == 0.0 || lng == 0.0) continue;

          double distance = _calculateDistance(
            userPosition!.latitude,
            userPosition!.longitude,
            lat,
            lng,
          );

          if (distance <= radiusKm) {
            hospital['distance'] = distance;
            nearbyHospitals.add(hospital);
          }
        }

        nearbyHospitals.sort((a, b) => a['distance'].compareTo(b['distance']));

        setState(() {
          hospitals = nearbyHospitals;
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
      throw Exception("Failed to load hospitals: ${e.toString()}");
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180);

  Future<void> _callHospital(String? phone) async {
    if (phone == null || phone.isEmpty) {
      _showSnackBar("Phone number not available", Colors.orange);
      return;
    }

    try {
      final uri = Uri.parse("tel:${phone.replaceAll(RegExp(r'[^0-9+]'), '')}");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _showSnackBar("Cannot make phone calls", Colors.red);
      }
    } catch (e) {
      _showSnackBar("Error making call", Colors.red);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Nearby Hospitals",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.red[700],
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
                colors: [Colors.red[700]!, Colors.red[500]!],
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
                    const Icon(Icons.local_hospital, color: Colors.white, size: 24),
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
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
            const SizedBox(height: 16),
            Text(
              "Finding nearby hospitals...",
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
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (hospitals.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "No Hospitals Found",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "No hospitals found within ${radiusKm.toStringAsFixed(0)} km radius of your location.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _initialize,
                icon: const Icon(Icons.refresh),
                label: const Text("Refresh"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
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
      itemCount: hospitals.length,
      itemBuilder: (context, index) => _buildHospitalCard(hospitals[index], index),
    );
  }

  Widget _buildHospitalCard(dynamic hospital, int index) {
    final name = hospital['HospitalName']?.toString() ?? 'Unnamed Hospital';
    final email = hospital['Email']?.toString() ?? 'N/A';
    final phone = hospital['Contact_no']?.toString() ?? 'N/A';
    final address = hospital['Address']?.toString() ?? 'Address not available';
    final distance = hospital['distance'] as double? ?? 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to hospital details or doctors page
          // Uncomment if you have the HospitalDoctorsPage
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => HospitalDoctorsPage(
          //       hospitalId: hospital['id'],
          //       hospitalName: name,
          //     ),
          //   ),
          // );
        },
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
                      color: index == 0 ? Colors.green : Colors.red[700],
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
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
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

              // Contact Information
              _buildInfoRow(Icons.email, email),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.phone, phone),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.location_city, address),

              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _callHospital(phone),
                      icon: const Icon(Icons.call, size: 18),
                      label: const Text("Call Now"),
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
                      onPressed: () {
                        // Navigate to doctors or booking page
                        _showSnackBar("Feature coming soon", Colors.blue);
                      },
                      icon: const Icon(Icons.medical_services, size: 18),
                      label: const Text("View Details"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
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

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}