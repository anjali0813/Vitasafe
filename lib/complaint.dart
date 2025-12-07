import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class ComplaintPage extends StatefulWidget {


  const ComplaintPage({super.key});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final TextEditingController complaintController = TextEditingController();


  List complaints = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadComplaints();
  }

  /// --------------------------- GET COMPLAINTS ---------------------------
  Future<void> loadComplaints() async {
    try {
      final response = await dio.get("$baseurl/complaints/$lid");

      if (response.statusCode == 200) {
        setState(() {
          complaints = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("GET Error: $e");
      setState(() => isLoading = false);
    }
  }

  /// --------------------------- POST COMPLAINT ---------------------------
  Future<void> submitComplaint() async {
    String complaintText = complaintController.text.trim();

    if (complaintText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complaint cannot be empty")),
      );
      return;
    }

    try {
      final response = await dio.post(
        "$baseurl/complaints/$lid",
        data: {"Complaint": complaintText},
      );

      if (response.statusCode == 200) {
        complaintController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Complaint submitted successfully")),
        );
        loadComplaints(); // refresh list
      }
    } catch (e) {
      print("POST Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit complaint")),
      );
    }
  }

  /// --------------------------- UI ---------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complaint Page"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 175, 156, 148),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              /// ----------- Complaint Input ------------
              TextFormField(
                controller: complaintController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Enter your complaint',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// ----------- Submit Button ------------
              Center(
                child: ElevatedButton(
                  onPressed: submitComplaint,
                  child: const Text("SUBMIT"),
                ),
              ),
              const SizedBox(height: 20),

              /// ----------- Previous Complaints Title ------------
              const Text(
                "Previous Complaints",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              /// ----------- Complaints List ------------
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : complaints.isEmpty
                      ? const Center(child: Text("No complaints found"))
                      : ListView.builder(
                          shrinkWrap: true, // important for scrolling inside column
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: complaints.length,
                          itemBuilder: (context, index) {
                            final c = complaints[index];

                            return Card(
                              child: ListTile(
                                title: Text(c["Complaint"]),
                                subtitle: Text(
                                  "Reply: ${c["Reply"] ?? "Pending"}",
                                ),
                                trailing: Text(c["Date"] ?? ""),
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
