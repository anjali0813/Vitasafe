// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:vitasafe/reg_api.dart'; // contains baseurl

// class AccidentAlertPage extends StatefulWidget {
//   const AccidentAlertPage({super.key});

//   @override
//   State<AccidentAlertPage> createState() => _AccidentAlertPageState();
// }

// class _AccidentAlertPageState extends State<AccidentAlertPage> {
//   final TextEditingController descriptionController = TextEditingController();
//   bool isSubmitting = false;

//   final Dio dio = Dio();

//   double? latitude;
//   double? longitude;

//   @override
//   void initState() {
//     super.initState();
//     _fetchCurrentLocation();
//   }

//   /// Fetch current GPS location
//   Future<void> _fetchCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Location services are disabled.')),
//       );
//       return;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Location permissions are denied')),
//         );
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Location permissions are permanently denied')),
//       );
//       return;
//     }

//     final Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     setState(() {
//       latitude = position.latitude;
//       longitude = position.longitude;
//     });
//   }

//   /// Send alert to backend
//   Future<void> _submitAlert() async {
//     if (latitude == null || longitude == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Location not available.")),
//       );
//       return;
//     }

//     setState(() => isSubmitting = true);

//     try {
//       final response = await dio.post(
//         "$baseurl/alert",
//         data: {
//           "Alert": descriptionController.text.isEmpty
//               ? "Accident alert"
//               : descriptionController.text,
//           "Latitude": latitude,
//           "Longitude": longitude,
//         },
//       );

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Accident alert sent successfully!")),
//         );
//         descriptionController.clear();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to send alert")),
//         );
//       }
//     } catch (e) {
//       debugPrint("Alert error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Error sending alert")),
//       );
//     }

//     setState(() => isSubmitting = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Accident Alert"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Report an Accident",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),

//             TextField(
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: latitude != null && longitude != null
//                     ? "Current Location: $latitude, $longitude"
//                     : "Fetching location...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.my_location),
//                   onPressed: _fetchCurrentLocation,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             TextField(
//               controller: descriptionController,
//               maxLines: 3,
//               decoration: InputDecoration(
//                 labelText: "Description (Optional)",
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
//                 icon: const Icon(Icons.warning_amber_rounded),
//                 label: Text(isSubmitting ? "Sending..." : "Send Alert"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.redAccent,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   textStyle: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

class AccidentAlertPage extends StatefulWidget {
  const AccidentAlertPage({super.key});

  @override
  State<AccidentAlertPage> createState() => _AccidentAlertPageState();
}

