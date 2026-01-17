// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/reg_api.dart';

// class VolunteerFeedbackPage extends StatefulWidget {
//   const VolunteerFeedbackPage({super.key});

//   @override
//   State<VolunteerFeedbackPage> createState() => _VolunteerFeedbackPageState();
// }

// class _VolunteerFeedbackPageState extends State<VolunteerFeedbackPage> {
//   double _rating = 0;
    
//     Future<void> submitReview() async {
//     if (feedbackController.text.trim().isEmpty || _rating == 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all fields")),
//       );
//       return;
//     }

//     try {
//       final response = await Dio().post(
//         "$baseurl/volunteer_feedback/$lid",
//         data: {
//           "Feedback": feedbackController.text.trim(),
//           "Rating": _rating,
//         },
//       );

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Review submitted successfully!")),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       print("Error Review: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to submit review")),
//       );
//     }
//   }
//   final TextEditingController feedbackController = TextEditingController();

//   // List<Map<String, dynamic>> previousFeedback = [
//   //   {
//   //     "name": "Hospital Staff",
//   //     "feedback": "Great support during the emergency case yesterday!",
//   //     "rating": 4.5,
//   //   },
//   //   {
//   //     "name": "Ambulance Team",
//   //     "feedback": "Prompt response and well coordinated.",
//   //     "rating": 5.0,
//   //   },
//   //   {
//   //     "name": "Public User",
//   //     "feedback": "Very helpful and polite.",
//   //     "rating": 4.0,
//   //   },
//   // ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Feedback & Ratings"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Give Your Feedback",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),

//             // Rating Bar

//             RatingBar.builder(
//               initialRating: _rating,
//               minRating: 1,
//               direction: Axis.horizontal,
//               allowHalfRating: true,
//               itemCount: 5,
//               itemSize: 40,
//               itemPadding: EdgeInsetsGeometry.symmetric(horizontal: 2),
//               itemBuilder: (context, index) => Icon(Icons.star,color: Colors.amber,), onRatingUpdate: (rating){
//               setState(() {
//                 _rating=rating;
//               });
//             }),
//             // Row(
//             //   children: List.generate(5, (index) {
//             //     return IconButton(
//             //       onPressed: () {
//             //         setState(() {
//             //           rating = index + 1.0;
//             //         });
//             //       },
//             //       icon: Icon(
//             //         Icons.star,
//             //         size: 30,
//             //         color: index < rating ? Colors.redAccent : Colors.grey,
//             //       ),
//             //     );
//             //   }),
//             // ),

//              SizedBox(height: 10),

//             // Feedback input
//             TextField(
//               controller: feedbackController,
//               maxLines: 4,
//               decoration: InputDecoration(
//                 hintText: "Write your feedback here...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 15),

//             // Submit Button
//             Center(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.redAccent,
//                   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                 ),
//                 onPressed: () {
//                   if (_rating == 0 || feedbackController.text.isEmpty) return;
//                   setState(() {
//                     submitReview();
//                     feedbackController.clear();
//                     _rating = 0;
//                   });
//                 },
//                 child: const Text("Submit", style: TextStyle(fontSize: 16)),
//               ),
//             ),

//             const SizedBox(height: 25),
//             // const Divider(),
           
//           ],
//         ),
//       ),
//     );
//   }
// }





import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class VolunteerFeedbackPage extends StatefulWidget {
  final String? volunteerName;
  final int? volunteerId;

  const VolunteerFeedbackPage({
    super.key,
    this.volunteerName,
    this.volunteerId,
  });

  @override
  State<VolunteerFeedbackPage> createState() => _VolunteerFeedbackPageState();
}

