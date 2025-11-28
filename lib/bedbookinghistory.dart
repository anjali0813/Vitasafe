import 'package:flutter/material.dart';

class BedBookingHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> historyList = [
    {
      'hospital': 'City Hospital',
      'date': '2025-01-12',
      'bedType': 'ICU',
      'status': 'Confirmed',
    },
    {
      'hospital': 'Green Valley Medical Center',
      'date': '2025-02-01',
      'bedType': 'General Ward',
      'status': 'Cancelled',
    },
  ];

  BedBookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bed Booking History"),
        backgroundColor: Colors.redAccent,
      ),
      body: historyList.isEmpty
          ? const Center(
              child: Text(
                "No booking history found.",
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
                          item['hospital'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text("Bed Type: ${item['bedType']}",
                            style: const TextStyle(fontSize: 15)),
                        Text("Date: ${item['date']}",
                            style: const TextStyle(fontSize: 15)),
                        Text("Status: ${item['status']}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: item['status'] == 'Confirmed'
                                  ? Colors.green
                                  : Colors.red,
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}