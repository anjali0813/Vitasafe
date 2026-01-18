// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:vitasafe/reg_api.dart'; // contains baseurl

// class BloodDonationVolunteerPage extends StatefulWidget {
//   final int volunteerId;

//   const BloodDonationVolunteerPage({
//     super.key,
//     required this.volunteerId,
//   });

//   @override
//   State<BloodDonationVolunteerPage> createState() =>
//       _BloodDonationVolunteerPageState();
// }

// class _BloodDonationVolunteerPageState
//     extends State<BloodDonationVolunteerPage> {
//   List<dynamic> requests = [];
//   bool isLoading = true;

//   final Dio dio = Dio();

//   @override
//   void initState() {
//     super.initState();
//     fetchBloodRequests();
//   }

//   /// 🔹 Fetch blood requests (backend filters within 5 km)
//   Future<void> fetchBloodRequests() async {
//     try {
//       final response = await dio.get(
//         "$baseurl/requests",
//         queryParameters: {"volunteer_id": widget.volunteerId},
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           requests = response.data;
//           isLoading = false;
//         });
//         print(requests);
//       }
//     } catch (e) {
//       debugPrint("Fetch error: $e");
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to fetch requests")),
//       );
//     }
//   }

//   /// 🔹 Accept a blood request
//   Future<void> acceptRequest(int requestId) async {
//     try {
//       final response = await dio.post(
//         "$baseurl/acceptrequest/$requestId",
//         data: {"VolunteerID": widget.volunteerId},
//       );

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Request Accepted")),
//         );
//         fetchBloodRequests(); // refresh list
//       }
//     } catch (e) {
//       debugPrint("Accept error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Accept failed")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Nearby Blood Requests"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : requests.isEmpty
//               ? const Center(
//                   child: Text(
//                     "No nearby blood requests",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 )
//               : ListView.builder(
//                   padding: const EdgeInsets.all(12),
//                   itemCount: requests.length,
//                   itemBuilder: (context, index) {
//                     final req = requests[index];

//                     return Card(
//                       elevation: 4,
//                       margin: const EdgeInsets.only(bottom: 12),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 CircleAvatar(
//                                   backgroundColor:
//                                       Colors.redAccent.shade100,
//                                   child: const Icon(
//                                     Icons.bloodtype,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 Expanded(
//                                   child: Text(
//                                     "Blood Group: ${req['Bloodgroup']}",
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16),
//                                   ),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: req['status'] == "Accepted"
//                                       ? null
//                                       : () => acceptRequest(req['id']),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.redAccent,
//                                   ),
//                                   child: Text(req['status'] == "Accepted"
//                                       ? "Accepted"
//                                       : "Accept"),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             Text("Status: ${req['status']}"),
//                             const SizedBox(height: 4),
//                             Text("User: ${req['user_name']}"),
//                             // Text("Email: ${req['user_email']}"),
//                             Text("Contact: ${req['user_no']}"),
//                             // Text("DOB: ${req['user_dob']}"),
//                             const SizedBox(height: 4),
//                             // if (req['volunteer_name'] != "")
//                               // Column(
//                               //   crossAxisAlignment:
//                               //       CrossAxisAlignment.start,
//                               //   children: [
//                               //     const Divider(),
//                               //     Text(
//                               //         "Volunteer: ${req['volunteer_name']}"),
//                               //     Text(
//                               //         "Volunteer Email: ${req['volunteer_email']}"),
//                               //     Text(
//                               //         "Volunteer Phone: ${req['volunteer_phone']}"),
//                               //   ],
//                               // ),
//                             const SizedBox(height: 4),
//                             Text(
//                                 "Location: ${req['user_latitude']}, ${req['user_longitude']}"),
//                           ],
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
import 'package:vitasafe/reg_api.dart'; // contains baseurl

class BloodDonationVolunteerPage extends StatefulWidget {
  final int volunteerId;

  const BloodDonationVolunteerPage({
    super.key,
    required this.volunteerId,
  });

  @override
  State<BloodDonationVolunteerPage> createState() =>
      _BloodDonationVolunteerPageState();
}

class _BloodDonationVolunteerPageState
    extends State<BloodDonationVolunteerPage> {
  List<dynamic> requests = [];
  bool isLoading = true;

  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchBloodRequests();
  }

  /// 🔹 Fetch blood requests (backend filters within 5 km)
  Future<void> fetchBloodRequests() async {
    try {
      final response = await dio.get(
        "$baseurl/requests",
        queryParameters: {"volunteer_id": widget.volunteerId},
      );

      if (response.statusCode == 200) {
        setState(() {
          requests = response.data;
          isLoading = false;
        });
        print(requests);
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to fetch requests"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// 🔹 Accept a blood request
  Future<void> acceptRequest(int requestId) async {
    try {
      final response = await dio.post(
        "$baseurl/acceptrequest/$requestId",
        data: {"VolunteerID": widget.volunteerId},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text("Request Accepted Successfully"),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        fetchBloodRequests(); // refresh list
      }
    } catch (e) {
      debugPrint("Accept error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to accept request"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nearby Blood Requests",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.redAccent.withOpacity(0.05),
              Colors.redAccent.withOpacity(0.02),
            ],
          ),
        ),
        child: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.redAccent,
                      strokeWidth: 2.5,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Finding nearby blood requests...",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            : requests.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bloodtype_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No Blood Requests Nearby",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            "There are currently no blood donation requests within your 5km radius",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: fetchBloodRequests,
                          icon: Icon(Icons.refresh, size: 18),
                          label: Text("Refresh"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    color: Colors.redAccent,
                    onRefresh: fetchBloodRequests,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: requests.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final req = requests[index];
                        final isAccepted = req['status'] == "Accepted";

                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isAccepted
                                  ? Colors.green.shade100
                                  : Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          color: isAccepted
                              ? Colors.green.shade50.withOpacity(0.5)
                              : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header with blood group and accept button
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.bloodtype,
                                        color: Colors.redAccent,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Blood Group ${req['Bloodgroup']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isAccepted
                                                  ? Colors.green.withOpacity(0.1)
                                                  : Colors.orange.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              req['status'],
                                              style: TextStyle(
                                                color: isAccepted
                                                    ? Colors.green.shade700
                                                    : Colors.orange.shade700,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: isAccepted
                                          ? null
                                          : () => acceptRequest(req['id']),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isAccepted
                                            ? Colors.green.shade100
                                            : Colors.redAccent,
                                        foregroundColor: isAccepted
                                            ? Colors.green.shade700
                                            : Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isAccepted
                                                ? Icons.check_circle
                                                : Icons.bloodtype_outlined,
                                            size: 16,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            isAccepted ? "Accepted" : "Accept",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Divider(height: 1, color: Colors.grey.shade200),
                                SizedBox(height: 16),
                                // User information
                                _buildInfoRow(
                                  Icons.person,
                                  "Requester",
                                  req['user_name'],
                                ),
                                _buildInfoRow(
                                  Icons.phone,
                                  "Contact Number",
                                  req['user_no'],
                                ),
                                _buildInfoRow(
                                  Icons.location_on,
                                  "Location Coordinates",
                                  "${req['user_latitude']}, ${req['user_longitude']}",
                                ),
                                if (isAccepted) ...[
                                  SizedBox(height: 8),
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.green.shade100,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green.shade600,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "You have accepted this request",
                                            style: TextStyle(
                                              color: Colors.green.shade700,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchBloodRequests,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        child: Icon(Icons.refresh),
        elevation: 2,
      ),
    );
  }
}