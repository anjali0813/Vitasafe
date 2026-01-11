import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vitasafe/reg_api.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController dob = TextEditingController();

  String? selectedGender;

  final List<String> genderList = ['Male','Female'];

  TextEditingController address = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController contactno = TextEditingController();

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
      appBar:AppBar(
        title: Text('Register Screen'),
        backgroundColor: Colors.teal,
        centerTitle: true,
        // backgroundColor: Color.fromARGB(0, 173, 173, 234),
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:  MainAxisAlignment.center,
            children: [ 
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
                        TextFormField(
                          controller: name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
              ),
                        SizedBox(height: 12,),
                        TextFormField(
                          controller: email,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
              ),
              SizedBox(height: 12,),
              TextFormField(
                controller: dob,
                decoration: InputDecoration(
                  labelText: 'DOB',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              // DropdownButtonFormField<String>(
              //   value: selectedGender,
              //   items: genderList.map(String gender){
              //     return DropdownMenuItem<String>(
              //       value: gender,
              //       child: Text(gender),
              //       );
              //   }).toList(),
              //   onChanged: (String? newValue){
              //     setState(() {
              //       selectedGender= newValue;
              //     });
              //   },
              //   validator: (value) {
              //     if (value == null || value.isEmpty){
              //       return 'please select a gender';
              //     }     
              //     return null;
              //              },
              //              decoration: InputDecoration(
              //               labelText: 'Gender',
              //               border: OutlineInputBorder(borderSide: BorderSide.none),
              //               fillColor: Color.fromARGB(188, 242, 235, 235),
              //               filled: true,
              //              ),    
            DropdownButtonFormField<String>(
              initialValue: selectedGender,
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


                          SizedBox(height: 20,),
                        TextFormField(
                          controller: address,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
              ),
                        SizedBox(height: 12,),
          
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
              ),
                        SizedBox(height: 12,),
          
                        TextFormField(
                          controller: contactno,
                decoration: InputDecoration(
                  labelText: 'Contact_No.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                registerUser(name: name.text, dob: dob.text, gender: selectedGender!, email: email.text, password: password.text, address: address.text, contacno: contactno.text, photo:_image );
              }, child: Text('REGISTER'))
            ]
            ),
        ),
      )
    );
  }
}