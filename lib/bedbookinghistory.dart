import 'package:flutter/material.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart'; // contains dio & lid

class BedBookingHistoryPage extends StatefulWidget {
  const BedBookingHistoryPage({super.key});

  @override
  State<BedBookingHistoryPage> createState() => _BedBookingHistoryPageState();
}

class _BedBookingHistoryPageState extends State<BedBookingHistoryPage> {

  Future<List<dynamic>> fetchBedBookingHistory() async {
    try {
      final response = await dio.get('$baseurl/bedbooking_history/$lid');
      print(response.data);
      if (response.statusCode == 200) {
        return response.data as List;
      } else {
        throw Exception('Failed to load booking history');
      }
    } catch (e) {
      debugPrint("Error fetching booking history: $e");
      throw Exception("Error fetching history");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bed Booking History"),
        backgroundColor: Colors.redAccent,
      ),

      body: FutureBuilder<List<dynamic>>(
        future: fetchBedBookingHistory(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading history"),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No booking history found.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final historyList = snapshot.data!;

          return ListView.builder(
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
                        item['hospital_name'] ?? "Unknown Hospital",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text("Ward: ${item['ward']}",
                          style: const TextStyle(fontSize: 15)),

                      Text("Date: ${item['date']}",
                          style: const TextStyle(fontSize: 15)),

                      Text(
                        "Status: ${item['Status']}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: item['Status'] == 'Confirmed'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
