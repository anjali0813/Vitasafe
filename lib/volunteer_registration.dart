// // import 'dart:io';

// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:vitasafe/volunteer_reg_api.dart';

// // class VolunteerRegistrationPage extends StatefulWidget {
// //   const VolunteerRegistrationPage({super.key});

// //   @override
// //   _VolunteerRegistrationPageState createState() => _VolunteerRegistrationPageState();
// // }

// // class _VolunteerRegistrationPageState extends State<VolunteerRegistrationPage> {
// //   final _formKey = GlobalKey<FormState>();

// //   TextEditingController Name = TextEditingController();

// //   TextEditingController Email = TextEditingController();

// //   TextEditingController password=TextEditingController();

// //   TextEditingController Age = TextEditingController();

// //   String? selectedGender;

// //   final List<String> genderList = ['Male','Female'];

// //   TextEditingController Phone = TextEditingController();

// //   TextEditingController Address = TextEditingController();

// //   TextEditingController Skills = TextEditingController();

// //   File? _image;
// //   final ImagePicker _picker =ImagePicker();
// // Future<void> _pickImage() async {
// //   final XFile? pickedFile = await _picker.pickImage(
// //     source: ImageSource.gallery,
// //   );
// //   if (pickedFile !=null){
// //     setState(() {
// //       _image = File(pickedFile.path);
// //     });
// //   }
// // }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Volunteer Registration"),
// //         backgroundColor: Colors.teal,
// //       ),
// //       body: SingleChildScrollView(
// //         padding: EdgeInsets.all(16),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
            
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //               Text(
// //                 "Register as Volunteer",
// //                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //               ),
// //               SizedBox(height: 20),
// //               InkWell(
// //                        onTap: _pickImage,
// //                        child: CircleAvatar(
// //                         radius: 35,
// //                         backgroundColor: Colors.grey.shade400,
// //                         backgroundImage: _image !=null
// //                         ? FileImage(_image!)
// //                         : null,
// //                         child: _image == null
// //                         ? const Icon(
// //                          Icons.camera_alt_outlined,
// //                          size:30, 
// //                         )
// //                         :null,
// //                        ),

                       
// //                       ),
// //                       SizedBox(height: 40,),
// //               // Full Name
// //               TextFormField(
// //                 controller: Name,
// //                 decoration: InputDecoration(
// //                   labelText: "Full Name",
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 validator: (value) => value!.isEmpty ? "Enter your name" : null,
               
// //               ),
// //               SizedBox(height: 16),

// //               // Email
// //               TextFormField(
// //                 controller: Email,
// //                 decoration: InputDecoration(
// //                   labelText: "Email",
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 validator: (value) => value!.isEmpty ? "Enter email" : null,
          
// //               ),
// //               SizedBox(height: 16),
              
// //               //password
// //               TextFormField(
// //                 controller: password,
// //                 decoration: InputDecoration(
// //                   labelText: "password",
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 validator: (value) => value!.isEmpty ? "Enter password" :null,
// //                 ),
// //                 SizedBox(height: 16),

// //               // Phone
// //               TextFormField(
// //                 controller: Phone,
// //                 decoration: InputDecoration(
// //                   labelText: "Phone",
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 validator: (value) => value!.isEmpty ? "Enter phone number" : null,
// //               ),
// //               SizedBox(height: 16),

// //               // Address
// //               TextFormField(
// //                 controller: Address,
// //                 decoration: InputDecoration(
// //                   labelText: "Address",
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 maxLines: 2,
// //                 validator: (value) => value!.isEmpty ? "Enter address" : null,
// //               ),
// //               SizedBox(height: 16),


// //               // Age
// //               TextFormField(
// //                 controller: Age,
// //                 decoration: InputDecoration(
// //                   labelText: "Age",
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 validator: (value) => value!.isEmpty ? "Enter age" : null,
          
// //               ),
// //               SizedBox(height: 16),

// //               DropdownButtonFormField<String>(
// //               initialValue: selectedGender,
// //               items: genderList.map((String gender){
// //                 return DropdownMenuItem<String>(
// //                   value: gender,
// //                   child: Text(gender),
// //                 );    
// //               }).toList(),
// //               onChanged:(String? newValue) {
// //                 setState(() {
// //                   selectedGender = newValue!;
// //                 });
// //               },
// //               validator: (value) {
// //                 if (value == null || value.isEmpty) {
// //                   return 'Pleases select a gender';
// //                 }
// //                 return null;
// //               },
// //               decoration: InputDecoration(
// //                 labelText: 'Gender',
// //                 border: OutlineInputBorder(borderSide: BorderSide.none),
// //                 fillColor: Color.fromARGB(188, 242, 235, 235),
// //                 filled: true,
// //               ),
// //             ),

