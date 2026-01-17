// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/reg_api.dart';

// class BloodRequestForm extends StatefulWidget {
//   const BloodRequestForm({super.key});

//   @override
//   _BloodRequestFormState createState() => _BloodRequestFormState();
// }

// class _BloodRequestFormState extends State<BloodRequestForm> {
//   final _formKey = GlobalKey<FormState>();

//   String bloodGroup = 'A+';
//   bool availability = true;
//   String volunteerId = '';
//   String volunteerName = '';

//   final List<String> bloodGroups = [
//     'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
//   ];

//   final Dio dio = Dio(
   
//   );

//   /// 🔴 Submit API Call
//   Future<void> submitBloodRequest() async {
//     try {
  

//       final response = await dio.post(
//         "$baseurl/BloodDonation/$lid",
//         data: {
//           "Bloodgroup": bloodGroup,
          
//         },
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Blood Request Submitted")),
//       );

//       print("Response: ${response.data}");
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Submission Failed")),
//       );
//       print("Error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Blood Request')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [

//               /// Volunteer Name (UI only)
//               // TextFormField(
//               //   decoration: InputDecoration(labelText: 'Volunteer Name'),
//               //   onSaved: (value) => volunteerName = value!,
//               //   validator: (value) =>
//               //       value!.isEmpty ? 'Enter volunteer name' : null,
//               // ),

//               // /// Volunteer ID
//               // TextFormField(
//               //   decoration: InputDecoration(labelText: 'Volunteer ID'),
//               //   keyboardType: TextInputType.number,
//               //   onSaved: (value) => volunteerId = value!,
//               //   validator: (value) =>
//               //       value!.isEmpty ? 'Enter volunteer ID' : null,
//               // ),

//               /// Blood Group
//               DropdownButtonFormField(
//                 decoration: InputDecoration(labelText: 'Blood Group'),
//                 initialValue: bloodGroup,
//                 items: bloodGroups.map((group) {
//                   return DropdownMenuItem(
//                     value: group,
//                     child: Text(group),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     bloodGroup = value.toString();
//                   });
//                 },
//               ),

//               /// Availability
//               // SwitchListTile(
//               //   title: Text('Available to Donate'),
//               //   value: availability,
//               //   onChanged: (value) {
//               //     setState(() {
//               //       availability = value;
//               //     });
//               //   },
//               // ),

//               SizedBox(height: 20),

//               /// Submit
//               ElevatedButton(
//                 child: Text('Submit Request'),
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//                     submitBloodRequest();
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class BloodRequestForm extends StatefulWidget {
  const BloodRequestForm({super.key});

  @override
  State<BloodRequestForm> createState() => _BloodRequestFormState();
}

class _BloodRequestFormState extends State<BloodRequestForm> {
  final _formKey = GlobalKey<FormState>();
  
  String bloodGroup = 'A+';
  bool isSubmitting = false;
  
  final List<String> bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];

  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _validateLoginId();
  }

  void _validateLoginId() {
    if (lid == null || lid.toString().isEmpty || lid! <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorDialog(
          'Invalid User',
          'Please login again to submit a blood request.',
        );
      });
    }
  }

  Color _getBloodGroupColor(String group) {
    switch (group) {
      case 'A+':
      case 'A-':
        return Colors.red[600]!;
      case 'B+':
      case 'B-':
        return Colors.orange[700]!;
      case 'AB+':
      case 'AB-':
        return Colors.purple[600]!;
      case 'O+':
      case 'O-':
        return Colors.pink[700]!;
      default:
        return Colors.redAccent;
    }
  }

  Future<void> submitBloodRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (lid == null || lid! <= 0) {
      _showErrorDialog(
        'Invalid User',
        'Please login again to submit a blood request.',
      );
      return;
    }

    final confirmed = await _showConfirmationDialog();
    if (confirmed != true) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      final response = await dio.post(
        "$baseurl/BloodDonation/$lid",
        data: {
          "Bloodgroup": bloodGroup,
        },
        options: Options(
          validateStatus: (status) => status! < 500,
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessDialog();
      } else if (response.statusCode == 400) {
        throw Exception('Invalid request data');
      } else if (response.statusCode == 409) {
        throw Exception('You already have a pending blood request');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (!mounted) return;
      
      String message = 'Failed to submit blood request';
      
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.connectionError) {
        message = 'No internet connection. Please try again.';
      } else if (e.response?.statusCode == 400) {
        message = 'Invalid request. Please check your information.';
      } else if (e.response?.statusCode == 401) {
        message = 'Unauthorized. Please login again.';
      } else if (e.response?.statusCode == 409) {
        message = 'You already have a pending blood request.';
      } else if (e.response?.statusCode == 429) {
        message = 'Too many requests. Please try again later.';
      } else if (e.response != null) {
        message = 'Error ${e.response?.statusCode}: ${e.response?.statusMessage ?? "Unknown error"}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[700],
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
      
      debugPrint("Error: $e");
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred: ${e.toString()}'),
          backgroundColor: Colors.red[700],
          duration: const Duration(seconds: 4),
        ),
      );
      
      debugPrint("Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  Future<bool?> _showConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.bloodtype, color: _getBloodGroupColor(bloodGroup)),
            const SizedBox(width: 10),
            const Text('Confirm Request'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('You are about to submit a blood donation request for:'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getBloodGroupColor(bloodGroup).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getBloodGroupColor(bloodGroup).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bloodtype,
                    color: _getBloodGroupColor(bloodGroup),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Blood Group: $bloodGroup',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: _getBloodGroupColor(bloodGroup),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to proceed?',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getBloodGroupColor(bloodGroup),
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green[600],
                size: 64,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Request Submitted!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your blood donation request for $bloodGroup has been submitted successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nearby volunteers will be notified.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blood Request',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.redAccent.withOpacity(0.1),
                        Colors.pink.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.redAccent.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.bloodtype,
                          color: Colors.redAccent,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Request Blood Donation',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Select your required blood group',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),

                // Information Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your request will be sent to nearby volunteers who can help.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Blood Group Selection
                const Text(
                  'Blood Group Required',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Blood Group',
                      prefixIcon: Icon(
                        Icons.bloodtype,
                        color: _getBloodGroupColor(bloodGroup),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    value: bloodGroup,
                    items: bloodGroups.map((group) {
                      return DropdownMenuItem(
                        value: group,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getBloodGroupColor(group)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getBloodGroupColor(group)
                                      .withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                group,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _getBloodGroupColor(group),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          bloodGroup = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a blood group';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Selected Blood Group Display
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _getBloodGroupColor(bloodGroup).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getBloodGroupColor(bloodGroup).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Selected Blood Group:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getBloodGroupColor(bloodGroup),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: _getBloodGroupColor(bloodGroup)
                                  .withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          bloodGroup,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : submitBloodRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: Colors.redAccent.withOpacity(0.4),
                    ),
                    child: isSubmitting
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Submitting Request...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Submit Request',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Important Notice
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange[700],
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Important Notice',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[900],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Please ensure your location is enabled for volunteers to find you easily. You will be contacted by nearby volunteers.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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