// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/reg_api.dart';

// class DoctorBookingPage extends StatefulWidget {
//   final int doctorId;
//   final String doctorName;
//   final String specialization;

//   const DoctorBookingPage({
//     super.key,
//     required this.doctorId,
//     required this.doctorName,
//     required this.specialization,
//   });

//   @override
//   State<DoctorBookingPage> createState() => _DoctorBookingPageState();
// }

// class _DoctorBookingPageState extends State<DoctorBookingPage> {
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;
//   bool isSubmitting = false;

//   Future<void> pickDate() async {
//     DateTime? date = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2030),
//     );

//     if (date != null) {
//       setState(() => selectedDate = date);
//     }
//   }

//   Future<void> pickTime() async {
//     TimeOfDay? time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (time != null) {
//       setState(() => selectedTime = time);
//     }
//   }

//   Future<void> bookAppointment() async {
//     if (selectedDate == null || selectedTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select date and time")),
//       );
//       return;
//     }

//     setState(() => isSubmitting = true);

//     try {
//       final response = await Dio().post(
//         "$baseurl/Doctor_book/$lid",
//         data: {
//           "DOCID": widget.doctorId,
//           "Date": selectedDate.toString().split(" ")[0],
//           // "Time": selectedTime!.format(context),
//         },
//       );

//       if (response.statusCode == 200 || response.statusCode ==201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Appointment Booked Successfully!")),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       debugPrint("Booking error: $e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Booking failed")));
//     }

//     setState(() => isSubmitting = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Book Appointment"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Doctor Header
//             Text(
//               widget.doctorName,
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               widget.specialization,
//               style: const TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             const SizedBox(height: 20),

//             // Date Picker
//             ListTile(
//               leading: const Icon(
//                 Icons.calendar_month,
//                 color: Colors.redAccent,
//               ),
//               title: Text(
//                 selectedDate == null
//                     ? "Select Date"
//                     : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
//               ),
//               onTap: pickDate,
//             ),

//             //  Time Picker
//             ListTile(
//               leading: const Icon(Icons.access_time, color: Colors.redAccent),
//               title: Text(
//                 selectedTime == null
//                     ? "Select Time"
//                     : selectedTime!.format(context),
//               ),
//               onTap: pickTime,
//             ),

//             const SizedBox(height: 30),

