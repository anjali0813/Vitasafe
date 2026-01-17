// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/reg_api.dart';

// class VolunteerNotificationsPage extends StatefulWidget {
//   final double currentLat;
//   final double currentLng;

//   const VolunteerNotificationsPage({
//     super.key,
//     required this.currentLat,
//     required this.currentLng,
//   });

//   @override
//   State<VolunteerNotificationsPage> createState() =>
//       _VolunteerNotificationsPageState();
// }

// class _VolunteerNotificationsPageState
//     extends State<VolunteerNotificationsPage> {
//   List alerts = [];

//   final Distance distance = Distance();

//   Future<void> fetchAlerts() async {
//     try {
//       final response = await dio.get('$baseurl/view_alerts');
//       if (response.statusCode == 200 && response.data is List) {
//         // Filter alerts within 5 km
//         List nearby = [];
//         for (var alert in response.data) {
//           if (alert['Latitude'] != null && alert['Longitude'] != null) {
//             final km = distance(
//               LatLng(widget.currentLat, widget.currentLng),
//               LatLng(alert['Latitude'], alert['Longitude']),
//             ) / 1000.0; // meters to km
//             if (km <= 5) {
//               nearby.add(alert);
//             }
//           }
//         }

//         setState(() {
//           alerts = nearby;
//         });
//       } else {
//         debugPrint("Failed to fetch alerts");
//       }
//     } catch (e) {
//       debugPrint("Alert fetch error: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchAlerts();
//   }

//   String formatTime(String dateString) {
//     DateTime date = DateTime.parse(dateString);
//     Duration diff = DateTime.now().difference(date);
//     if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
//     if (diff.inHours < 24) return "${diff.inHours} hours ago";
//     return "${diff.inDays} days ago";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Nearby Notifications"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: alerts.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: alerts.length,
//               itemBuilder: (context, index) {
//                 final alert = alerts[index];
//                 return Column(
//                   children: [
//                     NotificationTile(
//                       title: alert['Alert'] ?? "No Title",
//                       message: alert['Alert'] ?? "No details",
//                       time: formatTime(alert['Date']),
//                       icon: Icons.warning,
//                     ),
//                     // Map showing location
//                     if (alert['Latitude'] != null && alert['Longitude'] != null)
//                       SizedBox(
//                         height: 200,
//                         child: FlutterMap(
//                           options: MapOptions(
//                             initialCenter: LatLng(alert['Latitude'], alert['Longitude']),
//                             initialZoom: 15,
//                           ),
//                           children: [
//                             TileLayer(
//                               urlTemplate:
//                                   "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
//                               userAgentPackageName: 'com.example.vitasafe',
//                             ),
//                             MarkerLayer(
//                 markers: [
//                       Marker(
//                         width: 80,
//                         height: 80,
//                         point: LatLng(alert['Latitude'], alert['Longitude']),
//                         child: const Icon(Icons.location_on, color: Colors.red, size: 40),
//                       ),
//                 ],
//               ),
//                           ],
//                         ),
//                       ),
//                   ],
//                 );
//               },
//             ),
//     );
//   }
// }

// class NotificationTile extends StatelessWidget {
//   final String title;
//   final String message;
//   final String time;
//   final IconData icon;

//   const NotificationTile({
//     super.key,
//     required this.title,
//     required this.message,
//     required this.time,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: CircleAvatar(
//           radius: 25,
//           backgroundColor: Colors.redAccent.shade100,
//           child: Icon(icon, color: Colors.white),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(message),
//         trailing: Text(
//           time,
//           style: const TextStyle(fontSize: 12, color: Colors.grey),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vitasafe/reg_api.dart';

class VolunteerNotificationsPage extends StatefulWidget {
  final double currentLat;
  final double currentLng;

  const VolunteerNotificationsPage({
    super.key,
    required this.currentLat,
    required this.currentLng,
  });

  @override
  State<VolunteerNotificationsPage> createState() =>
      _VolunteerNotificationsPageState();
}

