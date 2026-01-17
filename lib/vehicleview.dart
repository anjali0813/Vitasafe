// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:vitasafe/VehicleBook.dart';
// import 'package:vitasafe/reg_api.dart';

// class AmbulanceListPage extends StatefulWidget {
//   final int hospitalId;
//   final String hospitalName;

//   const AmbulanceListPage({
//     super.key,
//     required this.hospitalId,
//     required this.hospitalName,
//   });

//   @override
//   State<AmbulanceListPage> createState() => _AmbulanceListPageState();
// }

// class _AmbulanceListPageState extends State<AmbulanceListPage> {
//   List ambulances = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchAmbulances();
//   }

//   Future<void> _fetchAmbulances() async {
//     try {
//       final response = await Dio().get(
//         '$baseurl/ambulance_view/${widget.hospitalId}',
//       );

//       print(response.data);

//       if (response.statusCode == 200) {
//         setState(() {
//           ambulances = response.data;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching ambulances: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Ambulances - ${widget.hospitalName}"),
//         backgroundColor: Colors.blue,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ambulances.isEmpty
//               ? const Center(child: Text("No Ambulances Available"))
//               : ListView.builder(
//                   itemCount: ambulances.length,
//                   itemBuilder: (context, index) {
//                     final amb = ambulances[index];

//                     return Card(
//                       elevation: 3,
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 8, horizontal: 12),
//                       child: ListTile(
//                         title: Text(
//                           "Ambulance #${amb['id']}",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Driver: ${amb['Driver_name'] ?? 'N/A'}"),
//                             Text("Vehicle No: ${amb['Vehicle_no'] ?? 'N/A'}"),
//                             Text("Contact: ${amb['Contact_no'] ?? 'N/A'}"),
//                           ],
//                         ),
//                         trailing: ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     VehicleBookingPage(
//                                       ambulanceId: amb['id'],
//                                     ),
//                               ),
//                             );
//                           },
//                           child: const Text("BOOK"),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/VehicleBook.dart';
import 'package:vitasafe/reg_api.dart';
import 'package:url_launcher/url_launcher.dart';

class AmbulanceListPage extends StatefulWidget {
  final int hospitalId;
  final String hospitalName;

  const AmbulanceListPage({
    super.key,
    required this.hospitalId,
    required this.hospitalName,
  });

  @override
  State<AmbulanceListPage> createState() => _AmbulanceListPageState();
}

