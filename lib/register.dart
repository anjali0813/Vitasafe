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

//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController name = TextEditingController();
//   final TextEditingController email = TextEditingController();
//   final TextEditingController dob = TextEditingController();
//   final TextEditingController address = TextEditingController();
//   final TextEditingController password = TextEditingController();
//   final TextEditingController contactno = TextEditingController();

//   String? selectedGender;
//   final List<String> genderList = ['Male', 'Female', 'Others'];

//   File? _image;
//   bool hidePassword = true;
//   bool isLoading = false;

//   final ImagePicker _picker = ImagePicker();

//   /// 📸 Image picker
//   Future<void> _pickImage() async {
//     final XFile? pickedFile =
//         await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   /// 📅 DOB picker
//   Future<void> _pickDOB() async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       firstDate: DateTime(1950),
//       lastDate: DateTime.now(),
//       initialDate: DateTime(2000),
//     );
//     if (picked != null) {
//       dob.text = "${picked.day}-${picked.month}-${picked.year}";
//     }
//   }

//   /// 🔐 Register handler
//   void handleRegister() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (_image == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select a profile image")),
//       );
//       return;
//     }

//     setState(() => isLoading = true);

//     await registerUser(
//       name: name.text.trim(),
//       dob: dob.text.trim(),
//       gender: selectedGender!,
//       email: email.text.trim(),
//       password: password.text.trim(),
//       address: address.text.trim(),
//       contacno: contactno.text.trim(),
//       photo: _image,
//       context: context,
//     );

//     setState(() => isLoading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF43cea2), Color(0xFF185a9d)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Card(
//               elevation: 12,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [

//                       /// 🧑 Profile Image
//                       InkWell(
//                         onTap: _pickImage,
//                         child: CircleAvatar(
//                           radius: 45,
//                           backgroundColor: Colors.grey.shade300,
//                           backgroundImage:
//                               _image != null ? FileImage(_image!) : null,
//                           child: _image == null
//                               ? const Icon(Icons.camera_alt, size: 30)
//                               : null,
//                         ),
//                       ),

//                       const SizedBox(height: 15),
//                       const Text(
//                         "Create Account",
//                         style: TextStyle(
//                           fontSize: 26,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),

//                       const SizedBox(height: 25),

//                       /// 👤 Name
//                       _buildField(
//                         controller: name,
//                         label: "Name",
//                         icon: Icons.person,
//                         validator: (v) =>
//                             v!.isEmpty ? "Name is required" : null,
//                       ),

//                       /// 📧 Email
//                       _buildField(
//                         controller: email,
//                         label: "Email",
//                         icon: Icons.email,
//                         keyboard: TextInputType.emailAddress,
//                         validator: (v) {
//                           if (v!.isEmpty) return "Email is required";
//                           if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
//                               .hasMatch(v)) {
//                             return "Enter valid email";
//                           }
//                           return null;
//                         },
//                       ),

//                       /// 📅 DOB
//                       _buildField(
//                         controller: dob,
//                         label: "Date of Birth",
//                         icon: Icons.calendar_today,
//                         readOnly: true,
//                         onTap: _pickDOB,
//                         validator: (v) =>
//                             v!.isEmpty ? "DOB is required" : null,
//                       ),

//                       /// ⚧ Gender
//                       DropdownButtonFormField<String>(
//                         value: selectedGender,
//                         items: genderList
//                             .map((g) => DropdownMenuItem(
//                                   value: g,
//                                   child: Text(g),
//                                 ))
//                             .toList(),
//                         onChanged: (v) => setState(() => selectedGender = v),
//                         validator: (v) =>
//                             v == null ? "Select gender" : null,
//                         decoration: InputDecoration(
//                           labelText: "Gender",
//                           prefixIcon: const Icon(Icons.people),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 12),

//                       /// 🏠 Address
//                       _buildField(
//                         controller: address,
//                         label: "Address",
//                         icon: Icons.home,
//                         validator: (v) =>
//                             v!.isEmpty ? "Address is required" : null,
//                       ),

