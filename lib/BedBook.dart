// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/reg_api.dart';

// class BedBookPage extends StatefulWidget {
//   final int bedId;

//   const BedBookPage({super.key, required this.bedId});

//   @override
//   State<BedBookPage> createState() => _BedBookPageState();
// }

// class _BedBookPageState extends State<BedBookPage> {
//   DateTime? selectedDate;
//   bool isSubmitting = false;

//   // int lid = 2; // <-- replace with logged-in user's login ID

//   Future<void> pickDate() async {
//     DateTime? date = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2035),
//     );

//     if (date != null) {
//       setState(() => selectedDate = date);
//     }
//   }

//   Future<void> bookBed() async {
//     if (selectedDate == null) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Please select a date")));
//       return;
//     }

//     setState(() => isSubmitting = true);

//     try {
//       final formattedDate = selectedDate!.toIso8601String().split("T")[0];

//       final response = await Dio().post(
//         "$baseurl/bedbooking/$lid",
//         data: {
//           "BED": widget.bedId,
//           "date": formattedDate,
//         },
//       );

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Bed Booked Successfully")),
//         );
//         Navigator.pop(context); // go back
//       }
//     } catch (e) {
//       print("Error booking bed: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Booking Failed")),
//       );
//     }

//     setState(() => isSubmitting = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Book Bed"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // Date Picker
//             ListTile(
//               leading: const Icon(Icons.calendar_month, color: Colors.redAccent),
//               title: Text(
//                 selectedDate == null
//                     ? "Select Date"
//                     : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
//               ),
//               onTap: pickDate,
//             ),

//             const SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: isSubmitting ? null : bookBed,
//               child: isSubmitting
//                   ? CircularProgressIndicator(color: Colors.white)
//                   : const Text("BOOK BED"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

class BedBookPage extends StatefulWidget {
  final int bedId;
  final String bedName;
  final String wardName;
  final int lid; // Pass logged-in user ID from previous screen

  const BedBookPage({
    super.key,
    required this.bedId,
    required this.bedName,
    required this.wardName,
    required this.lid,
  });

  @override
  State<BedBookPage> createState() => _BedBookPageState();
}

class _BedBookPageState extends State<BedBookPage> {
  DateTime? selectedDate;
  bool isSubmitting = false;
  bool isLoading = false;
  String? errorMessage;
  final String baseUrl = "https://your-api-url.com"; // Replace with your actual base URL
  final dio = Dio();

  // Validation messages
  String? validateDate(DateTime? date) {
    if (date == null) {
      return 'Please select a booking date';
    }
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);
    
    if (selected.isBefore(today)) {
      return 'Cannot select past dates';
    }
    
    // Optional: Check if date is too far in the future
    final maxDate = DateTime(now.year + 1, now.month, now.day);
    if (selected.isAfter(maxDate)) {
      return 'Booking cannot be made more than 1 year in advance';
    }
    
    return null;
  }

  Future<void> pickDate() async {
    // Dismiss keyboard if open
    FocusScope.of(context).unfocus();
    
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent,
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
        selectedDate = date;
        errorMessage = validateDate(date);
      });
    }
  }

  Future<void> checkBedAvailability() async {
    if (selectedDate == null) {
      setState(() {
        errorMessage = 'Please select a date';
      });
      return;
    }

    final validationError = validateDate(selectedDate);
    if (validationError != null) {
      setState(() {
        errorMessage = validationError;
      });
      return;
    }

    setState(() {
      isSubmitting = true;
      errorMessage = null;
    });

    try {
      // First check availability
      setState(() => isLoading = true);
      
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
      
      // Example API call to check availability
      final availabilityResponse = await dio.get(
        '$baseUrl/bed-availability/${widget.bedId}',
        queryParameters: {'date': formattedDate},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (availabilityResponse.statusCode == 200) {
        final isAvailable = availabilityResponse.data['available'] ?? true;
        
        if (!isAvailable) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bed is not available on selected date'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        // Proceed with booking
        await performBooking(formattedDate);
      }
    } on DioException catch (e) {
      _handleApiError(e);
    } catch (e) {
      _showErrorDialog('An unexpected error occurred: $e');
    } finally {
      setState(() {
        isSubmitting = false;
        isLoading = false;
      });
    }
  }

  Future<void> performBooking(String formattedDate) async {
    try {
      final response = await dio.post(
        '$baseUrl/bedbooking/${widget.lid}',
        data: {
          "BED": widget.bedId,
          "date": formattedDate,
          "ward_name": widget.wardName,
          "bed_name": widget.bedName,
          "booking_time": DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await _showSuccessDialog();
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleApiError(e);
    }
  }

  void _handleApiError(DioException e) {
    String errorMessage = 'Booking Failed';
    
    if (e.response != null) {
      if (e.response!.statusCode == 400) {
        errorMessage = 'Invalid request. Please check your input.';
      } else if (e.response!.statusCode == 409) {
        errorMessage = 'This bed is already booked for the selected date.';
      } else if (e.response!.statusCode == 401) {
        errorMessage = 'Session expired. Please login again.';
        // You might want to navigate to login page here
      } else if (e.response!.statusCode == 500) {
        errorMessage = 'Server error. Please try again later.';
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      errorMessage = 'Connection timeout. Check your internet connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      errorMessage = 'No internet connection.';
    }
    
    _showErrorDialog(errorMessage);
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Booking Confirmed'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bed has been successfully booked!', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            Text('Details:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text('• Bed: ${widget.bedName}'),
            Text('• Ward: ${widget.wardName}'),
            Text('• Date: ${DateFormat('dd MMM, yyyy').format(selectedDate!)}'),
            Text('• Booking ID: ${DateTime.now().millisecondsSinceEpoch}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Return to previous screen with success flag
            },
            child: Text('OK', style: TextStyle(color: Colors.blueAccent)),
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
            child: Text('OK', style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Hospital Bed"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (isSubmitting) return;
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bed Information Card
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
                            'Bed Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.bed, color: Colors.blueAccent, size: 24),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.bedName,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Ward: ${widget.wardName}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                            'Select Booking Date',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 15),
                          GestureDetector(
                            onTap: pickDate,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: errorMessage != null && selectedDate == null
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
                                        color: Colors.blueAccent,
                                        size: 24,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        selectedDate == null
                                            ? "Tap to select date"
                                            : DateFormat('dd MMMM, yyyy').format(selectedDate!),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: selectedDate == null
                                              ? Colors.grey[500]
                                              : Colors.black,
                                          fontWeight: selectedDate == null
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
                          
                          if (errorMessage != null && selectedDate == null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                              child: Text(
                                errorMessage!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          
                          if (selectedDate != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                              child: Text(
                                'Selected: ${DateFormat('EEEE').format(selectedDate!)}',
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

                  SizedBox(height: 40),

                  // Important Information
                  Card(
                    color: Colors.blue[50],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.blue[100]!),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue[800], size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Important Information',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            '• Bookings can be made up to 1 year in advance\n'
                            '• You will receive a confirmation email\n'
                            '• Cancellation is possible up to 24 hours before booking\n'
                            '• Please arrive at least 30 minutes before',
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

                  // Book Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : checkBedAvailability,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isSubmitting
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
                                Icon(Icons.book_online, size: 24),
                                SizedBox(width: 10),
                                Text(
                                  'CONFIRM BOOKING',
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
                      onPressed: isSubmitting
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

          // Loading Overlay
          if (isLoading)
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Checking availability...',
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