//             // Submit Button
//             Center(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.redAccent,
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 12,
//                     horizontal: 30,
//                   ),
//                 ),
//                 onPressed: isSubmitting ? null : bookAppointment,
//                 child: isSubmitting
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text(
//                         "Book Appointment",
//                         style: TextStyle(color: Colors.white, fontSize: 18),
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class DoctorBookingPage extends StatefulWidget {
  final int doctorId;
  final String doctorName;
  final String specialization;
  final String? doctorImage;
  final String? hospitalName;
  final double? consultationFee;

  const DoctorBookingPage({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    this.doctorImage,
    this.hospitalName,
    this.consultationFee,
  });

  @override
  State<DoctorBookingPage> createState() => _DoctorBookingPageState();
}

class _DoctorBookingPageState extends State<DoctorBookingPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isSubmitting = false;
  bool _isLoading = false;
  String? _errorMessage;
  String? _dateError;
  String? _timeError;
  String? _additionalNotes;
  final TextEditingController _notesController = TextEditingController();
  final FocusNode _notesFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  List<String> _availableTimeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
  ];
  bool _isCustomTime = false;

  @override
  void initState() {
    super.initState();
    _loadDoctorAvailability();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _notesFocusNode.dispose();
    super.dispose();
  }

  /// --------------------------- VALIDATIONS ---------------------------
  String? _validateDate(DateTime? date) {
    if (date == null) return 'Please select an appointment date';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);
    
    if (selected.isBefore(today)) {
      return 'Cannot select past dates';
    }
    
    // Check if it's too far in the future
    final maxDate = DateTime.now().add(const Duration(days: 90));
    if (selected.isAfter(maxDate)) {
      return 'Bookings only available for next 3 months';
    }
    
    // Check if it's a weekend (optional)
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return 'Doctor may not be available on weekends';
    }
    
    return null;
  }

  String? _validateTime(TimeOfDay? time, DateTime? date) {
    if (time == null) return 'Please select appointment time';
    
    if (date != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      
      // For today's date, check if time is in past
      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        if (selectedDateTime.isBefore(now)) {
          return 'Cannot select past time for today';
        }
      }
      
      // Check if within working hours (e.g., 9 AM to 5 PM)
      if (time.hour < 9 || time.hour > 17) {
        return 'Doctor available between 9:00 AM to 5:00 PM';
      }
      
      // Check if it's lunch time (optional)
      if (time.hour == 13) { // 1 PM
        return 'Doctor may be on lunch break (1:00 PM - 2:00 PM)';
      }
    }
    
    return null;
  }

  String? _validateNotes(String? value) {
    if (value != null && value.trim().length > 500) {
      return 'Notes cannot exceed 500 characters';
    }
    return null;
  }

  /// --------------------------- LOAD AVAILABILITY ---------------------------
  Future<void> _loadDoctorAvailability() async {
    setState(() => _isLoading = true);
    
    try {
      // Mock API call to get doctor's availability
      // In real app, you would call your API
      await Future.delayed(const Duration(milliseconds: 500));
      
      // You can implement actual API call here:
      // final response = await dio.get('$baseurl/doctor-availability/${widget.doctorId}');
      // Process response and update _availableTimeSlots
      
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load availability';
      });
    }
  }

  Future<void> _pickDate() async {
    // Dismiss keyboard if open
    FocusScope.of(context).unfocus();
    
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      selectableDayPredicate: (DateTime date) {
        // Disable weekends
        if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
          return false;
        }
        return true;
      },
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.redAccent,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _dateError = _validateDate(date);
        // Reset time when date changes
        _selectedTime = null;
        _timeError = null;
      });
    }
  }

  Future<void> _pickTime() async {
    FocusScope.of(context).unfocus();
    
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a date first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show custom time slots or time picker
    if (!_isCustomTime) {
      _showTimeSlotDialog();
    } else {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.redAccent,
                onPrimary: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        _setSelectedTime(time);
      }
    }
  }

  void _showTimeSlotDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.schedule, color: Colors.redAccent),
              SizedBox(width: 10),
              Text('Select Time Slot'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Available Time Slots',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableTimeSlots.map((slot) {
                    return ChoiceChip(
                      label: Text(slot),
                      selected: _selectedTime != null &&
                          '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')} ${_selectedTime!.period == DayPeriod.am ? 'AM' : 'PM'}' == slot,
                      onSelected: (selected) {
                        final timeParts = slot.split(' ');
                        final hourMinute = timeParts[0].split(':');
                        final period = timeParts[1];
                        
                        final hour = int.parse(hourMinute[0]);
                        final minute = int.parse(hourMinute[1]);
                        final isPM = period == 'PM';
                        
                        final time = TimeOfDay(
                          hour: isPM && hour != 12 ? hour + 12 : hour == 12 && isPM ? 12 : hour,
                          minute: minute,
                        );
                        
                        _setSelectedTime(time);
                        Navigator.pop(context);
                      },
                      selectedColor: Colors.redAccent.withOpacity(0.2),
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                        color: _selectedTime != null &&
                            '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')} ${_selectedTime!.period == DayPeriod.am ? 'AM' : 'PM'}' == slot
                            ? Colors.redAccent
                            : Colors.grey[700],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _isCustomTime = true;
                    _pickTime();
                  },
                  icon: Icon(Icons.more_time),
                  label: Text('Custom Time'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _setSelectedTime(TimeOfDay time) {
    setState(() {
      _selectedTime = time;
      _timeError = _validateTime(time, _selectedDate);
    });
  }

  Future<void> _checkAppointmentConflict() async {
    if (_selectedDate == null || _selectedTime == null) return;
    
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      final formattedTime = _selectedTime!.format(context);
      
      // Check if doctor has existing appointment at same time
      // This would be your actual API call
      /*
      final response = await dio.get(
        '$baseurl/doctor-appointment-check/${widget.doctorId}',
        queryParameters: {
          'date': formattedDate,
          'time': formattedTime,
        },
      );
      
      if (response.data['available'] == false) {
        throw Exception('Time slot not available');
      }
      */
      
      // Mock implementation
      await Future.delayed(const Duration(seconds: 1));
      final isAvailable = true; // Mock response
      
      if (!isAvailable) {
        throw Exception('This time slot is already booked');
      }
    } catch (e) {
      throw Exception('Failed to check availability: ${e.toString()}');
    }
  }

  Future<void> _bookAppointment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate date and time
    final dateError = _validateDate(_selectedDate);
    final timeError = _validateTime(_selectedTime, _selectedDate);
    
    if (dateError != null || timeError != null) {
      setState(() {
        _dateError = dateError;
        _timeError = timeError;
      });
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      // Check for appointment conflict
      await _checkAppointmentConflict();

      // Proceed with booking
      await _performBooking();
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _performBooking() async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      final formattedTime = _selectedTime!.format(context);
      
      final response = await dio.post(
        "$baseurl/Doctor_book/$lid",
        data: {
          "DOCID": widget.doctorId,
          "Date": formattedDate,
          "Time": formattedTime,
          "DoctorName": widget.doctorName,
          "Specialization": widget.specialization,
          "HospitalName": widget.hospitalName,
          "ConsultationFee": widget.consultationFee,
          "AdditionalNotes": _additionalNotes?.trim(),
          "BookingTimestamp": DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await _showSuccessDialog();
      } else if (response.statusCode == 409) {
        throw Exception('This time slot is already booked. Please choose another time.');
      } else {
        throw Exception('Booking failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleApiError(e);
    }
  }

  void _handleApiError(DioException e) {
    String errorMessage = 'Booking Failed';
    
    if (e.response != null) {
      switch (e.response!.statusCode) {
        case 400:
          errorMessage = 'Invalid booking request';
          break;
        case 401:
          errorMessage = 'Session expired. Please login again.';
          break;
        case 403:
          errorMessage = 'You do not have permission to book this appointment.';
          break;
        case 409:
          errorMessage = 'Time slot is already booked. Please choose another time.';
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
    
    _showErrorDialog(errorMessage);
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 10),
              Text('Appointment Confirmed!'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your appointment has been successfully booked.', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 15),
                Text('Appointment Details:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                _buildDetailRow('Doctor', widget.doctorName),
                _buildDetailRow('Specialization', widget.specialization),
                if (widget.hospitalName != null)
                  _buildDetailRow('Hospital', widget.hospitalName!),
                _buildDetailRow('Date', DateFormat('dd MMM yyyy').format(_selectedDate!)),
                _buildDetailRow('Time', _selectedTime!.format(context)),
                if (widget.consultationFee != null)
                  _buildDetailRow('Consultation Fee', '₹${widget.consultationFee!.toStringAsFixed(2)}'),
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
                          'You will receive a confirmation email shortly.',
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
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context, true); // Return to previous screen
              },
              child: Text('OK', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
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
            Text('Booking Failed'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.redAccent)),
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
          "Book Appointment",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (!_isSubmitting) Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor Information Card
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Doctor Avatar
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: widget.doctorImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        widget.doctorImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.redAccent,
                                    ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.doctorName,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    widget.specialization,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  if (widget.hospitalName != null) ...[
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.local_hospital, size: 16, color: Colors.grey),
                                        SizedBox(width: 4),
                                        Text(
                                          widget.hospitalName!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  if (widget.consultationFee != null) ...[
                                    SizedBox(height: 8),
                                    Text(
                                      'Consultation Fee: ₹${widget.consultationFee!.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green[700],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Date Selection Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Appointment Date',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 15),
                            GestureDetector(
                              onTap: _pickDate,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _dateError != null
                                        ? Colors.red
                                        : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[50],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          color: Colors.redAccent,
                                          size: 24,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          _selectedDate == null
                                              ? "Tap to select date"
                                              : DateFormat('dd MMMM yyyy').format(_selectedDate!),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: _selectedDate == null
                                                ? Colors.grey[500]
                                                : Colors.black,
                                            fontWeight: _selectedDate == null
                                                ? FontWeight.normal
                                                : FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey[500],
                                      size: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (_dateError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                child: Text(
                                  _dateError!,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            if (_selectedDate != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                child: Text(
                                  'Selected: ${DateFormat('EEEE').format(_selectedDate!)}',
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Time Selection Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Appointment Time',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 15),
                            GestureDetector(
                              onTap: _pickTime,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _timeError != null
                                        ? Colors.red
                                        : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[50],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          color: Colors.redAccent,
                                          size: 24,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          _selectedTime == null
                                              ? "Tap to select time"
                                              : _selectedTime!.format(context),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: _selectedTime == null
                                                ? Colors.grey[500]
                                                : Colors.black,
                                            fontWeight: _selectedTime == null
                                                ? FontWeight.normal
                                                : FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey[500],
                                      size: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (_timeError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                child: Text(
                                  _timeError!,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            if (!_isCustomTime && _selectedTime == null)
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Text(
                                  'Available time slots: ${_availableTimeSlots.join(', ')}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Additional Notes (Optional)
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Additional Notes (Optional)',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Add any symptoms or concerns you want to discuss:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _notesController,
                              focusNode: _notesFocusNode,
                              maxLines: 4,
                              maxLength: 500,
                              decoration: InputDecoration(
                                hintText: 'Type your notes here...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.redAccent, width: 2),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() => _additionalNotes = value);
                              },
                              validator: _validateNotes,
                            ),
                            SizedBox(height: 5),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${_notesController.text.length}/500',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Important Information
                    Card(
                      color: Colors.red[50],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.red[100]!),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.red[800], size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Important Information',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[800],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              '• Bookings available for next 3 months only\n'
                              '• Doctor available Monday to Friday, 9 AM - 5 PM\n'
                              '• Please arrive 15 minutes before appointment\n'
                              '• Cancellation possible up to 24 hours before\n'
                              '• Bring your medical records if any',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 40),

                    // Book Appointment Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _bookAppointment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isSubmitting
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
                                  SizedBox(width: 10),
                                  Text('Processing...'),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.medical_services, size: 24),
                                  SizedBox(width: 10),
                                  Text(
                                    'CONFIRM APPOINTMENT',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
                  ],
                ),
              ),
            ),
          ),

          // Loading Overlay for availability check
          if (_isLoading)
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
                        'Checking doctor availability...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
}