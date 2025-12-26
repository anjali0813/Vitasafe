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
        const SnackBar(content: Text("Failed to fetch requests")),
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
          const SnackBar(content: Text("Request Accepted")),
        );
        fetchBloodRequests(); // refresh list
      }
    } catch (e) {
      debugPrint("Accept error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Accept failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Blood Requests"),
        backgroundColor: Colors.redAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
              ? const Center(
                  child: Text(
                    "No nearby blood requests",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final req = requests[index];

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      Colors.redAccent.shade100,
                                  child: const Icon(
                                    Icons.bloodtype,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Blood Group: ${req['Bloodgroup']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: req['status'] == "Accepted"
                                      ? null
                                      : () => acceptRequest(req['id']),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                  ),
                                  child: Text(req['status'] == "Accepted"
                                      ? "Accepted"
                                      : "Accept"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text("Status: ${req['status']}"),
                            const SizedBox(height: 4),
                            Text("User: ${req['user_name']}"),
                            // Text("Email: ${req['user_email']}"),
                            Text("Contact: ${req['user_no']}"),
                            // Text("DOB: ${req['user_dob']}"),
                            const SizedBox(height: 4),
                            // if (req['volunteer_name'] != "")
                              // Column(
                              //   crossAxisAlignment:
                              //       CrossAxisAlignment.start,
                              //   children: [
                              //     const Divider(),
                              //     Text(
                              //         "Volunteer: ${req['volunteer_name']}"),
                              //     Text(
                              //         "Volunteer Email: ${req['volunteer_email']}"),
                              //     Text(
                              //         "Volunteer Phone: ${req['volunteer_phone']}"),
                              //   ],
                              // ),
                            const SizedBox(height: 4),
                            Text(
                                "Location: ${req['user_latitude']}, ${req['user_longitude']}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
