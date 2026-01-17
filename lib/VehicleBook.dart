// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/reg_api.dart';

// class VehicleBookingPage extends StatefulWidget {
//   final int ambulanceId;

//   const VehicleBookingPage({super.key, required this.ambulanceId});

//   @override
//   State<VehicleBookingPage> createState() => _VehicleBookingPageState();
// }

// class _VehicleBookingPageState extends State<VehicleBookingPage> {
//   DateTime? selectedDate;
//   bool isLoading = false;


//   Future<void> _bookAmbulance() async {
//     if (selectedDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please select a date")),
//       );
//       return;
//     }

//     setState(() => isLoading = true);

//     try {
//       final response = await Dio().post(
//         "$baseurl/ambulancebooking/$lid/${widget.ambulanceId}",
//         data: {
//           "Date": selectedDate!.toIso8601String().split("T")[0],
//         },
        
//       );
//       print(response.data);

//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Ambulance Booked Successfully")),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       print("Booking error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Booking Failed")),
//       );
//     }

//     setState(() => isLoading = false);
//   }

//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2030),
//     );

//     if (picked != null) {
//       setState(() => selectedDate = picked);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Book Ambulance"),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextButton(
//               onPressed: _pickDate,
//               child: const Text("Select Date"),
//             ),
//             Text(
//               selectedDate == null
//                   ? "No date selected"
//                   : selectedDate.toString().split(" ")[0],
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: isLoading ? null : _bookAmbulance,
//               child: isLoading
//                   ? CircularProgressIndicator(color: Colors.white)
//                   : const Text("BOOK AMBULANCE"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class VehicleBookingPage extends StatefulWidget {
  final int ambulanceId;
  final String? ambulanceName;
  final String? ambulanceType;
  final String? vehicleNumber;

  const VehicleBookingPage({
    super.key,
    required this.ambulanceId,
    this.ambulanceName,
    this.ambulanceType,
    this.vehicleNumber,
  });

  @override
  State<VehicleBookingPage> createState() => _VehicleBookingPageState();
}

