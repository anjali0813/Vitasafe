import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vitasafe/volunteer_reg_api.dart';

class VolunteerRegistrationPage extends StatefulWidget {
  @override
  _VolunteerRegistrationPageState createState() => _VolunteerRegistrationPageState();
}

class _VolunteerRegistrationPageState extends State<VolunteerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController Name = TextEditingController();

  TextEditingController Email = TextEditingController();

  TextEditingController Age = TextEditingController();

  String? selectedGender;

  final List<String> genderList = ['Male','Female'];

  TextEditingController Phone = TextEditingController();

  TextEditingController Address = TextEditingController();

  TextEditingController Skills = TextEditingController();

  File? _image;
  final ImagePicker _picker =ImagePicker();
Future<void> _pickImage() async {
  final XFile? pickedFile = await _picker.pickImage(
    source: ImageSource.gallery,
  );
  if (pickedFile !=null){
    setState(() {
      _image = File(pickedFile.path);
    });
  }
}
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
            
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Register as Volunteer",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              InkWell(
                       onTap: _pickImage,
                       child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey.shade400,
                        backgroundImage: _image !=null
                        ? FileImage(_image!)
                        : null,
                        child: _image == null
                        ? const Icon(
                         Icons.camera_alt_outlined,
                         size:30, 
                        )
                        :null,
                       ),

                       
                      ),
                      SizedBox(height: 40,),
              // Full Name
              TextFormField(
                controller: Name,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter your name" : null,
               
              ),
              SizedBox(height: 16),

              // Email
              TextFormField(
                controller: Email,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter email" : null,
          
              ),
              SizedBox(height: 16),

              // Phone
              TextFormField(
                controller: Phone,
                decoration: InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter phone number" : null,
              ),
              SizedBox(height: 16),

              // Address
              TextFormField(
                controller: Address,
                decoration: InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) => value!.isEmpty ? "Enter address" : null,
              ),
              SizedBox(height: 16),


              // Age
              TextFormField(
                controller: Age,
                decoration: InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter age" : null,
          
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<String>(
              value: selectedGender,
              items: genderList.map((String gender){
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );    
              }).toList(),
              onChanged:(String? newValue) {
                setState(() {
                  selectedGender = newValue!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pleases select a gender';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(borderSide: BorderSide.none),
                fillColor: Color.fromARGB(188, 242, 235, 235),
                filled: true,
              ),
            ),

SizedBox(height: 16),
              // Skills
              TextFormField(
                controller: Skills,
                decoration: InputDecoration(
                  labelText: "Skills (Optional)",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Availability
              // TextFormField(
              //   decoration: InputDecoration(
              //     labelText: "Availability (Days/Hours)",
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (value) => value!.isEmpty ? "Enter availability" : null,
              //   onSaved: (val) => availability = val,
              // ),
              // SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {


                      registerVolunteer(name: Name.text, email: Email.text, phone: Phone.text, address: Address.text, skills: Skills.text, photo: _image, age: Age.text, gender: selectedGender!);
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