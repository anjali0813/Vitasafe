import 'package:flutter/material.dart';

class VolunteerRegistrationPage extends StatefulWidget {
  @override
  _VolunteerRegistrationPageState createState() => _VolunteerRegistrationPageState();
}

class _VolunteerRegistrationPageState extends State<VolunteerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  String? name;
  String? email;
  String? phone;
  String? address;
  String? skills;
  String? availability;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Volunteer Registration"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Register as Volunteer",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Full Name
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter your name" : null,
                onSaved: (val) => name = val,
              ),
              SizedBox(height: 16),

              // Email
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter email" : null,
                onSaved: (val) => email = val,
              ),
              SizedBox(height: 16),

              // Phone
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter phone number" : null,
                onSaved: (val) => phone = val,
              ),
              SizedBox(height: 16),

              // Address
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) => value!.isEmpty ? "Enter address" : null,
                onSaved: (val) => address = val,
              ),
              SizedBox(height: 16),

              // Skills
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Skills (Optional)",
                  border: OutlineInputBorder(),
                ),
                onSaved: (val) => skills = val,
              ),
              SizedBox(height: 16),

              // Availability
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Availability (Days/Hours)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter availability" : null,
                onSaved: (val) => availability = val,
              ),
              SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Registration submitted!")),
                      );
                    }
                  },
                  child: Text("Submit", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}