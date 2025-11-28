import 'package:flutter/material.dart';

class VolunteerProfilePage extends StatefulWidget {
  const VolunteerProfilePage({super.key});

  @override
  State<VolunteerProfilePage> createState() => _VolunteerProfilePageState();
}

class _VolunteerProfilePageState extends State<VolunteerProfilePage> {
  bool isEditing = false;

  final TextEditingController nameController = TextEditingController(text: "John Doe");
  final TextEditingController emailController = TextEditingController(text: "john@example.com");
  final TextEditingController phoneController = TextEditingController(text: "9876543210");
  final TextEditingController addressController = TextEditingController(text: "Kozhikode, Kerala");
  final TextEditingController skillsController = TextEditingController(text: "First Aid, Crowd Management");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Volunteer Profile"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                if (isEditing) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profile Updated")),
                  );
                }
                isEditing = !isEditing;
              });
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Volunteer Profile Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              buildField("Full Name", nameController),
              buildField("Email", emailController),
              buildField("Phone", phoneController),
              buildField("Address", addressController, maxLines: 2),
              buildField("Skills", skillsController),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: isEditing,
          maxLines: maxLines,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}