class _AmbulanceListPageState extends State<AmbulanceListPage> {
  List ambulances = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAmbulances();
  }

  Future<void> _fetchAmbulances() async {
    try {
      final response = await Dio().get(
        '$baseurl/ambulance_view/${widget.hospitalId}',
      );

      if (response.statusCode == 200) {
        setState(() {
          ambulances = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching ambulances: $e");
      setState(() => isLoading = false);
    }
  }

 Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri uri = Uri.parse('tel:$phoneNumber');
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ambulances - ${widget.hospitalName}"),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ambulances.isEmpty
              ? const Center(child: Text("No Ambulances Available"))
              : ListView.builder(
                  itemCount: ambulances.length,
                  itemBuilder: (context, index) {
                    final amb = ambulances[index];
                    final String phone =
                        amb['Contact_no']?.toString() ?? '';

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: ListTile(
                        title: Text(
                          "Ambulance #${amb['id']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Driver: ${amb['Driver_name'] ?? 'N/A'}"),
                            Text("Vehicle No: ${amb['Vehicle_no'] ?? 'N/A'}"),
                            Text("Contact: $phone"),
                          ],
                        ),

                        /// ✅ FIXED TRAILING (NO OVERFLOW)
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VehicleBookingPage(
                                      ambulanceId: amb['id'],
                                    ),
                                  ),
                                );
                              },
                              child: const Text("BOOK"),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              icon: const Icon(
                                Icons.call,
                                color: Colors.green,
                              ),
                              onPressed: phone.isEmpty
                                  ? null
                                  : () => _makePhoneCall(phone),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AmbulanceListPage extends StatefulWidget {
//   final int hospitalId;
//   final String hospitalName;

//   const AmbulanceListPage({
//     super.key,
//     required this.hospitalId,
//     required this.hospitalName,
//   });

//   @override
//   State<AmbulanceListPage> createState() => _AmbulanceListPageState();
// }

// class _AmbulanceListPageState extends State<AmbulanceListPage> {
//   List ambulances = [];
//   bool isLoading = true;
//   bool hasError = false;
//   String errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     _fetchAmbulances();
//   }

//   Future<void> _fetchAmbulances() async {
//     setState(() {
//       isLoading = true;
//       hasError = false;
//       errorMessage = '';
//     });

//     try {
//       final response = await Dio().get(
//         'YOUR_BASE_URL/ambulance_view/${widget.hospitalId}',
//         options: Options(
//           receiveTimeout: const Duration(seconds: 15),
//           sendTimeout: const Duration(seconds: 15),
//         ),
//       );

//       if (response.statusCode == 200) {
//         if (response.data is List) {
//           setState(() {
//             ambulances = response.data;
//             isLoading = false;
//           });
//         } else {
//           throw Exception("Invalid data format received");
//         }
//       } else {
//         throw Exception("Server error: ${response.statusCode}");
//       }
//     } on DioException catch (e) {
//       String message = "Network error";
//       if (e.type == DioExceptionType.connectionTimeout) {
//         message = "Connection timeout. Please check your internet.";
//       } else if (e.type == DioExceptionType.receiveTimeout) {
//         message = "Server response timeout.";
//       } else if (e.type == DioExceptionType.connectionError) {
//         message = "No internet connection.";
//       }
//       setState(() {
//         hasError = true;
//         errorMessage = message;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         hasError = true;
//         errorMessage = "Failed to load ambulances: ${e.toString()}";
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _makePhoneCall(String? phoneNumber) async {
//     if (phoneNumber == null || phoneNumber.isEmpty) {
//       _showSnackBar("Phone number not available", Colors.orange);
//       return;
//     }

//     try {
//       final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
//       final Uri uri = Uri.parse('tel:$cleanNumber');

//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       } else {
//         _showSnackBar("Cannot make phone calls", Colors.red);
//       }
//     } catch (e) {
//       _showSnackBar("Error making call", Colors.red);
//     }
//   }

//   void _showSnackBar(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _showAmbulanceDetails(dynamic ambulance) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.blue[50],
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(Icons.ambulance, color: Colors.blue[700], size: 32),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Ambulance #${ambulance['id']}",
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         ambulance['Ambulance_type']?.toString() ?? 'Standard',
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(height: 32),
//             _buildDetailRow(
//                 Icons.person, 'Driver', ambulance['Driver_name']?.toString() ?? 'N/A'),
//             const SizedBox(height: 12),
//             _buildDetailRow(Icons.directions_car, 'Vehicle Number',
//                 ambulance['Vehicle_no']?.toString() ?? 'N/A'),
//             const SizedBox(height: 12),
//             _buildDetailRow(
//                 Icons.phone, 'Contact', ambulance['Contact_no']?.toString() ?? 'N/A'),
//             const SizedBox(height: 12),
//             _buildDetailRow(Icons.local_hospital, 'Hospital', widget.hospitalName),
//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       _makePhoneCall(ambulance['Contact_no']?.toString());
//                     },
//                     icon: const Icon(Icons.call),
//                     label: const Text("Call"),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: Colors.green[700],
//                       side: BorderSide(color: Colors.green[700]!),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       // Navigate to booking page
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => VehicleBookingPage(
//                       //       ambulanceId: ambulance['id'],
//                       //       ambulanceName: "Ambulance #${ambulance['id']}",
//                       //       vehicleNumber: ambulance['Vehicle_no']?.toString(),
//                       //     ),
//                       //   ),
//                       // );
//                     },
//                     icon: const Icon(Icons.book_online),
//                     label: const Text("Book"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue[700],
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(IconData icon, String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, size: 20, color: Colors.grey[600]),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         elevation: 0,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Available Ambulances",
//               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//             ),
//             Text(
//               widget.hospitalName,
//               style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.blue[700],
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _fetchAmbulances,
//             tooltip: "Refresh",
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Header Info Card
//           Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.blue[700]!, Colors.blue[500]!],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.ambulance, color: Colors.white, size: 24),
//                 const SizedBox(width: 8),
//                 Text(
//                   "${ambulances.length} Ambulances Available",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Content Area
//           Expanded(
//             child: _buildContent(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContent() {
//     if (isLoading) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               "Loading ambulances...",
//               style: TextStyle(color: Colors.grey[600], fontSize: 14),
//             ),
//           ],
//         ),
//       );
//     }

//     if (hasError) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
//               const SizedBox(height: 16),
//               Text(
//                 "Error",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 errorMessage,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.grey[600]),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: _fetchAmbulances,
//                 icon: const Icon(Icons.refresh),
//                 label: const Text("Try Again"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue[700],
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (ambulances.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.local_hospital, size: 64, color: Colors.grey[400]),
//               const SizedBox(height: 16),
//               Text(
//                 "No Ambulances Available",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "No ambulances are currently available at this hospital.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.grey[600]),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: _fetchAmbulances,
//                 icon: const Icon(Icons.refresh),
//                 label: const Text("Refresh"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue[700],
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: ambulances.length,
//       itemBuilder: (context, index) => _buildAmbulanceCard(ambulances[index], index),
//     );
//   }

//   Widget _buildAmbulanceCard(dynamic ambulance, int index) {
//     final driverName = ambulance['Driver_name']?.toString() ?? 'N/A';
//     final vehicleNo = ambulance['Vehicle_no']?.toString() ?? 'N/A';
//     final contactNo = ambulance['Contact_no']?.toString() ?? 'N/A';
//     final ambulanceType = ambulance['Ambulance_type']?.toString() ?? 'Standard';
//     final isAvailable = ambulance['Status']?.toString().toLowerCase() != 'booked';

//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: InkWell(
//         onTap: () => _showAmbulanceDetails(ambulance),
//         borderRadius: BorderRadius.circular(16),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.blue[50],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       Icons.ambulance,
//                       color: Colors.blue[700],
//                       size: 28,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 "Ambulance #${ambulance['id']}",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.blue[700],
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: isAvailable ? Colors.green[50] : Colors.red[50],
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: isAvailable
//                                       ? Colors.green[200]!
//                                       : Colors.red[200]!,
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     isAvailable
//                                         ? Icons.check_circle
//                                         : Icons.cancel,
//                                     size: 14,
//                                     color: isAvailable
//                                         ? Colors.green[700]
//                                         : Colors.red[700],
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     isAvailable ? "Available" : "Booked",
//                                     style: TextStyle(
//                                       fontSize: 11,
//                                       fontWeight: FontWeight.bold,
//                                       color: isAvailable
//                                           ? Colors.green[700]
//                                           : Colors.red[700],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[200],
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             ambulanceType,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[700],
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//               const Divider(height: 24),

//               // Details
//               _buildInfoRow(Icons.person, 'Driver', driverName),
//               const SizedBox(height: 8),
//               _buildInfoRow(Icons.directions_car, 'Vehicle No', vehicleNo),
//               const SizedBox(height: 8),
//               _buildInfoRow(Icons.phone, 'Contact', contactNo),

//               const SizedBox(height: 16),

//               // Action Buttons
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () => _makePhoneCall(contactNo),
//                       icon: const Icon(Icons.call, size: 18),
//                       label: const Text("Call Driver"),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.green[700],
//                         side: BorderSide(color: Colors.green[700]!),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: isAvailable
//                           ? () {
//                               // Navigate to booking page
//                               // Navigator.push(
//                               //   context,
//                               //   MaterialPageRoute(
//                               //     builder: (context) => VehicleBookingPage(
//                               //       ambulanceId: ambulance['id'],
//                               //       ambulanceName: "Ambulance #${ambulance['id']}",
//                               //       ambulanceType: ambulanceType,
//                               //       vehicleNumber: vehicleNo,
//                               //     ),
//                               //   ),
//                               // );
//                               _showSnackBar("Booking feature - integrate with VehicleBookingPage", Colors.blue);
//                             }
//                           : null,
//                       icon: const Icon(Icons.book_online, size: 18),
//                       label: const Text("Book Now"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue[700],
//                         foregroundColor: Colors.white,
//                         disabledBackgroundColor: Colors.grey[300],
//                         disabledForegroundColor: Colors.grey[600],
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: Colors.grey[600]),
//         const SizedBox(width: 8),
//         Text(
//           "$label: ",
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey[600],
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }