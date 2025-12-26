import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class BloodRequestForm extends StatefulWidget {
  @override
  _BloodRequestFormState createState() => _BloodRequestFormState();
}

class _BloodRequestFormState extends State<BloodRequestForm> {
  final _formKey = GlobalKey<FormState>();

  String bloodGroup = 'A+';
  bool availability = true;
  String volunteerId = '';
  String volunteerName = '';

  final List<String> bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];

  final Dio dio = Dio(
   
  );

  /// 🔴 Submit API Call
  Future<void> submitBloodRequest() async {
    try {
  

      final response = await dio.post(
        "$baseurl/BloodDonation/$lid",
        data: {
          "Bloodgroup": bloodGroup,
          
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Blood Request Submitted")),
      );

      print("Response: ${response.data}");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Submission Failed")),
      );
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blood Request')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              /// Volunteer Name (UI only)
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Volunteer Name'),
              //   onSaved: (value) => volunteerName = value!,
              //   validator: (value) =>
              //       value!.isEmpty ? 'Enter volunteer name' : null,
              // ),

              // /// Volunteer ID
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Volunteer ID'),
              //   keyboardType: TextInputType.number,
              //   onSaved: (value) => volunteerId = value!,
              //   validator: (value) =>
              //       value!.isEmpty ? 'Enter volunteer ID' : null,
              // ),

              /// Blood Group
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Blood Group'),
                value: bloodGroup,
                items: bloodGroups.map((group) {
                  return DropdownMenuItem(
                    value: group,
                    child: Text(group),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    bloodGroup = value.toString();
                  });
                },
              ),

              /// Availability
              // SwitchListTile(
              //   title: Text('Available to Donate'),
              //   value: availability,
              //   onChanged: (value) {
              //     setState(() {
              //       availability = value;
              //     });
              //   },
              // ),

              SizedBox(height: 20),

              /// Submit
              ElevatedButton(
                child: Text('Submit Request'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    submitBloodRequest();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
