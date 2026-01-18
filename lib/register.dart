// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:vitasafe/reg_api.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   TextEditingController name = TextEditingController();

//   TextEditingController email = TextEditingController();

//   TextEditingController dob = TextEditingController();

//   String? selectedGender;

//   final List<String> genderList = ['Male','Female', 'Others'];

//   String? selectedBloodGroup;
//   final List<String> bloodgroupList = ['A+','A','B+','B','AB-','AB+','O+','O-'];

//   TextEditingController address = TextEditingController();

//   TextEditingController password = TextEditingController();

//   TextEditingController contactno = TextEditingController();

//   File? _image;
//   final ImagePicker _picker =ImagePicker();
// Future<void> _pickImage() async {
//   final XFile? pickedFile = await _picker.pickImage(
//     source: ImageSource.gallery,
//   );
//   if (pickedFile !=null){
//     setState(() {
//       _image = File(pickedFile.path);
//     });
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:AppBar(
//         title: Text('Register Screen'),
//         backgroundColor: Colors.teal,
//         centerTitle: true,
//         // backgroundColor: Color.fromARGB(0, 173, 173, 234),
//       ),
//       body:
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment:  MainAxisAlignment.center,
//             children: [ 
//                       InkWell(
//                        onTap: _pickImage,
//                        child: CircleAvatar(
//                         radius: 35,
//                         backgroundColor: Colors.grey.shade400,
//                         backgroundImage: _image !=null
//                         ? FileImage(_image!)
//                         : null,
//                         child: _image == null
//                         ? const Icon(
//                          Icons.camera_alt_outlined,
//                          size:30, 
//                         )
//                         :null,
//                        ),
//                       ),

//                       SizedBox(height: 40,),
//                         TextFormField(
//                           controller: name,
//                 decoration: InputDecoration(
//                   labelText: 'Name',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12)
//                   )
//                 ),
//               ),
//                         SizedBox(height: 12,),
//                         TextFormField(
//                           controller: email,
//                 decoration: InputDecoration(
//                   labelText: 'E-mail',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12)
//                   )
//                 ),
//               ),
//               SizedBox(height: 12,),
//               TextFormField(
//                 controller: dob,
//                 decoration: InputDecoration(
//                   labelText: 'DOB',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//               // DropdownButtonFormField<String>(
//               //   value: selectedGender,
//               //   items: genderList.map(String gender){
//               //     return DropdownMenuItem<String>(
//               //       value: gender,
//               //       child: Text(gender),
//               //       );
//               //   }).toList(),
//               //   onChanged: (String? newValue){
//               //     setState(() {
//               //       selectedGender= newValue;
//               //     });
//               //   },
//               //   validator: (value) {
//               //     if (value == null || value.isEmpty){
//               //       return 'please select a gender';
//               //     }     
//               //     return null;
//               //              },
//               //              decoration: InputDecoration(
//               //               labelText: 'Gender',
//               //               border: OutlineInputBorder(borderSide: BorderSide.none),
//               //               fillColor: Color.fromARGB(188, 242, 235, 235),
//               //               filled: true,
//               //              ),    
//             DropdownButtonFormField<String>(
//               initialValue: selectedGender,
//               items: genderList.map((String gender){
//                 return DropdownMenuItem<String>(
//                   value: gender,
//                   child: Text(gender),
//                 );    
//               }).toList(),
//               onChanged:(String? newValue) {
//                 setState(() {
//                   selectedGender = newValue!;
//                 });
//               },
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please select a gender';
//                 }
//                 return null;
//               },
//               decoration: InputDecoration(
//                 labelText: 'Gender',
//                 border: OutlineInputBorder(borderSide: BorderSide.none),
//                 fillColor: Color.fromARGB(188, 242, 235, 235),
//                 filled: true,
//               ),
//             ),


//             DropdownButtonFormField<String>(
//               initialValue: selectedBloodGroup,
//               items: bloodgroupList.map((String bloodGroup){
//                 return DropdownMenuItem<String>(
//                   value: bloodGroup,
//                   child: Text(bloodGroup),
//                 );    
//               }).toList(),
//               onChanged:(String? newValue) {
//                 setState(() {
//                   selectedBloodGroup = newValue!;
//                 });
//               },
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please your bloodgroup';
//                 }
//                 return null;
//               },
//               decoration: InputDecoration(
//                 labelText: 'BoodGroup',
//                 border: OutlineInputBorder(borderSide: BorderSide.none),
//                 fillColor: Color.fromARGB(188, 242, 235, 235),
//                 filled: true,
//               ),
//             ),



//                       SizedBox(height: 20,),
//                         TextFormField(
//                           controller: address,
//                 decoration: InputDecoration(
//                   labelText: 'Address',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12)
//                   )
//                 ),
//               ),
//                         SizedBox(height: 12,),
          
//               TextFormField(
//                 controller: password,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12)
//                   )
//                 ),
//               ),
//                         SizedBox(height: 12,),
          
//                         TextFormField(
//                           controller: contactno,
//                 decoration: InputDecoration(
//                   labelText: 'Contact_No.',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12)
//                   )
//                 ),
//               ),
//               SizedBox(height: 20,),
//               ElevatedButton(onPressed: (){
//                 registerUser(name: name.text, dob: dob.text, gender: selectedGender!, email: email.text, password: password.text, address: address.text, contacno: contactno.text, photo:_image, bloodGroup: selectedBloodGroup!, context: context);
//               }, child: Text('REGISTER'))
//             ]
//             ),
//         ),
//       )
//     );
//   }
// }
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
  final List<String> genderList = ['Male','Female', 'Others'];
  String? selectedBloodGroup;
  final List<String> bloodgroupList = ['A+','A','B+','B','AB-','AB+','O+','O-'];
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
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F7FA),
              Color(0xFFB2EBF2),
              Color(0xFF80DEEA),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [ 
                // Profile Picture Section
                Column(
                  children: [
                    Text(
                      'Profile Picture',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal[800],
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: _pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.teal,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white,
                          backgroundImage: _image != null
                            ? FileImage(_image!)
                            : null,
                          child: _image == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    size: 35,
                                    color: Colors.teal[700],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Add Photo',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.teal[700],
                                    ),
                                  ),
                                ],
                              )
                            : null,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                // Form Fields
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Name Field
                        TextFormField(
                          controller: name,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            labelStyle: TextStyle(color: Colors.teal[700]),
                            prefixIcon: Icon(Icons.person, color: Colors.teal[700]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.teal[50],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Email Field
                        TextFormField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: TextStyle(color: Colors.teal[700]),
                            prefixIcon: Icon(Icons.email, color: Colors.teal[700]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.teal[50],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // DOB Field
                        TextFormField(
                          controller: dob,
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            labelStyle: TextStyle(color: Colors.teal[700]),
                            prefixIcon: Icon(Icons.calendar_today, color: Colors.teal[700]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.teal[50],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Gender Dropdown
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.teal[50],
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedGender,
                            items: genderList.map((String gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Row(
                                  children: [
                                    Icon(
                                      gender == 'Male' ? Icons.male : 
                                      gender == 'Female' ? Icons.female : Icons.transgender,
                                      color: Colors.teal[700],
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      gender,
                                      style: TextStyle(
                                        color: Colors.teal[700],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              );    
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedGender = newValue;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              labelStyle: TextStyle(color: Colors.teal[700]),
                              prefixIcon: Icon(Icons.person_outline, color: Colors.teal[700]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            icon: Icon(Icons.arrow_drop_down, color: Colors.teal[700]),
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Blood Group Dropdown
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.teal[50],
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedBloodGroup,
                            items: bloodgroupList.map((String bloodGroup) {
                              return DropdownMenuItem<String>(
                                value: bloodGroup,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.bloodtype,
                                      color: Colors.red[700],
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      bloodGroup,
                                      style: TextStyle(
                                        color: Colors.red[700],
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );    
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedBloodGroup = newValue;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Blood Group',
                              labelStyle: TextStyle(color: Colors.teal[700]),
                              prefixIcon: Icon(Icons.bloodtype_outlined, color: Colors.teal[700]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            icon: Icon(Icons.arrow_drop_down, color: Colors.teal[700]),
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Address Field
                        TextFormField(
                          controller: address,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            labelStyle: TextStyle(color: Colors.teal[700]),
                            prefixIcon: Icon(Icons.location_on, color: Colors.teal[700]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.teal[50],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Password Field
                        TextFormField(
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.teal[700]),
                            prefixIcon: Icon(Icons.lock, color: Colors.teal[700]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.teal[50],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Contact Field
                        TextFormField(
                          controller: contactno,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Contact Number',
                            labelStyle: TextStyle(color: Colors.teal[700]),
                            prefixIcon: Icon(Icons.phone, color: Colors.teal[700]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.teal[50],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Register Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              if (name.text.isEmpty ||
                                  email.text.isEmpty ||
                                  dob.text.isEmpty ||
                                  selectedGender == null ||
                                  selectedBloodGroup == null ||
                                  address.text.isEmpty ||
                                  password.text.isEmpty ||
                                  contactno.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill all fields'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              
                              registerUser(
                                name: name.text,
                                dob: dob.text,
                                gender: selectedGender!,
                                email: email.text,
                                password: password.text,
                                address: address.text,
                                contacno: contactno.text,
                                photo: _image,
                                bloodGroup: selectedBloodGroup!,
                                context: context,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                              shadowColor: Colors.teal.withOpacity(0.5),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.app_registration, size: 22),
                                SizedBox(width: 10),
                                Text(
                                  'REGISTER NOW',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 10),
                        
                        // Already have account text
                        TextButton(
                          onPressed: () {
                            // Navigate to login screen
                          },
                          child: Text(
                            'Already have an account? Sign In',
                            style: TextStyle(
                              color: Colors.teal[700],
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}