// import 'package:flutter/material.dart';

// class MedicalEmergencyPage extends StatefulWidget {
//   const MedicalEmergencyPage({super.key});

//   @override
//   State<MedicalEmergencyPage> createState() => _MedicalEmergencyPageState();
// }

// class _MedicalEmergencyPageState extends State<MedicalEmergencyPage> {
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   bool isSubmitting = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Medical Emergency"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Report a Medical Emergency",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),

//             TextField(
//               controller: locationController,
//               decoration: InputDecoration(
//                 labelText: "Emergency Location",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             TextField(
//               controller: descriptionController,
//               maxLines: 3,
//               decoration: InputDecoration(
//                 labelText: "Patient Condition (Optional)",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: isSubmitting ? null : _submitAlert,
//                 icon: const Icon(Icons.local_hospital),
//                 label: Text(isSubmitting ? "Sending..." : "Send Alert"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.redAccent,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _submitAlert() async {
//     if (locationController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter the emergency location.")),
//       );
//       return;
//     }

//     setState(() => isSubmitting = true);
//     await Future.delayed(const Duration(seconds: 2));
//     setState(() => isSubmitting = false);

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Medical emergency alert sent!")),
//     );

//     locationController.clear();
//     descriptionController.clear();
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MedicalEmergencyPage extends StatefulWidget {
  const MedicalEmergencyPage({super.key});

  @override
  State<MedicalEmergencyPage> createState() => _MedicalEmergencyPageState();
}

