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
//                   return 'Pleases select a gender';
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


//                           SizedBox(height: 20,),
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
//                 registerUser(name: name.text, dob: dob.text, gender: selectedGender!, email: email.text, password: password.text, address: address.text, contacno: contactno.text, photo:_image , context: context);
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

  final _formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController contactno = TextEditingController();

  String? selectedGender;
  final List<String> genderList = ['Male', 'Female', 'Others'];

  File? _image;
  bool hidePassword = true;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  /// 📸 Image picker
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  /// 📅 DOB picker
  Future<void> _pickDOB() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: DateTime(2000),
    );
    if (picked != null) {
      dob.text = "${picked.day}-${picked.month}-${picked.year}";
    }
  }

  /// 🔐 Register handler
  void handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a profile image")),
      );
      return;
    }

    setState(() => isLoading = true);

    await registerUser(
      name: name.text.trim(),
      dob: dob.text.trim(),
      gender: selectedGender!,
      email: email.text.trim(),
      password: password.text.trim(),
      address: address.text.trim(),
      contacno: contactno.text.trim(),
      photo: _image,
      context: context,
    );

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF43cea2), Color(0xFF185a9d)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      /// 🧑 Profile Image
                      InkWell(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage:
                              _image != null ? FileImage(_image!) : null,
                          child: _image == null
                              ? const Icon(Icons.camera_alt, size: 30)
                              : null,
                        ),
                      ),

                      const SizedBox(height: 15),
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// 👤 Name
                      _buildField(
                        controller: name,
                        label: "Name",
                        icon: Icons.person,
                        validator: (v) =>
                            v!.isEmpty ? "Name is required" : null,
                      ),

                      /// 📧 Email
                      _buildField(
                        controller: email,
                        label: "Email",
                        icon: Icons.email,
                        keyboard: TextInputType.emailAddress,
                        validator: (v) {
                          if (v!.isEmpty) return "Email is required";
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                              .hasMatch(v)) {
                            return "Enter valid email";
                          }
                          return null;
                        },
                      ),

                      /// 📅 DOB
                      _buildField(
                        controller: dob,
                        label: "Date of Birth",
                        icon: Icons.calendar_today,
                        readOnly: true,
                        onTap: _pickDOB,
                        validator: (v) =>
                            v!.isEmpty ? "DOB is required" : null,
                      ),

                      /// ⚧ Gender
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        items: genderList
                            .map((g) => DropdownMenuItem(
                                  value: g,
                                  child: Text(g),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => selectedGender = v),
                        validator: (v) =>
                            v == null ? "Select gender" : null,
                        decoration: InputDecoration(
                          labelText: "Gender",
                          prefixIcon: const Icon(Icons.people),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// 🏠 Address
                      _buildField(
                        controller: address,
                        label: "Address",
                        icon: Icons.home,
                        validator: (v) =>
                            v!.isEmpty ? "Address is required" : null,
                      ),

                      /// 🔐 Password
                      TextFormField(
                        controller: password,
                        obscureText: hidePassword,
                        validator: (v) {
                          if (v!.isEmpty) return "Password required";
                          if (v.length < 6) {
                            return "Minimum 6 characters";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () =>
                                setState(() => hidePassword = !hidePassword),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// 📞 Contact
                      _buildField(
                        controller: contactno,
                        label: "Contact Number",
                        icon: Icons.phone,
                        keyboard: TextInputType.phone,
                        validator: (v) {
                          if (v!.isEmpty) return "Contact required";
                          if (v.length != 10) {
                            return "Enter 10 digit number";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 25),

                      /// 🔘 Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "REGISTER",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔧 Reusable field widget
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboard,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