//                       /// 🔐 Password
//                       TextFormField(
//                         controller: password,
//                         obscureText: hidePassword,
//                         validator: (v) {
//                           if (v!.isEmpty) return "Password required";
//                           if (v.length < 6) {
//                             return "Minimum 6 characters";
//                           }
//                           return null;
//                         },
//                         decoration: InputDecoration(
//                           labelText: "Password",
//                           prefixIcon: const Icon(Icons.lock),
//                           suffixIcon: IconButton(
//                             icon: Icon(hidePassword
//                                 ? Icons.visibility_off
//                                 : Icons.visibility),
//                             onPressed: () =>
//                                 setState(() => hidePassword = !hidePassword),
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 12),

//                       /// 📞 Contact
//                       _buildField(
//                         controller: contactno,
//                         label: "Contact Number",
//                         icon: Icons.phone,
//                         keyboard: TextInputType.phone,
//                         validator: (v) {
//                           if (v!.isEmpty) return "Contact required";
//                           if (v.length != 10) {
//                             return "Enter 10 digit number";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 25),

//                       /// 🔘 Register Button
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: isLoading ? null : handleRegister,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.teal,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                           child: isLoading
//                               ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                               : const Text(
//                                   "REGISTER",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// 🔧 Reusable field widget
//   Widget _buildField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType keyboard = TextInputType.text,
//     bool readOnly = false,
//     VoidCallback? onTap,
//     String? Function(String?)? validator,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextFormField(
//         controller: controller,
//         readOnly: readOnly,
//         onTap: onTap,
//         keyboardType: keyboard,
//         validator: validator,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ),
//     );
//   }
// }






