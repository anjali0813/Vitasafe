// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/reg_api.dart';

// class VolunteerProfilePage extends StatefulWidget {
  

//   const VolunteerProfilePage({super.key});

//   @override
//   State<VolunteerProfilePage> createState() => _VolunteerProfilePageState();
// }

// class _VolunteerProfilePageState extends State<VolunteerProfilePage> {
//   bool isEditing = false;
//   bool isLoading = true;

//   final Dio dio = Dio();

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController skillsController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchProfile();
//   }

//   /// 🔹 GET PROFILE
//   Future<void> fetchProfile() async {
//     try {
//       final response = await dio.get(
//         "$baseurl/volunteer_profile/$lid",
//       );

//       final data = response.data;

//       nameController.text = data["Name"] ?? "";
//       emailController.text = data["Email"] ?? "";
//       phoneController.text = data["Phone"]?.toString() ?? "";
//       addressController.text = data["Address"] ?? "";
//       skillsController.text = data["Skills"] ?? "";

//       setState(() => isLoading = false);
//     } catch (e) {
//       debugPrint("Fetch error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to load profile")),
//       );
//     }
//   }

//   /// 🔹 UPDATE PROFILE
//   Future<void> updateProfile() async {
//     try {
//       await dio.put(
//         "$baseurl/volunteer_profile/$lid",
//         data: {
//           "Name": nameController.text,
//           "Email": emailController.text,
//           "Phone": phoneController.text,
//           "Address": addressController.text,
//           "Skills": skillsController.text,
//         },
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Profile Updated Successfully")),
//       );
//     } catch (e) {
//       debugPrint("Update error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Update failed")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Volunteer Profile"),
//         backgroundColor: Colors.teal,
//         actions: [
//           IconButton(
//             icon: Icon(isEditing ? Icons.check : Icons.edit),
//             onPressed: () async {
//               if (isEditing) {
//                 await updateProfile();
//               }
//               setState(() => isEditing = !isEditing);
//             },
//           )
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Volunteer Profile Details",
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 20),

//                     buildField("Full Name", nameController),
//                     buildEmailField("Email", emailController),
//                     buildField("Phone", phoneController),
//                     buildField("Address", addressController, maxLines: 2),
//                     buildField("Skills", skillsController),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget buildField(String label, TextEditingController controller,
//       {int maxLines = 1}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: const TextStyle(
//                 fontSize: 14, fontWeight: FontWeight.w600)),
//         const SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           enabled: isEditing,
//           maxLines: maxLines,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//           ),
//         ),
//         const SizedBox(height: 16),
//       ],
//     );
//   }

//   Widget buildEmailField(String label, TextEditingController controller,
//       {int maxLines = 1}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: const TextStyle(
//                 fontSize: 14, fontWeight: FontWeight.w600)),
//         const SizedBox(height: 8),
//         TextField(
//           readOnly: true,
//           controller: controller,
//           enabled: isEditing,
//           maxLines: maxLines,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//           ),
//         ),
//         const SizedBox(height: 16),
//       ],
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';
import 'dart:io';

class VolunteerProfilePage extends StatefulWidget {
  const VolunteerProfilePage({super.key});

  @override
  State<VolunteerProfilePage> createState() => _VolunteerProfilePageState();
}

