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
