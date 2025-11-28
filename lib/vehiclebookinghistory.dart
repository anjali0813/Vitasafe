import 'package:flutter/material.dart';

class VehicleBookingHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> historyList = [
    {
      'vehicle': 'Ambulance – Type A',
      'date': '2025-02-10',
      'pickup': 'Main Road, Perumpilavu',
      'status': 'Completed',
    },
    {
      'vehicle': 'Ambulance – Type B',
      'date': '2025-01-28',
      'pickup': 'Kunnamkulam Town',
      'status': 'Cancelled',
    },
    {
      'vehicle': 'Ambulance – Type C',
      'date': '2025-01-15',
      'pickup': 'Thrissur Round',
      'status': 'Confirmed',
    },
  ];

  VehicleBookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Booking History"),
        backgroundColor: Colors.redAccent,
      ),
      body: historyList.isEmpty
          ? const Center(
              child: Text(
                "No vehicle booking history found.",
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
                          item['vehicle'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text("Pickup Location: ${item['pickup']}",
                            style: const TextStyle(fontSize: 15)),
                        Text("Date: ${item['date']}",
                            style: const TextStyle(fontSize: 15)),
                        Text(
                          "Status: ${item['status']}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: item['status'] == 'Completed'
                                ? Colors.green
                                : item['status'] == 'Confirmed'
                                    ? Colors.orange
                                    : Colors.red,
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
