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

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vitasafe/login_api.dart';
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
  