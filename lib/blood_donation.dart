import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class BloodDonationVolunteerPage extends StatefulWidget {
  final int? volunteerId;
  final String? bloodgroup;


  const BloodDonationVolunteerPage({super.key, this.bloodgroup,required this.volunteerId});

  @override
  State<BloodDonationVolunteerPage> createState() => _BloodDonationVolunteerPageState();
}

class _BloodDonationVolunteerPageState extends State<BloodDonationVolunteerPage> {
  List<Map<String, String>> requests = [
    {
      'hospital': 'City Hospital',
      'blood_group': 'O+',
      'urgency': 'High',
      'time': 'Needed in 1 hour',
    },
    {
      'hospital': 'Metro Care Center',
      'blood_group': 'A-',
      'urgency': 'Medium',
      'time': 'Needed Today',
    },
    {
      'hospital': 'Green Valley Medical',
      'blood_group': 'B+',
      'urgency': 'Low',
      'time': 'Needed Tomorrow',
    }
  ];
  
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isSubmitting = false;
  
  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  Future<void> pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  Future<void> BloodDonationrequest() async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date and time")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final response = await Dio().post(
        "$baseurl/BloodDonation/$lid",
        data: {
          "VolunteerID": widget.volunteerId,
          "Bloodgroup": selectedDate.toString().split(" ")[0],
          // "Time": selectedTime!.format(context),
        },
      );

      if (response.statusCode == 200 || response.statusCode ==201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Appointment Booked Successfully!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Booking error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Booking failed")));
    }

    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blood Donation Volunteering"),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final req = requests[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 15),
            child: ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.redAccent.shade100,
                child: const Icon(Icons.bloodtype, color: Colors.white),
              ),
              title: Text(
                "Blood Group: ${req['blood_group']}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hospital: ${req['hospital']}",),
                  Text("Urgency: ${req['urgency']}",),
                  Text("Time: ${req['time']}",),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text("Volunteer"),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          _showRegisterDialog();
        },
      ),
    );
  }

  void _showRegisterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Register as Donor"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Thank you for your willingness to donate blood!"),
            SizedBox(height: 10),
            Text("An official will contact you for further steps."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