import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vitasafe/reg_api.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();

  // Form state
  String? _selectedGender;
  File? _profileImage;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _showPasswordStrength = false;
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.grey;
  int _currentStep = 0;

  final List<String> _genderList = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  // Focus nodes
  final List<FocusNode> _focusNodes = List.generate(10, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_calculatePasswordStrength);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _contactController.dispose();
    _emergencyContactController.dispose();
    _bloodGroupController.dispose();
    _scrollController.dispose();
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _calculatePasswordStrength() {
    final password = _passwordController.text;
    double strength = 0.0;
    String text = '';
    Color color = Colors.grey;

    if (password.isNotEmpty) {
      // Length check
      if (password.length >= 8) strength += 0.2;
      
      // Upper case check
      if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.2;
      
      // Lower case check
      if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.2;
      
      // Number check
      if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.2;
      
      // Special character check
      if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.2;
    }

    setState(() {
      _passwordStrength = strength;
      _showPasswordStrength = password.isNotEmpty;
      
      if (strength < 0.4) {
        text = 'Weak';
        color = Colors.red;
      } else if (strength < 0.7) {
        text = 'Fair';
        color = Colors.orange;
      } else if (strength < 0.9) {
        text = 'Good';
        color = Colors.blue;
      } else {
        text = 'Strong';
        color = Colors.green;
      }
      
      _passwordStrengthText = text;
      _passwordStrengthColor = color;
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    
    if (pickedFile != null) {
      // Check file size (max 2MB)
      final file = File(pickedFile.path);
      final sizeInBytes = await file.length();
      final sizeInMB = sizeInBytes / (1024 * 1024);
      
      if (sizeInMB > 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image size should be less than 2MB'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      setState(() {
        _profileImage = file;
      });
    }
  }

  Future<void> _pickDOB() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 18)), // Default to 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(Duration(days: 365 * 12)), // Minimum 12 years
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      _dobController.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  // Validations
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validateDOB(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date of birth is required';
    }
    
    try {
      final date = DateFormat('dd-MM-yyyy').parse(value);
      final now = DateTime.now();
      final age = now.difference(date).inDays ~/ 365;
      
      if (age < 12) {
        return 'You must be at least 12 years old';
      }
      if (age > 120) {
        return 'Please enter a valid date of birth';
      }
    } catch (e) {
      return 'Please enter date in DD-MM-YYYY format';
    }
    
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Include at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Include at least one number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateContact(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contact number is required';
    }
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validateEmergencyContact(String? value) {
    if (value != null && value.isNotEmpty) {
      final phoneRegex = RegExp(r'^[0-9]{10}$');
      if (!phoneRegex.hasMatch(value.trim())) {
        return 'Please enter a valid 10-digit phone number';
      }
      if (value == _contactController.text.trim()) {
        return 'Emergency contact should be different from your contact';
      }
    }
    return null;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a profile image'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please accept terms and conditions'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
      await registerUser(
        name: _nameController.text.trim(),
        dob: _dobController.text.trim(),
        gender: _selectedGender!,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        address: _addressController.text.trim(),
        contacno: _contactController.text.trim(),
        photo: _profileImage,
        context: context,
        // emergencyContact: _emergencyContactController.text.trim(),
        bloodGroup: _bloodGroupController.text.trim(),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.teal.withOpacity(0.1),
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : null,
              child: _profileImage == null
                  ? Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.teal,
                    )
                  : null,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.white, size: 24),
                onPressed: _pickImage,
                tooltip: 'Upload Photo',
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Profile Photo',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        if (_profileImage == null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              '* Required',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    if (!_showPasswordStrength) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: _passwordStrength,
          backgroundColor: Colors.grey[200],
          color: _passwordStrengthColor,
          minHeight: 4,
        ),
        SizedBox(height: 4),
        Text(
          'Password Strength: $_passwordStrengthText',
          style: TextStyle(
            fontSize: 12,
            color: _passwordStrengthColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() => _acceptTerms = value ?? false);
          },
          activeColor: Colors.teal,
        ),
        Expanded(
          child: Wrap(
            children: [
              Text('I agree to the '),
              GestureDetector(
                onTap: () => _showTermsDialog(),
                child: Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(' and '),
              GestureDetector(
                onTap: () => _showPrivacyDialog(),
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(' *'),
            ],
          ),
        ),
      ],
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terms & Conditions'),
        content: SingleChildScrollView(
          child: Text(
            'By registering, you agree to:\n\n'
            '1. Provide accurate information\n'
            '2. Use the platform responsibly\n'
            '3. Maintain confidentiality\n'
            '4. Follow community guidelines\n'
            '5. Accept our privacy policy\n\n'
            'We reserve the right to suspend accounts violating terms.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Text(
            'Your privacy is important to us:\n\n'
            '• We collect only necessary information\n'
            '• Data is encrypted and secure\n'
            '• We don\'t share your data with third parties\n'
            '• You can request data deletion\n'
            '• Contact us for privacy concerns\n\n'
            'Last updated: ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required FocusNode focusNode,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    String? helperText,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          readOnly: readOnly,
          keyboardType: keyboardType,
          validator: validator,
          onTap: onTap,
          inputFormatters: keyboardType == TextInputType.phone
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          decoration: InputDecoration(
            hintText: helperText,
            prefixIcon: icon != null ? Icon(icon, size: 22) : null,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.teal, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropDownField({
    required String label,
    required String? value,
    required List<String> options,
    required Function(String?) onChanged,
    IconData? icon,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                hint: Text('Select $label'),
                items: options.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade800,
              Colors.teal.shade400,
              Colors.teal.shade200,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Form Container
              Expanded(
                child: Card(
                  margin: EdgeInsets.all(16),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: _buildImagePicker(),
                            ),
                            
                            SizedBox(height: 30),
                            
                            // Personal Information Section
                            Text(
                              'Personal Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            SizedBox(height: 16),
                            
                            // Name
                            _buildFormField(
                              label: 'Full Name',
                              controller: _nameController,
                              validator: _validateName,
                              focusNode: _focusNodes[0],
                              icon: Icons.person_outline,
                              helperText: 'Enter your full name',
                            ),
                            
                            // Email
                            _buildFormField(
                              label: 'Email Address',
                              controller: _emailController,
                              validator: _validateEmail,
                              focusNode: _focusNodes[1],
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              helperText: 'example@email.com',
                            ),
                            
                            // Date of Birth
                            _buildFormField(
                              label: 'Date of Birth',
                              controller: _dobController,
                              validator: _validateDOB,
                              focusNode: _focusNodes[2],
                              icon: Icons.calendar_today,
                              readOnly: true,
                              onTap: _pickDOB,
                              helperText: 'DD-MM-YYYY',
                            ),
                            
                            // Gender
                            _buildDropDownField(
                              label: 'Gender',
                              value: _selectedGender,
                              options: _genderList,
                              onChanged: (value) {
                                setState(() => _selectedGender = value);
                              },
                              icon: Icons.transgender,
                            ),
                            
                            // Blood Group
                            _buildDropDownField(
                              label: 'Blood Group',
                              value: _bloodGroupController.text.isNotEmpty
                                  ? _bloodGroupController.text
                                  : null,
                              options: _bloodGroups,
                              onChanged: (value) {
                                setState(() => _bloodGroupController.text = value ?? '');
                              },
                              icon: Icons.bloodtype,
                              isRequired: true,
                            ),
                            
                            SizedBox(height: 10),
                            Divider(),
                            SizedBox(height: 10),
                            
                            // Contact Information
                            Text(
                              'Contact Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            SizedBox(height: 16),
                            
                            // Contact Number
                            _buildFormField(
                              label: 'Contact Number',
                              controller: _contactController,
                              validator: _validateContact,
                              focusNode: _focusNodes[3],
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                              helperText: '10-digit mobile number',
                            ),
                            
                            // Emergency Contact (Optional)
                            _buildFormField(
                              label: 'Emergency Contact (Optional)',
                              controller: _emergencyContactController,
                              validator: _validateEmergencyContact,
                              focusNode: _focusNodes[4],
                              icon: Icons.emergency,
                              keyboardType: TextInputType.phone,
                              isRequired: false,
                              helperText: 'Different from your contact',
                            ),
                            
                            // Address
                            _buildFormField(
                              label: 'Address',
                              controller: _addressController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Address is required';
                                }
                                return null;
                              },
                              focusNode: _focusNodes[5],
                              icon: Icons.location_on_outlined,
                              helperText: 'Full residential address',
                            ),
                            
                            SizedBox(height: 10),
                            Divider(),
                            SizedBox(height: 10),
                            
                            // Security Section
                            Text(
                              'Security',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            SizedBox(height: 16),
                            
                            // Password
                            _buildFormField(
                              label: 'Password',
                              controller: _passwordController,
                              validator: _validatePassword,
                              focusNode: _focusNodes[6],
                              icon: Icons.lock_outline,
                              obscureText: _hidePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _hidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() => _hidePassword = !_hidePassword);
                                },
                              ),
                              helperText: 'At least 6 characters with uppercase and number',
                            ),
                            
                            // Password Strength Indicator
                            _buildPasswordStrengthIndicator(),
                            
                            // Confirm Password
                            _buildFormField(
                              label: 'Confirm Password',
                              controller: _confirmPasswordController,
                              validator: _validateConfirmPassword,
                              focusNode: _focusNodes[7],
                              icon: Icons.lock_outline,
                              obscureText: _hideConfirmPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _hideConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() => _hideConfirmPassword = !_hideConfirmPassword);
                                },
                              ),
                            ),
                            
                            SizedBox(height: 20),
                            
                            // Terms and Conditions
                            _buildTermsAndConditions(),
                            
                            SizedBox(height: 30),
                            
                            // Register Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 4,
                                  shadowColor: Colors.teal.withOpacity(0.5),
                                ),
                                child: _isLoading
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Text('Creating Account...'),
                                        ],
                                      )
                                    : Text(
                                        'CREATE ACCOUNT',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            
                            SizedBox(height: 20),
                            
                            // Login Link
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Sign In',
                                        style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}