// // SizedBox(height: 16),
// //               // Skills
// //               TextFormField(
// //                 controller: Skills,
// //                 decoration: InputDecoration(
// //                   labelText: "Skills (Optional)",
// //                   border: OutlineInputBorder(),
// //                 ),
// //               ),
// //               SizedBox(height: 16),

// //               // Availability
// //               // TextFormField(
// //               //   decoration: InputDecoration(
// //               //     labelText: "Availability (Days/Hours)",
// //               //     border: OutlineInputBorder(),
// //               //   ),
// //               //   validator: (value) => value!.isEmpty ? "Enter availability" : null,
// //               //   onSaved: (val) => availability = val,
// //               // ),
// //               // SizedBox(height: 20),

// //               // Submit Button
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton(
// //                   style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
// //                   onPressed: () {
// //                     if (_formKey.currentState!.validate()) {


// //                       registerVolunteer(name: Name.text, email: Email.text, phone: Phone.text, address: Address.text, skills: Skills.text, photo: _image, age: Age.text, gender: selectedGender!,password: password.text);
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         SnackBar(content: Text("Registration submitted!")),
// //                       );
// //                     }
// //                   },
// //                   child: Text("Submit", style: TextStyle(fontSize: 18)),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:vitasafe/volunteer_reg_api.dart';

// class VolunteerRegistrationPage extends StatefulWidget {
//   const VolunteerRegistrationPage({super.key});

//   @override
//   _VolunteerRegistrationPageState createState() => _VolunteerRegistrationPageState();
// }

// class _VolunteerRegistrationPageState extends State<VolunteerRegistrationPage> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

//   // Controllers
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController skillsController = TextEditingController();

//   // Variables
//   String? selectedGender;
//   final List<String> genderList = ['Male', 'Female', 'Other', 'Prefer not to say'];
//   File? _image;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImage() async {
//     final XFile? pickedFile = await _picker.pickImage(
//       source: ImageSource.gallery,
//       maxWidth: 800,
//       maxHeight: 800,
//       imageQuality: 85,
//     );
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _takePhoto() async {
//     final XFile? pickedFile = await _picker.pickImage(
//       source: ImageSource.camera,
//       maxWidth: 800,
//       maxHeight: 800,
//       imageQuality: 85,
//     );
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   void _showImageSourceDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Select Image Source"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Icon(Icons.camera_alt, color: Colors.teal),
//               title: Text("Take Photo"),
//               onTap: () {
//                 Navigator.pop(context);
//                 _takePhoto();
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_library, color: Colors.teal),
//               title: Text("Choose from Gallery"),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   bool _validateEmail(String email) {
//     final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
//     return emailRegex.hasMatch(email);
//   }

//   bool _validatePhone(String phone) {
//     final phoneRegex = RegExp(r'^[0-9]{10,15}$');
//     return phoneRegex.hasMatch(phone);
//   }

//   bool _validateAge(String age) {
//     try {
//       int ageNum = int.parse(age);
//       return ageNum >= 18 && ageNum <= 100;
//     } catch (e) {
//       return false;
//     }
//   }

//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       if (passwordController.text != confirmPasswordController.text) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Passwords do not match!"),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       if (_image == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Please upload a profile photo"),
//             backgroundColor: Colors.orange,
//           ),
//         );
//         return;
//       }

//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         await registerVolunteer(
//           name: nameController.text,
//           email: emailController.text,
//           phone: phoneController.text,
//           address: addressController.text,
//           skills: skillsController.text,
//           photo: _image,
//           age: ageController.text,
//           gender: selectedGender!,
//           password: passwordController.text,
//         );

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Registration successful!"),
//             backgroundColor: Colors.green,
//             duration: Duration(seconds: 2),
//           ),
//         );

//         // Clear form after successful registration
//         _formKey.currentState!.reset();
//         setState(() {
//           _image = null;
//           selectedGender = null;
//         });

//         // Optionally navigate to login page
//         Future.delayed(Duration(seconds: 2), () {
//           Navigator.pop(context);
//         });

//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Registration failed: ${e.toString()}"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header Section
//             Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Colors.teal.shade700, Colors.teal.shade400],
//                 ),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   Positioned(
//                     top: 50,
//                     left: 20,
//                     child: IconButton(
//                       icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ),
//                   Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.people_alt_outlined, size: 50, color: Colors.white),
//                         SizedBox(height: 10),
//                         Text(
//                           "Volunteer Registration",
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           "Join our community of volunteers",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.white.withOpacity(0.9),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Form Section
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Profile Picture Section
//                     Center(
//                       child: Column(
//                         children: [
//                           SizedBox(height: 20),
//                           Stack(
//                             children: [
//                               Container(
//                                 width: 120,
//                                 height: 120,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: Colors.teal.shade300,
//                                     width: 3,
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.teal.withOpacity(0.2),
//                                       blurRadius: 10,
//                                       spreadRadius: 2,
//                                     ),
//                                   ],
//                                 ),
//                                 child: ClipOval(
//                                   child: _image != null
//                                       ? Image.file(_image!, fit: BoxFit.cover)
//                                       : Container(
//                                           color: Colors.grey[200],
//                                           child: Icon(
//                                             Icons.person,
//                                             size: 60,
//                                             color: Colors.grey[400],
//                                           ),
//                                         ),
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 0,
//                                 right: 0,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.teal,
//                                     border: Border.all(color: Colors.white, width: 3),
//                                   ),
//                                   child: IconButton(
//                                     icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
//                                     onPressed: _showImageSourceDialog,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             "Profile Picture",
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 14,
//                             ),
//                           ),
//                           SizedBox(height: 30),
//                         ],
//                       ),
//                     ),

//                     // Personal Information Section
//                     _buildSectionHeader("Personal Information"),
//                     SizedBox(height: 15),

//                     // Full Name
//                     _buildTextField(
//                       controller: nameController,
//                       label: "Full Name",
//                       icon: Icons.person_outline,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your full name';
//                         }
//                         if (value.length < 2) {
//                           return 'Name must be at least 2 characters';
//                         }
//                         return null;
//                       },
//                     ),

//                     SizedBox(height: 16),

//                     // Email
//                     _buildTextField(
//                       controller: emailController,
//                       label: "Email Address",
//                       icon: Icons.email_outlined,
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your email';
//                         }
//                         if (!_validateEmail(value)) {
//                           return 'Please enter a valid email address';
//                         }
//                         return null;
//                       },
//                     ),

//                     SizedBox(height: 16),

//                     // Age and Gender Row
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: _buildTextField(
//                             controller: ageController,
//                             label: "Age",
//                             icon: Icons.cake_outlined,
//                             keyboardType: TextInputType.number,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Enter age';
//                               }
//                               if (!_validateAge(value)) {
//                                 return 'Age must be between 18 and 100';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         SizedBox(width: 16),
//                         Expanded(
//                           flex: 3,
//                           child: _buildGenderDropdown(),
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: 16),

//                     // Phone
//                     _buildTextField(
//                       controller: phoneController,
//                       label: "Phone Number",
//                       icon: Icons.phone_outlined,
//                       keyboardType: TextInputType.phone,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter phone number';
//                         }
//                         if (!_validatePhone(value)) {
//                           return 'Please enter a valid phone number (10-15 digits)';
//                         }
//                         return null;
//                       },
//                     ),

//                     SizedBox(height: 16),

//                     // Address
//                     _buildTextField(
//                       controller: addressController,
//                       label: "Address",
//                       icon: Icons.location_on_outlined,
//                       maxLines: 2,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your address';
//                         }
//                         if (value.length < 10) {
//                           return 'Please enter a complete address';
//                         }
//                         return null;
//                       },
//                     ),

//                     // Password Section
//                     SizedBox(height: 30),
//                     _buildSectionHeader("Account Security"),
//                     SizedBox(height: 15),

//                     // Password
//                     _buildPasswordField(
//                       controller: passwordController,
//                       label: "Password",
//                       obscureText: _obscurePassword,
//                       onToggleVisibility: () {
//                         setState(() {
//                           _obscurePassword = !_obscurePassword;
//                         });
//                       },
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter password';
//                         }
//                         if (value.length < 6) {
//                           return 'Password must be at least 6 characters';
//                         }
//                         return null;
//                       },
//                     ),

//                     SizedBox(height: 16),

//                     // Confirm Password
//                     _buildPasswordField(
//                       controller: confirmPasswordController,
//                       label: "Confirm Password",
//                       obscureText: _obscureConfirmPassword,
//                       onToggleVisibility: () {
//                         setState(() {
//                           _obscureConfirmPassword = !_obscureConfirmPassword;
//                         });
//                       },
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please confirm password';
//                         }
//                         return null;
//                       },
//                     ),

//                     // Additional Information Section
//                     SizedBox(height: 30),
//                     _buildSectionHeader("Additional Information"),
//                     SizedBox(height: 15),

//                     // Skills
//                     _buildTextField(
//                       controller: skillsController,
//                       label: "Skills (Optional)",
//                       icon: Icons.work_outline,
//                       hintText: "e.g., First Aid, Teaching, Cooking, Languages...",
//                       maxLines: 2,
//                     ),

//                     // Submit Button
//                     SizedBox(height: 40),
//                     _buildSubmitButton(),

//                     // Login Link
//                     SizedBox(height: 20),
//                     Center(
//                       child: GestureDetector(
//                         onTap: () {
//                           // Navigate to login page
//                           // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
//                         },
//                         child: RichText(
//                           text: TextSpan(
//                             text: "Already have an account? ",
//                             style: TextStyle(color: Colors.grey[600]),
//                             children: [
//                               TextSpan(
//                                 text: "Login here",
//                                 style: TextStyle(
//                                   color: Colors.teal,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         color: Colors.teal.shade800,
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     String? hintText,
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hintText,
//         prefixIcon: Icon(icon, color: Colors.teal.shade600),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
//         ),
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//       ),
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       validator: validator,
//     );
//   }

//   Widget _buildPasswordField({
//     required TextEditingController controller,
//     required String label,
//     required bool obscureText,
//     required VoidCallback onToggleVisibility,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(Icons.lock_outline, color: Colors.teal.shade600),
//         suffixIcon: IconButton(
//           icon: Icon(
//             obscureText ? Icons.visibility_off : Icons.visibility,
//             color: Colors.grey.shade500,
//           ),
//           onPressed: onToggleVisibility,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
//         ),
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//       ),
//       validator: validator,
//     );
//   }

//   Widget _buildGenderDropdown() {
//     return DropdownButtonFormField<String>(
//       value: selectedGender,
//       items: genderList.map((String gender) {
//         return DropdownMenuItem<String>(
//           value: gender,
//           child: Text(gender),
//         );
//       }).toList(),
//       onChanged: (String? newValue) {
//         setState(() {
//           selectedGender = newValue;
//         });
//       },
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please select gender';
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         labelText: 'Gender',
//         prefixIcon: Icon(Icons.transgender, color: Colors.teal.shade600),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
//         ),
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//       ),
//     );
//   }

//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 56,
//       child: ElevatedButton(
//         onPressed: _isLoading ? null : _submitForm,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.teal.shade600,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 3,
//           padding: EdgeInsets.symmetric(vertical: 16),
//         ),
//         child: _isLoading
//             ? SizedBox(
//                 height: 24,
//                 width: 24,
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 2,
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.how_to_reg, color: Colors.white),
//                   SizedBox(width: 10),
//                   Text(
//                     "Register as Volunteer",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VolunteerRegistrationPage extends StatefulWidget {
  const VolunteerRegistrationPage({super.key});

  @override
  _VolunteerRegistrationPageState createState() => _VolunteerRegistrationPageState();
}