class _VehicleBookingPageState extends State<VehicleBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pickupLocationController = TextEditingController();
  final TextEditingController dropLocationController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isLoading = false;
  String selectedUrgency = 'Normal';
  bool needsOxygenSupport = false;
  bool needsStretcher = true;
  bool needsParamedic = false;

  final List<String> urgencyLevels = ['Normal', 'Urgent', 'Emergency', 'Critical'];

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    pickupLocationController.dispose();
    dropLocationController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[700]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[700]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  Future<void> _bookAmbulance() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate == null) {
      _showSnackBar("Please select a date", Colors.orange);
      return;
    }

    if (selectedTime == null) {
      _showSnackBar("Please select a time", Colors.orange);
      return;
    }

    setState(() => isLoading = true);

    try {
      final bookingDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      List<String> requirements = [];
      if (needsOxygenSupport) requirements.add('Oxygen Support');
      if (needsStretcher) requirements.add('Stretcher');
      if (needsParamedic) requirements.add('Paramedic');

      final response = await Dio().post(
        'YOUR_BASE_URL/ambulancebooking/USER_ID/${widget.ambulanceId}',
        data: {
          "Date": selectedDate!.toIso8601String().split("T")[0],
          "Time": selectedTime!.format(context),
          "BookingDateTime": bookingDateTime.toIso8601String(),
          "PatientName": nameController.text,
          "ContactNumber": phoneController.text,
          "PickupLocation": pickupLocationController.text,
          "DropLocation": dropLocationController.text,
          "Urgency": selectedUrgency,
          "Requirements": requirements.join(', '),
          "Remarks": remarksController.text,
          "Status": "Pending",
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        _showSuccessDialog();
      } else {
        _showSnackBar("Booking failed. Please try again.", Colors.red);
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
      _showSnackBar("Booking error: ${e.toString()}", Colors.red);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
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
            const Text("Booking Confirmed!"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your ambulance has been booked successfully."),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.ambulanceName != null)
                    _buildInfoRow(Icons.local_hospital, widget.ambulanceName!),
                  _buildInfoRow(Icons.calendar_today,
                      DateFormat('MMM dd, yyyy').format(selectedDate!)),
                  _buildInfoRow(Icons.access_time, selectedTime!.format(context)),
                  _buildInfoRow(Icons.location_on, pickupLocationController.text),
                  _buildInfoRow(Icons.priority_high, "Urgency: $selectedUrgency"),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "The ambulance will arrive at your location shortly. Please keep your phone accessible.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Book Ambulance",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[700]!, Colors.blue[500]!],
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
                      Icons.emergency,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.ambulanceName ?? "Ambulance Booking",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.vehicleNumber != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.vehicleNumber!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Form Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient Information
                    _buildSectionTitle("Patient Information"),
                    const SizedBox(height: 8),

                    TextFormField(
                      controller: nameController,
                      decoration: _buildInputDecoration(
                        labelText: "Patient Name *",
                        hintText: "Enter patient's full name",
                        prefixIcon: Icons.person,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Patient name is required';
                        }
                        if (value.trim().length < 3) {
                          return 'Please enter full name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _buildInputDecoration(
                        labelText: "Contact Number *",
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

                    // Date & Time Selection
                    _buildSectionTitle("Schedule Booking"),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _pickDate,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedDate != null
                                      ? Colors.blue[700]!
                                      : Colors.grey[300]!,
                                  width: selectedDate != null ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today,
                                          size: 18, color: Colors.blue[700]),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Date *",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    selectedDate == null
                                        ? "Select date"
                                        : DateFormat('MMM dd, yyyy')
                                            .format(selectedDate!),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: selectedDate != null
                                          ? Colors.black
                                          : Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: _pickTime,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedTime != null
                                      ? Colors.blue[700]!
                                      : Colors.grey[300]!,
                                  width: selectedTime != null ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.access_time,
                                          size: 18, color: Colors.blue[700]),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Time *",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    selectedTime == null
                                        ? "Select time"
                                        : selectedTime!.format(context),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: selectedTime != null
                                          ? Colors.black
                                          : Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Location Details
                    _buildSectionTitle("Location Details"),
                    const SizedBox(height: 8),

                    TextFormField(
                      controller: pickupLocationController,
                      decoration: _buildInputDecoration(
                        labelText: "Pickup Location *",
                        hintText: "Enter pickup address",
                        prefixIcon: Icons.location_on,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Pickup location is required';
                        }
                        if (value.trim().length < 5) {
                          return 'Please provide detailed address';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: dropLocationController,
                      decoration: _buildInputDecoration(
                        labelText: "Drop Location *",
                        hintText: "Enter destination address",
                        prefixIcon: Icons.flag,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Drop location is required';
                        }
                        if (value.trim().length < 5) {
                          return 'Please provide detailed address';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Urgency Level
                    _buildSectionTitle("Urgency Level"),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          _buildUrgencyOption('Normal', 'Scheduled appointment'),
                          Divider(height: 1, color: Colors.grey[300]),
                          _buildUrgencyOption('Urgent', 'Need soon'),
                          Divider(height: 1, color: Colors.grey[300]),
                          _buildUrgencyOption('Emergency', 'Critical situation'),
                          Divider(height: 1, color: Colors.grey[300]),
                          _buildUrgencyOption('Critical', 'Life-threatening'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Special Requirements
                    _buildSectionTitle("Special Requirements"),
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
                            'Oxygen Support',
                            needsOxygenSupport,
                            Icons.air,
                            (value) => setState(() => needsOxygenSupport = value!),
                          ),
                          _buildCheckboxTile(
                            'Stretcher',
                            needsStretcher,
                            Icons.bed,
                            (value) => setState(() => needsStretcher = value!),
                          ),
                          _buildCheckboxTile(
                            'Paramedic',
                            needsParamedic,
                            Icons.medical_services,
                            (value) => setState(() => needsParamedic = value!),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Additional Remarks
                    _buildSectionTitle("Additional Remarks"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: remarksController,
                      maxLines: 3,
                      maxLength: 200,
                      decoration: _buildInputDecoration(
                        labelText: "Special instructions (optional)",
                        hintText: "Any special medical conditions or requirements",
                        prefixIcon: Icons.note,
                        alignLabelWithHint: true,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Info Box
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
                              "Please ensure all details are accurate. You will receive a confirmation call shortly.",
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Book Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _bookAmbulance,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[400],
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Booking...",
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle, size: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    "CONFIRM BOOKING",
                                    style: TextStyle(
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
      prefixIcon: Icon(prefixIcon, color: Colors.blue[700]),
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
        borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
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

  Widget _buildUrgencyOption(String level, String description) {
    final isSelected = selectedUrgency == level;
    Color getColor() {
      switch (level) {
        case 'Normal':
          return Colors.green;
        case 'Urgent':
          return Colors.orange;
        case 'Emergency':
          return Colors.deepOrange;
        case 'Critical':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return InkWell(
      onTap: () => setState(() => selectedUrgency = level),
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
    Function(bool?) onChanged,
  ) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue[700]),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      activeColor: Colors.blue[700],
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
}