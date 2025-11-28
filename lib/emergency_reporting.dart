import 'package:flutter/material.dart';

class EmergencyReportingPage extends StatefulWidget {
  const EmergencyReportingPage({super.key});

  @override
  State<EmergencyReportingPage> createState() => _EmergencyReportingPageState();
}

class _EmergencyReportingPageState extends State<EmergencyReportingPage> {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Reporting"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Report an Emergency",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: typeController,
                decoration: InputDecoration(
                  labelText: "Emergency Type (Fire, Accident, Medical...)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 16),

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
                  labelText: "Description (Optional)",
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
                  icon: const Icon(Icons.report),
                  label: Text(isSubmitting ? "Sending..." : "Send Report"),
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
      ),
    );
  }

  Future<void> _submitAlert() async {
    if (typeController.text.isEmpty || locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in the required fields.")),
      );
      return;
    }

    setState(() => isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Emergency report submitted!")),
    );

    typeController.clear();
    locationController.clear();
    descriptionController.clear();
  }
}
