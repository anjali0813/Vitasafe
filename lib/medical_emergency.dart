import 'package:flutter/material.dart';

class MedicalEmergencyPage extends StatefulWidget {
  const MedicalEmergencyPage({super.key});

  @override
  State<MedicalEmergencyPage> createState() => _MedicalEmergencyPageState();
}

class _MedicalEmergencyPageState extends State<MedicalEmergencyPage> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Emergency"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Report a Medical Emergency",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: "Emergency Location",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Patient Condition (Optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : _submitAlert,
                icon: const Icon(Icons.local_hospital),
                label: Text(isSubmitting ? "Sending..." : "Send Alert"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitAlert() async {
    if (locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the emergency location.")),
      );
      return;
    }

    setState(() => isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Medical emergency alert sent!")),
    );

    locationController.clear();
    descriptionController.clear();
  }
}