class _MedicalEmergencyPageState extends State<MedicalEmergencyPage> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _patientAgeController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _emergencyLevelController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _locationFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  
  bool _isSubmitting = false;
  bool _isGettingLocation = false;
  bool _isEmergencyCall = false;
  String? _selectedEmergencyType;
  String? _selectedGender;
  int? _selectedEmergencyLevel = 1;
  DateTime _emergencyTime = DateTime.now();
  List<String> _recentLocations = [];
  
  final List<String> _emergencyTypes = [
    'Heart Attack/Cardiac',
    'Stroke',
    'Respiratory Distress',
    'Severe Bleeding',
    'Unconsciousness',
    'Fracture/Injury',
    'Allergic Reaction',
    'Burn Injury',
    'Poisoning',
    'Other'
  ];

  final List<String> _emergencyLevels = [
    'Low - Stable Condition',
    'Medium - Urgent Care Needed',
    'High - Critical Condition',
    'Critical - Life Threatening'
  ];

  @override
  void initState() {
    super.initState();
    _loadRecentLocations();
    _locationController.addListener(_onLocationChanged);
  }

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    _patientAgeController.dispose();
    _contactNumberController.dispose();
    _emergencyLevelController.dispose();
    _locationFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _loadRecentLocations() {
    // Load recent locations from storage
    _recentLocations = [
      'Home - 123 Main St',
      'Work - 456 Office Ave',
      'City Hospital',
      'Central Park'
    ];
  }

  void _onLocationChanged() {
    // Real-time validation or suggestions
  }

  String? _validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter emergency location';
    }
    if (value.trim().length < 5) {
      return 'Please provide a more specific location';
    }
    return null;
  }

  String? _validateContact(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter contact number';
    }
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value != null && value.isNotEmpty) {
      final age = int.tryParse(value);
      if (age == null || age < 0 || age > 150) {
        return 'Please enter a valid age';
      }
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value != null && value.trim().length > 500) {
      return 'Description cannot exceed 500 characters';
    }
    return null;
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);
    
    // Simulate location fetching
    await Future.delayed(const Duration(seconds: 2));
    
    // In real app, use geolocation package
    setState(() {
      _locationController.text = 'Current Location - GPS Coordinates';
      _isGettingLocation = false;
    });
  }

  Future<void> _makeEmergencyCall() async {
    setState(() => _isEmergencyCall = true);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.emergency, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Text('Emergency Call'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.red),
            SizedBox(height: 20),
            Text(
              'Connecting to emergency services...\nCalling 112',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      Navigator.pop(context);
      setState(() => _isEmergencyCall = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Connected to emergency services'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _submitAlert() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedEmergencyType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select emergency type'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() => _isSubmitting = true);

    try {
      // Prepare emergency data
      final emergencyData = {
        'location': _locationController.text.trim(),
        'description': _descriptionController.text.trim(),
        'emergencyType': _selectedEmergencyType,
        'emergencyLevel': _selectedEmergencyLevel,
        'patientAge': _patientAgeController.text.trim(),
        'patientGender': _selectedGender,
        'contactNumber': _contactNumberController.text.trim(),
        'emergencyTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(_emergencyTime),
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Show success dialog
      await _showSuccessDialog(emergencyData);

      // Add to recent locations
      if (!_recentLocations.contains(_locationController.text.trim())) {
        _recentLocations.insert(0, _locationController.text.trim());
        if (_recentLocations.length > 5) {
          _recentLocations.removeLast();
        }
      }

      // Clear form
      _formKey.currentState!.reset();
      setState(() {
        _selectedEmergencyType = null;
        _selectedGender = null;
        _selectedEmergencyLevel = 1;
        _descriptionController.clear();
      });

    } catch (e) {
      _showErrorDialog('Failed to send alert: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _showSuccessDialog(Map<String, dynamic> emergencyData) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Alert Sent Successfully!'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Emergency alert has been sent to nearby hospitals and volunteers.', style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 15),
              Text('Emergency Details:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildDetailRow('Type', emergencyData['emergencyType'] ?? 'N/A'),
              _buildDetailRow('Location', emergencyData['location']),
              _buildDetailRow('Time', emergencyData['emergencyTime']),
              _buildDetailRow('Level', _emergencyLevels[emergencyData['emergencyLevel']! - 1]),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.green[700], size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Help is on the way! Stay with the patient.',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Text('Alert Failed'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyTypeChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _emergencyTypes.map((type) {
        return ChoiceChip(
          label: Text(type),
          selected: _selectedEmergencyType == type,
          onSelected: (selected) {
            setState(() {
              _selectedEmergencyType = selected ? type : null;
            });
          },
          selectedColor: Colors.red.withOpacity(0.2),
          backgroundColor: Colors.grey[200],
          labelStyle: TextStyle(
            color: _selectedEmergencyType == type ? Colors.red : Colors.grey[700],
            fontWeight: _selectedEmergencyType == type ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmergencyLevelSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Severity Level',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Slider(
          value: _selectedEmergencyLevel?.toDouble() ?? 1.0,
          min: 1,
          max: 4,
          divisions: 3,
          label: _emergencyLevels[_selectedEmergencyLevel! - 1],
          onChanged: (value) {
            setState(() {
              _selectedEmergencyLevel = value.toInt();
            });
          },
          activeColor: _getEmergencyLevelColor(_selectedEmergencyLevel!),
          inactiveColor: Colors.grey[300],
        ),
        Text(
          _emergencyLevels[_selectedEmergencyLevel! - 1],
          style: TextStyle(
            color: _getEmergencyLevelColor(_selectedEmergencyLevel!),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getEmergencyLevelColor(int level) {
    switch (level) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      case 4:
        return Colors.red[900]!;
      default:
        return Colors.grey;
    }
  }

  Widget _buildRecentLocations() {
    if (_recentLocations.isEmpty) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Locations',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _recentLocations.map((location) {
            return ActionChip(
              label: Text(location),
              onPressed: () {
                _locationController.text = location;
              },
              backgroundColor: Colors.grey[100],
              labelStyle: TextStyle(color: Colors.blue),
            );
          }).toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Medical Emergency",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.emergency),
            onPressed: _isEmergencyCall ? null : _makeEmergencyCall,
            tooltip: 'Emergency Call',
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => _showFirstAidGuide(context),
            tooltip: 'First Aid Guide',
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.redAccent.withOpacity(0.05),
                  Colors.white,
                ],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Emergency Alert Header
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber, size: 40, color: Colors.redAccent),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Report Medical Emergency",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Provide details for immediate assistance",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Emergency Type Selection
                    Text(
                      "Emergency Type *",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildEmergencyTypeChips(),
                    if (_selectedEmergencyType != null) ...[
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.red, size: 20),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _getEmergencyInstructions(_selectedEmergencyType!),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: 20),

                    // Emergency Level
                    _buildEmergencyLevelSlider(),

                    SizedBox(height: 25),

                    // Location Input
                    Text(
                      "Emergency Location *",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _locationController,
                            focusNode: _locationFocusNode,
                            decoration: InputDecoration(
                              hintText: "Enter exact location or address",
                              prefixIcon: Icon(Icons.location_on, color: Colors.redAccent),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.redAccent, width: 2),
                              ),
                            ),
                            validator: _validateLocation,
                          ),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: _isGettingLocation
                              ? CircularProgressIndicator(color: Colors.redAccent, strokeWidth: 2)
                              : Icon(Icons.my_location, color: Colors.redAccent),
                          onPressed: _isGettingLocation ? null : _getCurrentLocation,
                          tooltip: 'Use Current Location',
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Recent Locations
                    _buildRecentLocations(),

                    // Patient Information
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Patient Information",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _patientAgeController,
                                    decoration: InputDecoration(
                                      labelText: "Age (Optional)",
                                      prefixIcon: Icon(Icons.person, color: Colors.grey[600]),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: _validateAge,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedGender,
                                    decoration: InputDecoration(
                                      labelText: "Gender (Optional)",
                                      prefixIcon: Icon(Icons.person_outline, color: Colors.grey[600]),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    items: [
                                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                                    ],
                                    onChanged: (value) {
                                      setState(() => _selectedGender = value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Contact Number
                    Text(
                      "Contact Number *",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _contactNumberController,
                      decoration: InputDecoration(
                        hintText: "Enter 10-digit contact number",
                        prefixIcon: Icon(Icons.phone, color: Colors.redAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: _validateContact,
                    ),

                    SizedBox(height: 20),

                    // Description
                    Text(
                      "Additional Details (Optional)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      focusNode: _descriptionFocusNode,
                      maxLines: 4,
                      maxLength: 500,
                      decoration: InputDecoration(
                        hintText: "Describe symptoms, medical history, or other important details...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.redAccent, width: 2),
                        ),
                      ),
                      validator: _validateDescription,
                    ),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${_descriptionController.text.length}/500',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _submitAlert,
                        icon: _isSubmitting
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(Icons.send),
                        label: Text(
                          _isSubmitting ? 'SENDING ALERT...' : 'SEND EMERGENCY ALERT',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          shadowColor: Colors.redAccent.withOpacity(0.5),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Cancel Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey[400]!),
                        ),
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          // Loading Overlay
          if (_isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Sending emergency alert...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Alerting nearby hospitals and volunteers',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getEmergencyInstructions(String emergencyType) {
    switch (emergencyType) {
      case 'Heart Attack/Cardiac':
        return 'Keep patient calm and seated. Do not give anything to eat or drink.';
      case 'Stroke':
        return 'Note time symptoms started. Keep patient lying on side.';
      case 'Severe Bleeding':
        return 'Apply direct pressure to wound with clean cloth. Elevate injured area.';
      case 'Unconsciousness':
        return 'Check breathing. Do not move patient unless in danger.';
      case 'Respiratory Distress':
        return 'Help patient sit up. Loosen tight clothing.';
      default:
        return 'Stay with patient. Do not give food/drink. Keep warm.';
    }
  }

  void _showFirstAidGuide(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'First Aid Instructions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildFirstAidStep('1. Stay Calm', 'Keep yourself and others calm'),
                    _buildFirstAidStep('2. Check Danger', 'Ensure scene is safe'),
                    _buildFirstAidStep('3. Check Response', 'Tap shoulder, ask if okay'),
                    _buildFirstAidStep('4. Call for Help', 'Dial 112 or local emergency'),
                    _buildFirstAidStep('5. Check Breathing', 'Look, listen, feel for breathing'),
                    _buildFirstAidStep('6. Control Bleeding', 'Apply pressure to wounds'),
                    _buildFirstAidStep('7. Treat for Shock', 'Keep warm, elevate legs'),
                    _buildFirstAidStep('8. Stay with Patient', 'Provide comfort until help arrives'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFirstAidStep(String step, String instruction) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step.split('.')[0],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(step),
        subtitle: Text(instruction),
      ),
    );
  }
}