class _VolunteerProfilePageState extends State<VolunteerProfilePage> {
  bool _isEditing = false;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasError = false;
  String _errorMessage = '';
  File? _profileImage;
  final Dio _dio = Dio();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  // Statistics
  int _totalTasks = 0;
  int _completedTasks = 0;
  int _emergencyResponses = 0;
  int _bloodDonations = 0;
  double _rating = 4.5;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _fetchStatistics();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _skillsController.dispose();
    _experienceController.dispose();
    _bloodGroupController.dispose();
    _availabilityController.dispose();
    _emergencyContactController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await _dio.get(
        "$baseurl/volunteer_profile/$lid",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Validate data structure
        if (data is! Map<String, dynamic>) {
          throw Exception('Invalid profile data format');
        }
        
        setState(() {
          _nameController.text = data["Name"]?.toString() ?? "";
          _emailController.text = data["Email"]?.toString() ?? "";
          _phoneController.text = data["Phone"]?.toString() ?? "";
          _addressController.text = data["Address"]?.toString() ?? "";
          _skillsController.text = data["Skills"]?.toString() ?? "";
          _experienceController.text = data["experience"]?.toString() ?? "";
          _bloodGroupController.text = data["blood_group"]?.toString() ?? "";
          _availabilityController.text = data["availability"]?.toString() ?? "Available";
          _emergencyContactController.text = data["emergency_contact"]?.toString() ?? "";
          
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        // New volunteer - initialize empty profile
        _initializeNewProfile();
      } else {
        throw Exception('Server responded with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleApiError(e);
    } catch (e) {
      _handleGenericError(e.toString());
    }
  }

  void _initializeNewProfile() {
    setState(() {
      _isLoading = false;
      _isEditing = true; // Allow editing for new profile
    });
  }

  void _handleApiError(DioException e) {
    String errorMessage = 'Failed to load profile';
    
    if (e.response != null) {
      switch (e.response!.statusCode) {
        case 401:
          errorMessage = 'Session expired. Please login again.';
          break;
        case 403:
          errorMessage = 'Access denied. Please check your permissions.';
          break;
        case 500:
          errorMessage = 'Server error. Please try again later.';
          break;
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      errorMessage = 'Connection timeout. Please check your internet.';
    } else if (e.type == DioExceptionType.connectionError) {
      errorMessage = 'No internet connection. Please connect and try again.';
    }
    
    setState(() {
      _hasError = true;
      _errorMessage = errorMessage;
      _isLoading = false;
    });
  }

  void _handleGenericError(String error) {
    setState(() {
      _hasError = true;
      _errorMessage = 'Error: $error';
      _isLoading = false;
    });
  }

  Future<void> _fetchStatistics() async {
    try {
      final tasksResponse = await _dio.get('$baseurl/volunteer-stats/$lid');
      if (tasksResponse.statusCode == 200) {
        setState(() {
          _totalTasks = tasksResponse.data['total_tasks'] ?? 0;
          _completedTasks = tasksResponse.data['completed_tasks'] ?? 0;
          _emergencyResponses = tasksResponse.data['emergency_responses'] ?? 0;
          _bloodDonations = tasksResponse.data['blood_donations'] ?? 0;
          _rating = tasksResponse.data['rating']?.toDouble() ?? 4.5;
        });
      }
    } catch (e) {
      debugPrint('Error fetching statistics: $e');
    }
  }

  // Validations
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
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
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validateBloodGroup(String? value) {
    if (value != null && value.isNotEmpty) {
      final validGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
      if (!validGroups.contains(value.toUpperCase())) {
        return 'Please enter a valid blood group (e.g., A+, O-)';
      }
    }
    return null;
  }

  String? _validateEmergencyContact(String? value) {
    if (value != null && value.isNotEmpty) {
      final phoneRegex = RegExp(r'^[0-9]{10}$');
      if (!phoneRegex.hasMatch(value.trim())) {
        return 'Please enter a valid 10-digit phone number';
      }
    }
    return null;
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isSaving = true;
    });

    try {
      await _dio.put(
        "$baseurl/volunteer_profile/$lid",
        data: {
          "Name": _nameController.text.trim(),
          "Email": _emailController.text.trim(),
          "Phone": _phoneController.text.trim(),
          "Address": _addressController.text.trim(),
          "Skills": _skillsController.text.trim(),
          "experience": _experienceController.text.trim(),
          "blood_group": _bloodGroupController.text.trim().toUpperCase(),
          "availability": _availabilityController.text.trim(),
          "emergency_contact": _emergencyContactController.text.trim(),
          "updated_at": DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Upload image if selected
      if (_profileImage != null) {
        await _uploadProfileImage();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Profile updated successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      setState(() {
        _isEditing = false;
        _isSaving = false;
      });

      // Refresh statistics
      await _fetchStatistics();
      
    } on DioException catch (e) {
      _handleUpdateError(e);
    } catch (e) {
      _handleUpdateErrorGeneric(e.toString());
    }
  }

  Future<void> _uploadProfileImage() async {
    // Implement image upload to server
    // This would typically involve multipart/form-data
    debugPrint('Image upload would happen here');
  }

  void _handleUpdateError(DioException e) {
    String errorMessage = 'Failed to update profile';
    
    if (e.response != null) {
      if (e.response!.statusCode == 409) {
        errorMessage = 'Email already exists. Please use a different email.';
      } else if (e.response!.statusCode == 400) {
        errorMessage = 'Invalid data. Please check your inputs.';
      }
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
    
    setState(() => _isSaving = false);
  }

  void _handleUpdateErrorGeneric(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $error'),
        backgroundColor: Colors.red,
      ),
    );
    setState(() => _isSaving = false);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Widget _buildProfileHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
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
                if (_isEditing)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      onPressed: _pickImage,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              _nameController.text.isNotEmpty ? _nameController.text : 'Volunteer',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Volunteer ID: ${lid.toString()}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 18),
                SizedBox(width: 5),
                Text(
                  _rating.toStringAsFixed(1),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Volunteer Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Tasks', '$_completedTasks/$_totalTasks', Icons.task),
                _buildStatItem('Emergencies', '$_emergencyResponses', Icons.warning),
                _buildStatItem('Donations', '$_bloodDonations', Icons.bloodtype),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.teal.withOpacity(0.3)),
          ),
          child: Icon(icon, size: 24, color: Colors.teal),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool readOnly = false,
    bool isRequired = true,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? helperText,
    IconData? prefixIcon,
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
            if (isRequired && _isEditing)
              Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: _isEditing && !readOnly,
          readOnly: readOnly,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: helperText ?? 'Enter $label',
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
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
            filled: !_isEditing,
            fillColor: !_isEditing ? Colors.grey[100] : null,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropDownField({
    required String label,
    required String value,
    required List<String> options,
    required Function(String?) onChanged,
    bool isRequired = false,
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
            if (isRequired && _isEditing)
              Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        SizedBox(height: 6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.isNotEmpty ? value : null,
              isExpanded: true,
              hint: Text('Select $label'),
              items: options.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: _isEditing ? onChanged : null,
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.redAccent),
          SizedBox(height: 20),
          Text(
            'Unable to Load Profile',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _fetchProfile,
            icon: Icon(Icons.refresh),
            label: Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Volunteer Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          if (!_isLoading && !_hasError)
            IconButton(
              icon: _isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(_isEditing ? Icons.save : Icons.edit),
              onPressed: () async {
                if (_isEditing) {
                  await _updateProfile();
                } else {
                  setState(() => _isEditing = true);
                }
              },
              tooltip: _isEditing ? 'Save Profile' : 'Edit Profile',
            ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchProfile,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 20),
                  Text(
                    'Loading profile...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : _hasError
              ? _buildErrorState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Header
                        _buildProfileHeader(),
                        
                        SizedBox(height: 20),
                        
                        // Statistics
                        _buildStatsCard(),
                        
                        SizedBox(height: 25),
                        
                        Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Personal Information Form
                        _buildFormField(
                          label: 'Full Name',
                          controller: _nameController,
                          validator: _validateName,
                          prefixIcon: Icons.person,
                        ),
                        
                        _buildFormField(
                          label: 'Email Address',
                          controller: _emailController,
                          validator: _validateEmail,
                          readOnly: true, // Email shouldn't be changed easily
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email,
                        ),
                        
                        _buildFormField(
                          label: 'Phone Number',
                          controller: _phoneController,
                          validator: _validatePhone,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone,
                        ),
                        
                        _buildDropDownField(
                          label: 'Blood Group',
                          value: _bloodGroupController.text,
                          options: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
                          onChanged: (value) {
                            setState(() => _bloodGroupController.text = value ?? '');
                          },
                        ),
                        
                        _buildFormField(
                          label: 'Emergency Contact',
                          controller: _emergencyContactController,
                          validator: _validateEmergencyContact,
                          keyboardType: TextInputType.phone,
                          helperText: 'Contact number in case of emergency',
                          prefixIcon: Icons.emergency,
                        ),
                        
                        SizedBox(height: 25),
                        
                        Text(
                          'Volunteer Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        _buildFormField(
                          label: 'Address',
                          controller: _addressController,
                          validator: (value) => null, // Optional
                          maxLines: 2,
                          prefixIcon: Icons.location_on,
                        ),
                        
                        _buildFormField(
                          label: 'Skills & Expertise',
                          controller: _skillsController,
                          validator: (value) => null, // Optional
                          maxLines: 2,
                          helperText: 'First aid, CPR, driving, etc.',
                          prefixIcon: Icons.medical_services,
                        ),
                        
                        _buildFormField(
                          label: 'Experience',
                          controller: _experienceController,
                          validator: (value) => null, // Optional
                          helperText: 'Years of volunteering experience',
                          prefixIcon: Icons.work_history,
                        ),
                        
                        _buildDropDownField(
                          label: 'Availability Status',
                          value: _availabilityController.text.isNotEmpty 
                              ? _availabilityController.text 
                              : 'Available',
                          options: ['Available', 'Busy', 'Away', 'Unavailable'],
                          onChanged: (value) {
                            setState(() => _availabilityController.text = value ?? 'Available');
                          },
                        ),
                        
                        SizedBox(height: 30),
                        
                        // Action Buttons
                        if (_isEditing)
                          Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton.icon(
                                  onPressed: _isSaving ? null : _updateProfile,
                                  icon: _isSaving
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Icon(Icons.save),
                                  label: Text(
                                    _isSaving ? 'SAVING...' : 'SAVE CHANGES',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: OutlinedButton(
                                  onPressed: _isSaving
                                      ? null
                                      : () {
                                          setState(() {
                                            _isEditing = false;
                                            _fetchProfile(); // Reload original data
                                          });
                                        },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    side: BorderSide(color: Colors.grey[400]!),
                                  ),
                                  child: Text(
                                    'CANCEL',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
    );
  }
}