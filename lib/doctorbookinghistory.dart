import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';
import 'package:vitasafe/review.dart';

class DoctorBookingHistoryPage extends StatefulWidget {
// USER LOGIN ID

  const DoctorBookingHistoryPage({super.key});

  @override
  State<DoctorBookingHistoryPage> createState() =>
      _DoctorBookingHistoryPageState();
}

class _DoctorBookingHistoryPageState extends State<DoctorBookingHistoryPage> {
  bool isLoading = true;
  List history = [];

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      final response =
          await Dio().get("$baseurl/doctor_booking_history/$lid");
          print(response.data);

      if (response.statusCode == 201) {
        setState(() {
          history = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching doctor booking history: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Booking History"),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : history.isEmpty
              ? const Center(
                  child: Text(
                    "No Booking History Found",
                    style: TextStyle(fontSize: 17),
                  ),
                )
              : ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['Doctor_name'] ?? 'Unknown Doctor',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),

                            Text("Hospital: ${item['Hosp_name']}"),
                            Text("Date: ${item['Date']}"),
                            Text("Time: ${item['Time']}"),
                            Text("Token: ${item['Token']}"),
                            Text("Status: ${item['Status']}"),

                            const SizedBox(height: 8),

                            ElevatedButton(
  onPressed: () {
    print(item['Hosp_id'].runtimeType);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewPage(
          hospitalId: item['Hosp_id'],
          hospitalName: item['Hosp_name'],
        ),
      ),
    );
  },
  child: const Text("Give Review"),
)


                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     Icon(Icons.local_hospital,
                            //         color: Colors.redAccent),
                            //     Text("  Hospital ID: ${item['Hosp_id']}"),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
