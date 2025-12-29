import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/Doctorbook.dart';
import 'package:vitasafe/reg_api.dart';

class HospitalDoctorsPage extends StatefulWidget {
  final int hospitalId;
  final String hospitalName;

  const HospitalDoctorsPage({
    super.key,
    required this.hospitalId,
    required this.hospitalName,
  });

  @override
  State<HospitalDoctorsPage> createState() => _HospitalDoctorsPageState();
}

class _HospitalDoctorsPageState extends State<HospitalDoctorsPage> {
  bool isLoading = true;
  List doctors = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    try {
      final response = await Dio().get('$baseurl/Doctor_view/${widget.hospitalId}');
      print(response.data);
      
      if (response.statusCode == 200 && response.data is List) {
        setState(() {
          doctors = response.data;
          isLoading = false;
        });
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      debugPrint("Doctor fetch error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctors - ${widget.hospitalName}"),
        backgroundColor: Colors.redAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : doctors.isEmpty
              ? const Center(
                  child: Text(
                    "No doctors found for this hospital.",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doc = doctors[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      elevation: 3,
                      child: ListTile(
                        onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DoctorBookingPage(
        doctorId: doc['id'],      // adjust ID key
        doctorName: doc['DoctorName'],   // adjust key
        specialization: doc['Department'],
      ),
    ),
  );
},
                        title: Text(
                          doc['DoctorName'] ?? "Unknown Doctor",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Specialization: ${doc['Department'] ?? 'N/A'}"),
                            Text("Place: ${doc['Place'] ?? 'N/A'}"),
                            Text("Phone: ${doc['contact_no'] ?? 'N/A'}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