class _VolunteerRegistrationPageState extends State<VolunteerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController skillsController = TextEditingController();

  // Variables
  String? selectedGender;
  final List<String> genderList = ['Male', 'Female', 'Other', 'Prefer not to say'];
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Image Source", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.teal),
              title: const Text("Take Photo"),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.teal),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool _validatePhone(String phone) {
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    return phoneRegex.hasMatch(phone);
  }

  bool _validateAge(String age) {
    try {
      int ageNum = int.parse(age);
      return ageNum >= 18 && ageNum <= 100;
    } catch (e) {
      return false;
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Passwords do not match!"),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Please upload a profile photo"),
            backgroundColor: Colors.orange.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Registration logic here (replace with actual API call)
      try {
        // await registerVolunteer(...);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Registration successful!"),
            backgroundColor: Colors.green.shade600,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );

        // Clear form
        _formKey.currentState!.reset();
        setState(() {
          _image = null;
          selectedGender = null;
        });

        // Navigate back after success
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration failed: ${e.toString()}"),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header Section
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.teal.shade800, Colors.teal.shade500],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 15,
                      left: 15,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.volunteer_activism,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Join as Volunteer",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          // const SizedBox(height: 8),
                          // const Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 40),
                          //   child: Text(
                          //     "Be part of our mission to make a difference in the community",
                          //     textAlign: TextAlign.center,
                          //     style: TextStyle(
                          //       fontSize: 14,
                          //       color: Colors.white,
                          //       height: 1.4,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Form Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Picture Section
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.teal.shade300,
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.teal.withOpacity(0.15),
                                        blurRadius: 15,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: _image != null
                                        ? Image.file(_image!, fit: BoxFit.cover)
                                        : Container(
                                            color: Colors.grey[100],
                                            child: Icon(
                                              Icons.person,
                                              size: 65,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _showImageSourceDialog,
                                    child: Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.teal.shade600,
                                        border: Border.all(color: Colors.white, width: 3),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 6,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Profile Picture",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "(Required)",
                              style: TextStyle(
                                color: Colors.red.shade400,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),

                      // Personal Information Section
                      _buildSectionHeader("Personal Information"),
                      const SizedBox(height: 18),

                      // Full Name
                      _buildTextField(
                        controller: nameController,
                        label: "Full Name",
                        icon: Icons.person_outline_rounded,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          if (value.length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Email
                      _buildTextField(
                        controller: emailController,
                        label: "Email Address",
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!_validateEmail(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Age and Gender Row
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildTextField(
                              controller: ageController,
                              label: "Age",
                              icon: Icons.cake_outlined,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter age';
                                }
                                if (!_validateAge(value)) {
                                  return 'Age must be 18-100';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            flex: 3,
                            child: _buildGenderDropdown(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Phone
                      _buildTextField(
                        controller: phoneController,
                        label: "Phone Number",
                        icon: Icons.phone_android_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          if (!_validatePhone(value)) {
                            return 'Enter valid phone (10-15 digits)';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Address
                      _buildTextField(
                        controller: addressController,
                        label: "Address",
                        icon: Icons.location_on_outlined,
                        maxLines: 2,
                        hintText: "Street, City, State, ZIP Code",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          if (value.length < 10) {
                            return 'Please enter a complete address';
                          }
                          return null;
                        },
                      ),

                      // Password Section
                      const SizedBox(height: 32),
                      _buildSectionHeader("Account Security"),
                      const SizedBox(height: 18),

                      // Password
                      _buildPasswordField(
                        controller: passwordController,
                        label: "Password",
                        obscureText: _obscurePassword,
                        onToggleVisibility: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Confirm Password
                      _buildPasswordField(
                        controller: confirmPasswordController,
                        label: "Confirm Password",
                        obscureText: _obscureConfirmPassword,
                        onToggleVisibility: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                      // Additional Information Section
                      const SizedBox(height: 32),
                      _buildSectionHeader("Additional Information"),
                      const SizedBox(height: 18),

                      // Skills
                      _buildTextField(
                        controller: skillsController,
                        label: "Skills & Qualifications",
                        icon: Icons.work_outline,
                        hintText: "First Aid, Teaching, Cooking, Languages, etc.",
                        maxLines: 3,
                      ),

                      // Terms & Conditions
                      const SizedBox(height: 25),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, size: 18, color: Colors.teal.shade600),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "By registering, you agree to our Terms of Service and Privacy Policy. You'll receive updates about volunteer opportunities.",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Submit Button
                      const SizedBox(height: 35),
                      _buildSubmitButton(),

                      // Login Link
                      const SizedBox(height: 25),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to login page
                            Navigator.pop(context);
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: Colors.grey[600], fontSize: 15),
                              children: [
                                TextSpan(
                                  text: "Sign In",
                                  style: TextStyle(
                                    color: Colors.teal.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.teal.shade600,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade800,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.teal.shade600, size: 22),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red.shade600, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
            isDense: true,
          ),
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.teal.shade600, size: 22),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                color: Colors.grey.shade500,
                size: 22,
              ),
              onPressed: onToggleVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red.shade600, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
            isDense: true,
          ),
          validator: validator,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gender",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedGender,
          items: genderList.map((String gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(
                gender,
                style: const TextStyle(fontSize: 15),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedGender = newValue;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select gender';
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.transgender, color: Colors.teal.shade600, size: 22),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red.shade600, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            isDense: true,
          ),
          style: const TextStyle(color: Colors.black87, fontSize: 15),
          icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey.shade600, size: 28),
          hint: Text(
            "Select Gender",
            style: TextStyle(color: Colors.grey[500], fontSize: 15),
          ),
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          shadowColor: Colors.teal.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isLoading
            ? SizedBox(
                height: 26,
                width: 26,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.how_to_reg_rounded, size: 24, color: Colors.white),
                  const SizedBox(width: 12),
                  const Text(
                    "Complete Registration",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}