class _VolunteerFeedbackPageState extends State<VolunteerFeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController feedbackController = TextEditingController();
  
  double _rating = 0;
  bool isSubmitting = false;
  String selectedCategory = 'General';
  bool isAnonymous = false;

  final List<String> feedbackCategories = [
    'General',
    'Response Time',
    'Professionalism',
    'Communication',
    'Medical Knowledge',
    'Attitude',
  ];

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  Future<void> submitReview() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_rating == 0) {
      _showSnackBar("Please provide a rating", Colors.orange);
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final response = await Dio().post(
        'YOUR_BASE_URL/volunteer_feedback/USER_ID',
        data: {
          "Feedback": feedbackController.text.trim(),
          "Rating": _rating,
          "Category": selectedCategory,
          "IsAnonymous": isAnonymous,
          "VolunteerId": widget.volunteerId,
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
      } else {
        _showSnackBar("Failed to submit feedback. Please try again.", Colors.red);
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
      _showSnackBar("Error: ${e.toString()}", Colors.red);
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
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
            const Text("Feedback Submitted!"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Thank you for your valuable feedback!"),
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
                  Row(
                    children: [
                      Icon(Icons.star, size: 20, color: Colors.amber[700]),
                      const SizedBox(width: 8),
                      Text(
                        "${_rating.toStringAsFixed(1)} Stars",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Category: $selectedCategory",
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Your feedback helps us improve our volunteer services.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
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

  void _clearForm() {
    feedbackController.clear();
    setState(() {
      _rating = 0;
      selectedCategory = 'General';
      isAnonymous = false;
    });
  }

  String _getRatingLabel(double rating) {
    if (rating == 0) return 'No rating';
    if (rating <= 1) return 'Poor';
    if (rating <= 2) return 'Fair';
    if (rating <= 3) return 'Good';
    if (rating <= 4) return 'Very Good';
    return 'Excellent';
  }

  Color _getRatingColor(double rating) {
    if (rating <= 2) return Colors.red;
    if (rating <= 3) return Colors.orange;
    if (rating <= 4) return Colors.amber;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Volunteer Feedback",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green[700],
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
                  colors: [Colors.green[700]!, Colors.green[500]!],
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
                      Icons.volunteer_activism,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.volunteerName ?? "Rate Your Experience",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Your feedback helps improve our volunteer services",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
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
                    // Rating Section
                    _buildSectionTitle("Your Rating *"),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _rating > 0 
                              ? _getRatingColor(_rating)
                              : Colors.grey[300]!,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          RatingBar.builder(
                            initialRating: _rating,
                            minRating: 0.5,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 45,
                            glow: true,
                            glowColor: Colors.amber.withOpacity(0.3),
                            itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                            itemBuilder: (context, index) => const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() => _rating = rating);
                            },
                          ),
                          const SizedBox(height: 12),
                          if (_rating > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: _getRatingColor(_rating).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${_rating.toStringAsFixed(1)} - ${_getRatingLabel(_rating)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _getRatingColor(_rating),
                                ),
                              ),
                            )
                          else
                            Text(
                              "Tap stars to rate",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Category Selection
                    _buildSectionTitle("Feedback Category"),
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
                          value: selectedCategory,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.green[700]),
                          items: feedbackCategories.map((String category) {
                            IconData icon;
                            switch (category) {
                              case 'Response Time':
                                icon = Icons.timer;
                                break;
                              case 'Professionalism':
                                icon = Icons.business_center;
                                break;
                              case 'Communication':
                                icon = Icons.chat;
                                break;
                              case 'Medical Knowledge':
                                icon = Icons.medical_services;
                                break;
                              case 'Attitude':
                                icon = Icons.mood;
                                break;
                              default:
                                icon = Icons.feedback;
                            }
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Row(
                                children: [
                                  Icon(icon, size: 20, color: Colors.green[700]),
                                  const SizedBox(width: 12),
                                  Text(category),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() => selectedCategory = newValue!);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Feedback Text
                    _buildSectionTitle("Your Feedback *"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: feedbackController,
                      maxLines: 6,
                      maxLength: 500,
                      decoration: InputDecoration(
                        hintText: "Share your experience with the volunteer...\n\nWhat did they do well?\nWhat could be improved?",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: Icon(Icons.message, color: Colors.green[700]),
                        ),
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
                          borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red, width: 1),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please provide your feedback';
                        }
                        if (value.trim().length < 10) {
                          return 'Feedback should be at least 10 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Anonymous Option
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: CheckboxListTile(
                        value: isAnonymous,
                        onChanged: (value) {
                          setState(() => isAnonymous = value!);
                        },
                        title: const Row(
                          children: [
                            Icon(Icons.visibility_off, size: 20),
                            SizedBox(width: 8),
                            Text("Submit Anonymously"),
                          ],
                        ),
                        subtitle: Text(
                          "Your name will not be shared with the volunteer",
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        activeColor: Colors.green[700],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
                              "Your honest feedback helps us maintain quality volunteer services and improve community support.",
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

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isSubmitting ? null : submitReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
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
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Submitting...",
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    "SUBMIT FEEDBACK",
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

                    const SizedBox(height: 16),

                    // Clear Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: _clearForm,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green[700],
                          side: BorderSide(color: Colors.green[700]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Clear Form"),
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
}