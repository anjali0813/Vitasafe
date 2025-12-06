import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class VehicleBookingHistoryPage extends StatefulWidget {
  

  const VehicleBookingHistoryPage({super.key});

  @override
  State<VehicleBookingHistoryPage> createState() =>
      _VehicleBookingHistoryPageState();
}

class _VehicleBookingHistoryPageState
    extends State<VehicleBookingHistoryPage> {
  bool isLoading = true;
  List historyList = [];

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      final response = await Dio()
          .get("$baseurl/ambulancebooking_history/$lid");

      print(response.data);

      if (response.statusCode == 200) {
        setState(() {
          historyList = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching ambulance booking history: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ambulance Booking History"),
        backgroundColor: Colors.redAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : historyList.isEmpty
              ? const Center(
                  child: Text(
                    "No ambulance booking history found.",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    final item = historyList[index];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Driver: ${item['driver_name']}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 5),

                            Text("Hospital: ${item['hospital_name']}"),
                            Text("Vehicle No: ${item['vehicle_no']}"),
                            Text("Date: ${item['Date']}"),
                            Text(
                              "Status: ${item['status']}",
                              style: TextStyle(
                                color: item['status'] == "Completed"
                                    ? Colors.green
                                    : item['status'] == "Pending"
                                        ? Colors.orange
                                        : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
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
