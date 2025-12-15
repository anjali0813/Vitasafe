import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class VolunteerProfilePage extends StatefulWidget {
  

  const VolunteerProfilePage({super.key});

  @override
  State<VolunteerProfilePage> createState() => _VolunteerProfilePageState();
}

class _VolunteerProfilePageState extends State<VolunteerProfilePage> {
  bool isEditing = false;
  bool isLoading = true;

  final Dio dio = Dio();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  /// 🔹 GET PROFILE
  Future<void> fetchProfile() async {
    try {
      final response = await dio.get(
        "$baseurl/volunteer_profile/$lid",
      );

      final data = response.data;

      nameController.text = data["Name"] ?? "";
      emailController.text = data["Email"] ?? "";
      phoneController.text = data["Phone"]?.toString() ?? "";
      addressController.text = data["Address"] ?? "";
      skillsController.text = data["Skills"] ?? "";

      setState(() => isLoading = false);
    } catch (e) {
      debugPrint("Fetch error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load profile")),
      );
    }
  }

  /// 🔹 UPDATE PROFILE
  Future<void> updateProfile() async {
    try {
      await dio.put(
        "$baseurl/volunteer_profile/$lid",
        data: {
          "Name": nameController.text,
          "Email": emailController.text,
          "Phone": phoneController.text,
          "Address": addressController.text,
          "Skills": skillsController.text,
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated Successfully")),
      );
    } catch (e) {
      debugPrint("Update error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Update failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Volunteer Profile"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () async {
              if (isEditing) {
                await updateProfile();
              }
              setState(() => isEditing = !isEditing);
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                    buildEmailField("Email", emailController),
                    buildField("Phone", phoneController),
                    buildField("Address", addressController, maxLines: 2),
                    buildField("Skills", skillsController),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600)),
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

  Widget buildEmailField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          readOnly: true,
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
