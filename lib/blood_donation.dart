import 'package:flutter/material.dart';

class BloodDonationVolunteerPage extends StatefulWidget {
  const BloodDonationVolunteerPage({super.key});

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