class _AccidentAlertPageState extends State<AccidentAlertPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();
  
  final Dio dio = Dio();
  
  bool isSubmitting = false;
  bool isFetchingLocation = false;
  String locationStatus = 'Not fetched';
  
  double? latitude;
  double? longitude;
  
  String selectedSeverity = 'Medium';
  String selectedAccidentType = 'Vehicle Collision';
  bool needsAmbulance = false;
  bool needsPolice = false;
  bool needsFireService = false;
  int injuredCount = 0;

  final List<String> severityLevels = ['Minor', 'Medium', 'Severe', 'Critical'];
  final List<String> accidentTypes = [
    'Vehicle Collision',
    'Pedestrian Accident',
    'Motorcycle Accident',
    'Hit and Run',
    'Multi-Vehicle Crash',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    contactController.dispose();
    vehicleController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() {
      isFetchingLocation = true;
      locationStatus = 'Fetching...';
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          locationStatus = 'Location services disabled';
          isFetchingLocation = false;
        });
        _showSnackBar('Location services are disabled. Please enable location.', Colors.orange);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            locationStatus = 'Permission denied';
            isFetchingLocation = false;
          });
          _showSnackBar('Location permissions denied. Please grant access.', Colors.red);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationStatus = 'Permission permanently denied';
          isFetchingLocation = false;
        });
        _showSnackBar('Location permissions permanently denied. Enable in settings.', Colors.red);
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        locationStatus = 'Location acquired';
        isFetchingLocation = false;
      });

      _showSnackBar('Location acquired successfully!', Colors.green);
    } catch (e) {
      setState(() {
        locationStatus = 'Error fetching location';
        isFetchingLocation = false;
      });
      _showSnackBar('Error getting location: ${e.toString()}', Colors.red);
    }
  }

  Future<void> _submitAlert() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (latitude == null || longitude == null) {
      _showSnackBar('Location not available. Please enable location.', Colors.orange);
      return;
    }

    setState(() => isSubmitting = true);

    try {
      // Prepare emergency services needed
      List<String> servicesNeeded = [];
      if (needsAmbulance) servicesNeeded.add('Ambulance');
      if (needsPolice) servicesNeeded.add('Police');
      if (needsFireService) servicesNeeded.add('Fire Service');

      final response = await dio.post(
        'YOUR_BASE_URL/alert',
        data: {
          "Alert": descriptionController.text.isEmpty
              ? "$selectedAccidentType reported"
              : descriptionController.text,
          "Latitude": latitude,
          "Longitude": longitude,
          "Contact": contactController.text,
          "AccidentType": selectedAccidentType,
          "Severity": selectedSeverity,
          "InjuredCount": injuredCount,
          "VehicleInfo": vehicleController.text,
          "ServicesNeeded": servicesNeeded.join(', '),
          "Timestamp": DateTime.now().toIso8601String(),
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        
        _showSuccessDialog();
        _clearForm();
      } else {
        _showSnackBar('Failed to send alert. Please try again.', Colors.red);
      }
    } on DioException catch (e) {
      String message = "Network error";
      if (e.type == DioExceptionType.connectionTimeout) {
        message = "Connection timeout. Please check your internet.";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        message = "Server response timeout.";
      } else if (e.type == DioExceptionType.connectionError) {
        message = "No internet connection.";
      }
      _showSnackBar(message, Colors.red);
    } catch (e) {
      _showSnackBar('Error sending alert: ${e.toString()}', Colors.red);
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[600], size: 28),
            const SizedBox(width: 12),
            const Text("Alert Sent!"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your accident alert has been sent successfully to emergency services."),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(Icons.location_on, 
                    "${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)}"),
                  _buildInfoRow(Icons.phone, contactController.text),
                  _buildInfoRow(Icons.warning, "Severity: $selectedSeverity"),
                  _buildInfoRow(Icons.directions_car, selectedAccidentType),
                  if (injuredCount > 0)
                    _buildInfoRow(Icons.person_off, "$injuredCount injured"),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Emergency services will arrive shortly. Stay safe!",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearForm() {
    descriptionController.clear();
    contactController.clear();
    vehicleController.clear();
    setState(() {
      selectedSeverity = 'Medium';
      selectedAccidentType = 'Vehicle Collision';
      needsAmbulance = false;
      needsPolice = false;
      needsFireService = false;
      injuredCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Accident Emergency Alert",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Emergency Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red[700]!, Colors.red[500]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.car_crash,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Report Accident",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Emergency services will be notified immediately",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Location Status Card
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getLocationStatusColor(),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getLocationStatusBorderColor(),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    latitude != null ? Icons.location_on : Icons.location_off,
                    color: latitude != null ? Colors.green[700] : Colors.red[700],
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locationStatus,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: latitude != null ? Colors.green[900] : Colors.red[900],
                          ),
                        ),
                        if (latitude != null && longitude != null)
                          Text(
                            "${latitude!.toStringAsFixed(6)}, ${longitude!.toStringAsFixed(6)}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[700],
                            ),
                          )
                        else
                          Text(
                            "Location required for emergency response",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red[700],
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: isFetchingLocation
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                    onPressed: isFetchingLocation ? null : _fetchCurrentLocation,
                    tooltip: "Refresh Location",
                  ),
                ],
              ),
            ),

            // Form Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Accident Type
                    _buildSectionTitle("Accident Type *"),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedAccidentType,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.red[700]),
                          items: accidentTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Row(
                                children: [
                                  Icon(Icons.car_crash, size: 20, color: Colors.red[700]),
                                  const SizedBox(width: 12),
                                  Text(type),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() => selectedAccidentType = newValue!);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Contact Number
                    _buildSectionTitle("Contact Number *"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: contactController,
                      keyboardType: TextInputType.phone,
                      decoration: _buildInputDecoration(
                        labelText: "Your phone number",
                        hintText: "e.g., +91 9876543210",
                        prefixIcon: Icons.phone,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Contact number is required';
                        }
                        if (value.trim().length < 10) {
                          return 'Please enter a valid contact number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Severity Level
                    _buildSectionTitle("Severity Level *"),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          _buildSeverityOption('Minor', 'Minor damage, no injuries'),
                          Divider(height: 1, color: Colors.grey[300]),
                          _buildSeverityOption('Medium', 'Moderate damage/injuries'),
                          Divider(height: 1, color: Colors.grey[300]),
                          _buildSeverityOption('Severe', 'Significant damage/injuries'),
                          Divider(height: 1, color: Colors.grey[300]),
                          _buildSeverityOption('Critical', 'Life-threatening situation'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Number of Injured
                    _buildSectionTitle("Number of People Injured"),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person_off, color: Colors.red[700]),
                              const SizedBox(width: 12),
                              const Text(
                                "Injured Count:",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: injuredCount > 0
                                    ? () => setState(() => injuredCount--)
                                    : null,
                                color: Colors.red[700],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  injuredCount.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[700],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => setState(() => injuredCount++),
                                color: Colors.red[700],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Vehicle Information
                    _buildSectionTitle("Vehicle Information"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: vehicleController,
                      decoration: _buildInputDecoration(
                        labelText: "Vehicle number/details (optional)",
                        hintText: "e.g., KL-01-AB-1234",
                        prefixIcon: Icons.directions_car,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Emergency Services Needed
                    _buildSectionTitle("Emergency Services Required"),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildCheckboxTile(
                            'Ambulance',
                            needsAmbulance,
                            Icons.local_hospital,
                            Colors.red,
                            (value) => setState(() => needsAmbulance = value!),
                          ),
                          _buildCheckboxTile(
                            'Police',
                            needsPolice,
                            Icons.local_police,
                            Colors.blue,
                            (value) => setState(() => needsPolice = value!),
                          ),
                          _buildCheckboxTile(
                            'Fire Service',
                            needsFireService,
                            Icons.fire_truck,
                            Colors.orange,
                            (value) => setState(() => needsFireService = value!),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Description
                    _buildSectionTitle("Additional Details"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      maxLength: 500,
                      decoration: _buildInputDecoration(
                        labelText: "Describe the situation (optional)",
                        hintText: "What happened? Any specific hazards or concerns?",
                        prefixIcon: Icons.description,
                        alignLabelWithHint: true,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Emergency Contact Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.emergency, color: Colors.orange[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Emergency Helplines",
                                  style: TextStyle(
                                    color: Colors.orange[900],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Ambulance: 108 | Police: 100 | Fire: 101",
                                  style: TextStyle(
                                    color: Colors.orange[800],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
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
                        onPressed: (isSubmitting || latitude == null) 
                            ? null 
                            : _submitAlert,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[400],
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Sending Alert...",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.warning_amber_rounded, size: 24),
                                  const SizedBox(width: 8),
                                  Text(
                                    latitude == null 
                                        ? "LOCATION REQUIRED"
                                        : "SEND EMERGENCY ALERT",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      alignLabelWithHint: alignLabelWithHint,
      prefixIcon: Icon(prefixIcon, color: Colors.red[700]),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red[700]!, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildSeverityOption(String level, String description) {
    final isSelected = selectedSeverity == level;
    Color getColor() {
      switch (level) {
        case 'Minor':
          return Colors.blue;
        case 'Medium':
          return Colors.orange;
        case 'Severe':
          return Colors.deepOrange;
        case 'Critical':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return InkWell(
      onTap: () => setState(() => selectedSeverity = level),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? getColor() : Colors.grey[400]!,
                  width: 2,
                ),
                color: isSelected ? getColor() : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? getColor() : Colors.grey[800],
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxTile(
    String title,
    bool value,
    IconData icon,
    Color iconColor,
    Function(bool?) onChanged,
  ) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      activeColor: Colors.red[700],
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Color _getLocationStatusColor() {
    if (latitude != null) return Colors.green[50]!;
    if (isFetchingLocation) return Colors.blue[50]!;
    return Colors.red[50]!;
  }

  Color _getLocationStatusBorderColor() {
    if (latitude != null) return Colors.green[200]!;
    if (isFetchingLocation) return Colors.blue[200]!;
    return Colors.red[200]!;
  }
}