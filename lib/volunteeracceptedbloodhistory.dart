import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/reg_api.dart'; // contains baseurl

class BloodDonationHistoryPage extends StatefulWidget {
  final int volunteerId;

  const BloodDonationHistoryPage({super.key, required this.volunteerId});

  @override
  State<BloodDonationHistoryPage> createState() =>
      _BloodDonationHistoryPageState();
}

class _BloodDonationHistoryPageState extends State<BloodDonationHistoryPage> {
  List<dynamic> history = [];
  bool isLoading = true;

  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  /// 🔹 Fetch accepted requests
  Future<void> fetchHistory() async {
    try {
      final response =
          await dio.get("$baseurl/history/${widget.volunteerId}");

      if (response.statusCode == 200) {
        setState(() {
          history = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("History fetch error: $e");
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch history")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accepted Blood Requests History"),
        backgroundColor: Colors.redAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : history.isEmpty
              ? const Center(
                  child: Text(
                    "No accepted blood requests yet.",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final req = history[index];

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.redAccent.shade100,
                          child: const Icon(
                            Icons.bloodtype,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          "Blood Group: ${req['Bloodgroup']}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text("Status: ${req['status']}"),
                            Text("User: ${req['user_name']}"),
                            Text("Contact: ${req['user_no']}"),
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