class _VolunteerNotificationsPageState
    extends State<VolunteerNotificationsPage> {
  List alerts = [];
  List<bool> showMap = []; // Track which alerts have map visible

  final Distance distance = Distance();

  Future<void> fetchAlerts() async {
    try {
      final response = await dio.get('$baseurl/view_alerts');
      if (response.statusCode == 200 && response.data is List) {
        List nearby = [];
        for (var alert in response.data) {
          if (alert['Latitude'] != null && alert['Longitude'] != null) {
            final km = distance(
              LatLng(widget.currentLat, widget.currentLng),
              LatLng(alert['Latitude'], alert['Longitude']),
            ) / 1000.0; // meters to km
            if (km <= 5) {
              nearby.add(alert);
            }
          }
        }
        setState(() {
          alerts = nearby;
          showMap = List.generate(nearby.length, (index) => false);
        });
      }
    } catch (e) {
      debugPrint("Alert fetch error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAlerts();
  }

  String formatTime(String dateString) {
    DateTime date = DateTime.parse(dateString);
    Duration diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hours ago";
    return "${diff.inDays} days ago";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Notifications"),
        backgroundColor: Colors.redAccent,
      ),
      body: alerts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NotificationTile(
                      title: alert['Alert'] ?? "No Title",
                      message: alert['Alert'] ?? "No details",
                      time: formatTime(alert['Date']),
                      icon: Icons.warning,
                    ),
                    if (alert['Latitude'] != null &&
                        alert['Longitude'] != null)
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            showMap[index] = !showMap[index];
                          });
                        },
                        icon: const Icon(Icons.map),
                        label: Text(showMap[index]
                            ? "Hide Map"
                            : "View on Map"),
                      ),
                    if (showMap[index])
                      SizedBox(
                        height: 200,
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter:
                                LatLng(alert['Latitude'], alert['Longitude']),
                            initialZoom: 15,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                              userAgentPackageName: 'com.example.vitasafe',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                        width: 80,
                        height: 80,
                        point: LatLng(alert['Latitude'], alert['Longitude']),
                        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final IconData icon;

  const NotificationTile({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.redAccent.shade100,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(message),
        trailing: Text(
          time,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}
  




//   import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:intl/intl.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/reg_api.dart';
// import 'package:dio/dio.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:url_launcher/url_launcher.dart';

// class VolunteerNotificationsPage extends StatefulWidget {
//   final double currentLat;
//   final double currentLng;

//   const VolunteerNotificationsPage({
//     super.key,
//     required this.currentLat,
//     required this.currentLng,
//   });

//   @override
//   State<VolunteerNotificationsPage> createState() =>
//       _VolunteerNotificationsPageState();
// }

// class _VolunteerNotificationsPageState
//     extends State<VolunteerNotificationsPage> {
//   List<EmergencyAlert> _alerts = [];
//   List<bool> _showMap = [];
//   List<bool> _showDetails = [];
//   List<bool> _showRoute = [];
//   bool _isLoading = true;
//   bool _hasError = false;
//   String _errorMessage = '';
//   String _filterType = 'All'; // All, Medical, Accident, Fire, Natural
//   String _sortBy = 'Newest'; // Newest, Closest, Urgent
//   final Dio _dio = Dio();
//   final Distance _distance = Distance();
//   Position? _currentPosition;
//   Timer? _refreshTimer;
//   double _maxDistance = 5.0; // km

//   @override
//   void initState() {
//     super.initState();
//     _fetchCurrentLocation();
//     _fetchAlerts();
//     _setupAutoRefresh();
//   }

//   @override
//   void dispose() {
//     _refreshTimer?.cancel();
//     super.dispose();
//   }

//   void _setupAutoRefresh() {
//     _refreshTimer = Timer.periodic(Duration(seconds: 30), (_) {
//       if (mounted) {
//         _fetchAlerts();
//       }
//     });
//   }

//   Future<void> _fetchCurrentLocation() async {
//     try {
//       final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       setState(() {
//         _currentPosition = position;
//       });
//     } catch (e) {
//       debugPrint('Error fetching current location: $e');
//     }
//   }

//   Future<void> _fetchAlerts() async {
//     if (!mounted) return;

//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//     });

//     try {
//       final response = await _dio.get(
//         '$baseurl/view_alerts',
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//           },
//         ),
//       );

//       if (response.statusCode == 200 && response.data is List) {
//         final List<dynamic> allAlerts = response.data;
//         final List<EmergencyAlert> nearbyAlerts = [];

//         for (var alert in allAlerts) {
//           try {
//             final lat = _parseDouble(alert['Latitude']);
//             final lng = _parseDouble(alert['Longitude']);

//             if (lat != null && lng != null) {
//               final distanceKm = _distance(
//                 LatLng(widget.currentLat, widget.currentLng),
//                 LatLng(lat, lng),
//               ) / 1000.0;

//               if (distanceKm <= _maxDistance) {
//                 final alertType = _determineAlertType(alert['Alert']?.toString() ?? '');
//                 final urgency = _determineUrgency(alert['Alert']?.toString() ?? '');
//                 final timestamp = alert['Date'] != null 
//                   ? DateTime.tryParse(alert['Date'].toString()) ?? DateTime.now()
//                   : DateTime.now();

//                 nearbyAlerts.add(EmergencyAlert(
//                   id: alert['id']?.toString() ?? '',
//                   title: alert['Alert']?.toString() ?? 'Emergency Alert',
//                   description: alert['description']?.toString() ?? 'No details available',
//                   latitude: lat,
//                   longitude: lng,
//                   distance: distanceKm,
//                   timestamp: timestamp,
//                   type: alertType,
//                   urgency: urgency,
//                   address: alert['address']?.toString(),
//                   contact: alert['contact']?.toString(),
//                   status: alert['status']?.toString() ?? 'active',
//                   reportedBy: alert['reported_by']?.toString(),
//                 ));
//               }
//             }
//           } catch (e) {
//             debugPrint('Error processing alert: $e');
//           }
//         }

//         setState(() {
//           _alerts = nearbyAlerts;
//           _showMap = List.generate(nearbyAlerts.length, (index) => false);
//           _showDetails = List.generate(nearbyAlerts.length, (index) => false);
//           _showRoute = List.generate(nearbyAlerts.length, (index) => false);
//           _isLoading = false;
//         });

//         _applyFilters(); // Apply initial filters
//       } else {
//         throw Exception('Failed to load alerts: ${response.statusCode}');
//       }
//     } on DioException catch (e) {
//       _handleApiError(e);
//     } catch (e) {
//       _handleGenericError(e.toString());
//     }
//   }

//   double? _parseDouble(dynamic value) {
//     if (value == null) return null;
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     if (value is String) return double.tryParse(value);
//     return double.tryParse(value.toString());
//   }

//   AlertType _determineAlertType(String alertText) {
//     final lowerText = alertText.toLowerCase();
//     if (lowerText.contains('medical') || lowerText.contains('hospital') || lowerText.contains('doctor')) {
//       return AlertType.medical;
//     } else if (lowerText.contains('accident') || lowerText.contains('crash') || lowerText.contains('vehicle')) {
//       return AlertType.accident;
//     } else if (lowerText.contains('fire')) {
//       return AlertType.fire;
//     } else if (lowerText.contains('natural') || lowerText.contains('flood') || lowerText.contains('earthquake')) {
//       return AlertType.natural;
//     }
//     return AlertType.other;
//   }

//   UrgencyLevel _determineUrgency(String alertText) {
//     final lowerText = alertText.toLowerCase();
//     if (lowerText.contains('urgent') || lowerText.contains('critical') || lowerText.contains('emergency')) {
//       return UrgencyLevel.critical;
//     } else if (lowerText.contains('serious') || lowerText.contains('severe')) {
//       return UrgencyLevel.high;
//     } else if (lowerText.contains('moderate') || lowerText.contains('medium')) {
//       return UrgencyLevel.medium;
//     }
//     return UrgencyLevel.low;
//   }

//   void _handleApiError(DioException e) {
//     String errorMessage = 'Failed to load alerts';
    
//     if (e.response != null) {
//       switch (e.response!.statusCode) {
//         case 401:
//           errorMessage = 'Session expired. Please login again.';
//           break;
//         case 403:
//           errorMessage = 'Access denied. Please check your permissions.';
//           break;
//         case 500:
//           errorMessage = 'Server error. Please try again later.';
//           break;
//       }
//     } else if (e.type == DioExceptionType.connectionTimeout) {
//       errorMessage = 'Connection timeout. Please check your internet.';
//     } else if (e.type == DioExceptionType.connectionError) {
//       errorMessage = 'No internet connection. Please connect and try again.';
//     }
    
//     setState(() {
//       _hasError = true;
//       _errorMessage = errorMessage;
//       _isLoading = false;
//     });
//   }

//   void _handleGenericError(String error) {
//     setState(() {
//       _hasError = true;
//       _errorMessage = 'Error: $error';
//       _isLoading = false;
//     });
//   }

//   void _applyFilters() {
//     List<EmergencyAlert> filtered = List.from(_alerts);
    
//     // Apply type filter
//     if (_filterType != 'All') {
//       filtered = filtered.where((alert) {
//         return alert.type.name == _filterType.toLowerCase();
//       }).toList();
//     }
    
//     // Apply sorting
//     filtered.sort((a, b) {
//       switch (_sortBy) {
//         case 'Newest':
//           return b.timestamp.compareTo(a.timestamp);
//         case 'Closest':
//           return a.distance.compareTo(b.distance);
//         case 'Urgent':
//           final aUrgency = a.urgency.index;
//           final bUrgency = b.urgency.index;
//           if (aUrgency != bUrgency) {
//             return aUrgency.compareTo(bUrgency);
//           }
//           return a.distance.compareTo(b.distance);
//         default:
//           return 0;
//       }
//     });
    
//     setState(() {
//       _alerts = filtered;
//     });
//   }

//   Future<void> _respondToAlert(EmergencyAlert alert) async {
//     try {
//       await _dio.post(
//         '$baseurl/alert-response/${alert.id}',
//         data: {
//           'volunteer_id': lid,
//           'response_time': DateTime.now().toIso8601String(),
//           'status': 'responding',
//           'volunteer_lat': widget.currentLat,
//           'volunteer_lng': widget.currentLng,
//         },
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               Icon(Icons.check_circle, color: Colors.white),
//               SizedBox(width: 10),
//               Text('Response recorded. Help is on the way!'),
//             ],
//           ),
//           backgroundColor: Colors.green,
//           duration: Duration(seconds: 3),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to record response: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> _openNavigation(EmergencyAlert alert) async {
//     final url = 'https://www.google.com/maps/dir/?api=1&destination=${alert.latitude},${alert.longitude}';
    
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Could not open navigation'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _showFilterDialog() {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       builder: (context) {
//         return Container(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Filter & Sort',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 20),
              
//               // Distance Filter
//               Text(
//                 'Maximum Distance: ${_maxDistance.toStringAsFixed(1)} km',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               Slider(
//                 value: _maxDistance,
//                 min: 1,
//                 max: 20,
//                 divisions: 19,
//                 label: '${_maxDistance.toStringAsFixed(1)} km',
//                 onChanged: (value) {
//                   setState(() => _maxDistance = value);
//                 },
//               ),
              
//               SizedBox(height: 20),
              
//               // Type Filter
//               Text(
//                 'Alert Type',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               SizedBox(height: 10),
//               Wrap(
//                 spacing: 8,
//                 children: [
//                   'All', 'Medical', 'Accident', 'Fire', 'Natural', 'Other'
//                 ].map((type) {
//                   return ChoiceChip(
//                     label: Text(type),
//                     selected: _filterType == type,
//                     onSelected: (selected) {
//                       setState(() => _filterType = type);
//                     },
//                   );
//                 }).toList(),
//               ),
              
//               SizedBox(height: 20),
              
//               // Sort Options
//               Text(
//                 'Sort By',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               SizedBox(height: 10),
//               Wrap(
//                 spacing: 8,
//                 children: [
//                   'Newest', 'Closest', 'Urgent'
//                 ].map((sort) {
//                   return ChoiceChip(
//                     label: Text(sort),
//                     selected: _sortBy == sort,
//                     onSelected: (selected) {
//                       setState(() => _sortBy = sort);
//                     },
//                   );
//                 }).toList(),
//               ),
              
//               SizedBox(height: 30),
              
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: Text('Cancel'),
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         _fetchAlerts();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.redAccent,
//                       ),
//                       child: Text('Apply'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAlertCard(EmergencyAlert alert, int index) {
//     return Card(
//       elevation: 4,
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: ExpansionTile(
//         initiallyExpanded: _showDetails[index],
//         onExpansionChanged: (expanded) {
//           setState(() => _showDetails[index] = expanded);
//         },
//         leading: Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: alert.type.color.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             alert.type.icon,
//             color: alert.type.color,
//             size: 28,
//           ),
//         ),
//         title: Text(
//           alert.title,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey[800],
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 4),
//             Row(
//               children: [
//                 Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
//                 SizedBox(width: 4),
//                 Text(
//                   '${alert.distance.toStringAsFixed(1)} km away',
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         trailing: Container(
//           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           decoration: BoxDecoration(
//             color: alert.urgency.color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: alert.urgency.color.withOpacity(0.3)),
//           ),
//           child: Text(
//             alert.urgency.label,
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.bold,
//               color: alert.urgency.color,
//             ),
//           ),
//         ),
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Description
//                 Text(
//                   alert.description,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[700],
//                   ),
//                 ),
                
//                 SizedBox(height: 12),
                
//                 // Alert Details
//                 Row(
//                   children: [
//                     Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
//                     SizedBox(width: 6),
//                     Text(
//                       DateFormat('MMM dd, hh:mm a').format(alert.timestamp),
//                       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                     ),
//                     Spacer(),
//                     Icon(Icons.person, size: 14, color: Colors.grey[600]),
//                     SizedBox(width: 6),
//                     Text(
//                       alert.reportedBy ?? 'Anonymous',
//                       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
                
//                 SizedBox(height: 16),
                
//                 // Map Toggle Button
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     setState(() => _showMap[index] = !_showMap[index]);
//                   },
//                   icon: Icon(Icons.map, size: 18),
//                   label: Text(_showMap[index] ? 'Hide Map' : 'Show Map'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue[50],
//                     foregroundColor: Colors.blue[700],
//                     minimumSize: Size(double.infinity, 40),
//                   ),
//                 ),
                
//                 // Map Display
//                 if (_showMap[index]) ...[
//                   SizedBox(height: 12),
//                   Container(
//                     height: 200,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey[300]),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: FlutterMap(
//                         options: MapOptions(
//                           initialCenter: LatLng(alert.latitude, alert.longitude),
//                           initialZoom: 14,
//                         ),
//                         children: [
//                           TileLayer(
//                             urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
//                             userAgentPackageName: 'com.example.vitasafe',
//                           ),
//                           MarkerLayer(
//                             markers: [
//                               Marker(
//                                 width: 40,
//                                 height: 40,
//                                 point: LatLng(alert.latitude, alert.longitude),
//                                 child: Icon(
//                                   Icons.location_on,
//                                   color: Colors.red,
//                                   size: 30,
//                                 ),
//                               ),
//                               Marker(
//                                 width: 40,
//                                 height: 40,
//                                 point: LatLng(widget.currentLat, widget.currentLng),
//                                 child: Icon(
//                                   Icons.person_pin_circle,
//                                   color: Colors.blue,
//                                   size: 30,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           if (_showRoute[index])
//                             PolylineLayer(
//                               polylines: [
//                                 Polyline(
//                                   points: [
//                                     LatLng(widget.currentLat, widget.currentLng),
//                                     LatLng(alert.latitude, alert.longitude),
//                                   ],
//                                   color: Colors.red,
//                                   strokeWidth: 3,
//                                 ),
//                               ],
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () {
//                             setState(() => _showRoute[index] = !_showRoute[index]);
//                           },
//                           icon: Icon(Icons.route, size: 16),
//                           label: Text(_showRoute[index] ? 'Hide Route' : 'Show Route'),
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: () => _openNavigation(alert),
//                           icon: Icon(Icons.navigation, size: 16),
//                           label: Text('Navigate'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.redAccent,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
                
//                 SizedBox(height: 16),
                
//                 // Action Buttons
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         onPressed: () => _respondToAlert(alert),
//                         icon: Icon(Icons.check_circle, size: 18),
//                         label: Text('Respond'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           foregroundColor: Colors.white,
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     if (alert.contact != null)
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () {
//                             // Implement call functionality
//                           },
//                           icon: Icon(Icons.phone, size: 18),
//                           label: Text('Call'),
//                         ),
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.notifications_off,
//             size: 80,
//             color: Colors.grey[400],
//           ),
//           SizedBox(height: 20),
//           Text(
//             'No Nearby Alerts',
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[600],
//             ),
//           ),
//           SizedBox(height: 10),
//           Text(
//             'There are no emergency alerts within ${_maxDistance.toStringAsFixed(1)} km',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[500],
//             ),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton.icon(
//             onPressed: () {
//               setState(() => _maxDistance = 10.0);
//               _fetchAlerts();
//             },
//             icon: Icon(Icons.search),
//             label: Text('Increase Search Radius'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.redAccent,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline,
//             size: 80,
//             color: Colors.redAccent,
//           ),
//           SizedBox(height: 20),
//           Text(
//             'Unable to Load Alerts',
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[700],
//             ),
//           ),
//           SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40.0),
//             child: Text(
//               _errorMessage,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton.icon(
//             onPressed: _fetchAlerts,
//             icon: Icon(Icons.refresh),
//             label: Text('Try Again'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.redAccent,
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filteredAlerts = _alerts; // Already filtered by _applyFilters()
    
//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Emergency Alerts',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//               ),
//             ),
//             Text(
//               'Nearby emergencies within ${_maxDistance.toStringAsFixed(1)} km',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.white.withOpacity(0.8),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.redAccent,
//         foregroundColor: Colors.white,
//         elevation: 4,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.filter_list),
//             onPressed: _showFilterDialog,
//             tooltip: 'Filter & Sort',
//           ),
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: _fetchAlerts,
//             tooltip: 'Refresh',
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(color: Colors.redAccent),
//                   SizedBox(height: 20),
//                   Text(
//                     'Scanning for nearby emergencies...',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : _hasError
//               ? _buildErrorState()
//               : filteredAlerts.isEmpty
//                   ? _buildEmptyState()
//                   : Column(
//                       children: [
//                         // Stats Header
//                         Container(
//                           padding: EdgeInsets.all(16),
//                           color: Colors.redAccent.withOpacity(0.05),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               _buildStatChip(
//                                 '${filteredAlerts.length} Alerts',
//                                 Icons.warning,
//                                 Colors.orange,
//                               ),
//                               _buildStatChip(
//                                 '${filteredAlerts.where((a) => a.urgency == UrgencyLevel.critical).length} Critical',
//                                 Icons.emergency,
//                                 Colors.red,
//                               ),
//                               _buildStatChip(
//                                 'Within ${_maxDistance.toStringAsFixed(1)} km',
//                                 Icons.location_on,
//                                 Colors.blue,
//                               ),
//                             ],
//                           ),
//                         ),
                        
//                         // Alerts List
//                         Expanded(
//                           child: RefreshIndicator(
//                             onRefresh: _fetchAlerts,
//                             color: Colors.redAccent,
//                             backgroundColor: Colors.white,
//                             child: ListView.builder(
//                               padding: EdgeInsets.only(bottom: 20),
//                               itemCount: filteredAlerts.length,
//                               itemBuilder: (context, index) {
//                                 return _buildAlertCard(filteredAlerts[index], index);
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//       floatingActionButton: filteredAlerts.isNotEmpty
//           ? FloatingActionButton.extended(
//               onPressed: () {
//                 // Show critical alerts first
//                 final criticalAlerts = filteredAlerts.where((a) => a.urgency == UrgencyLevel.critical).toList();
//                 if (criticalAlerts.isNotEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('${criticalAlerts.length} critical alerts need attention!'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               icon: Icon(Icons.emergency),
//               label: Text('Critical Alerts'),
//               backgroundColor: Colors.redAccent,
//             )
//           : null,
//     );
//   }

//   Widget _buildStatChip(String text, IconData icon, Color color) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: color),
//           SizedBox(width: 6),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Data Models
// enum AlertType {
//   medical('Medical', Icons.local_hospital, Colors.green),
//   accident('Accident', Icons.car_crash, Colors.orange),
//   fire('Fire', Icons.fire_truck, Colors.red),
//   natural('Natural', Icons.flood, Colors.blue),
//   other('Other', Icons.warning, Colors.purple);

//   final String label;
//   final IconData icon;
//   final Color color;

//   const AlertType(this.label, this.icon, this.color);
// }

// enum UrgencyLevel {
//   critical('Critical', Colors.red),
//   high('High', Colors.orange),
//   medium('Medium', Colors.amber),
//   low('Low', Colors.blue);

//   final String label;
//   final Color color;

//   const UrgencyLevel(this.label, this.color);
// }

// class EmergencyAlert {
//   final String id;
//   final String title;
//   final String description;
//   final double latitude;
//   final double longitude;
//   final double distance;
//   final DateTime timestamp;
//   final AlertType type;
//   final UrgencyLevel urgency;
//   final String? address;
//   final String? contact;
//   final String status;
//   final String? reportedBy;

//   EmergencyAlert({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.latitude,
//     required this.longitude,
//     required this.distance,
//     required this.timestamp,
//     required this.type,
//     required this.urgency,
//     this.address,
//     this.contact,
//     required this.status,
//     this.reportedBy,
//   });
// }