// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/reg_api.dart'; // for baseurl, lid

// class ReviewPage extends StatefulWidget {
//   final String hospitalId;
//   final String hospitalName;

//   const ReviewPage({
//     super.key,
//     required this.hospitalId,
//     required this.hospitalName,
//   });

//   @override
//   State<ReviewPage> createState() => _ReviewPageState();
// }

// class _ReviewPageState extends State<ReviewPage> {
//   final TextEditingController reviewController = TextEditingController();
//   double rating = 0;

//   Future<void> submitReview() async {
//     if (reviewController.text.trim().isEmpty || rating == 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all fields")),
//       );
//       return;
//     }

//     try {
//       final response = await Dio().post(
//         "$baseurl/add_review/$lid",
//         data: {
//           "HOSPITAL": widget.hospitalId,
//           "Review": reviewController.text.trim(),
//           "Rating": rating,
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Review - ${widget.hospitalName}"),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("Rating", style: TextStyle(fontSize: 18)),

//             const SizedBox(height: 10),

//             Row(
//               children: List.generate(5, (index) {
//                 return IconButton(
//                   icon: Icon(
//                     index < rating ? Icons.star : Icons.star_border,
//                     color: Colors.orange,
//                     size: 32,
//                   ),
//                   onPressed: () {
//                     setState(() => rating = index + 1.0);
//                   },
//                 );
//               }),
//             ),

//             const SizedBox(height: 20),
//             const Text("Write Review", style: TextStyle(fontSize: 18)),
//             const SizedBox(height: 10),

//             TextField(
//               controller: reviewController,
//               maxLines: 4,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 hintText: "Describe your experience...",
//               ),
//             ),

//             const SizedBox(height: 20),

//             Center(
//               child: ElevatedButton(
//                 onPressed: submitReview,
//                 child: const Text("Submit Review"),
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
import 'package:intl/intl.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class ReviewPage extends StatefulWidget {
  final String hospitalId;
  final String hospitalName;
  final String? hospitalImage;
  final String? hospitalLocation;

  const ReviewPage({
    super.key,
    required this.hospitalId,
    required this.hospitalName,
    this.hospitalImage,
    this.hospitalLocation,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _reviewFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  
  double _rating = 0.0;
  bool _isSubmitting = false;
  bool _hasError = false;
  String _errorMessage = '';
  List<String> _reviewTags = [];
  List<Review> _existingReviews = [];
  bool _isLoadingReviews = true;
  final Dio _dio = Dio();

  final List<String> _availableTags = [
    'Cleanliness',
    'Staff Friendly',
    'Doctor Quality',
    'Waiting Time',
    'Facilities',
    'Value for Money',
    'Emergency Care',
    'Bed Comfort',
    'Food Quality',
    'Parking'
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingReviews();
    _reviewFocusNode.addListener(() {
      if (_reviewFocusNode.hasFocus) {
        // Optional: Scroll to review field
      }
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _titleController.dispose();
    _reviewFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadExistingReviews() async {
    setState(() => _isLoadingReviews = true);
    
    try {
      final response = await _dio.get(
        '$baseurl/reviews/${widget.hospitalId}',
        options: Options(
          headers: {'Accept': 'application/json'},
        ),
      );

      if (response.statusCode == 200 && response.data is List) {
        setState(() {
          _existingReviews = (response.data as List).map((review) {
            return Review(
              userName: review['user_name'] ?? 'Anonymous',
              rating: review['rating']?.toDouble() ?? 0.0,
              title: review['title'] ?? '',
              reviewText: review['Review'] ?? '',
              date: review['date'] != null 
                ? DateFormat('yyyy-MM-dd').parse(review['date'])
                : DateTime.now(),
              tags: (review['tags'] as List<String>?) ?? [],
            );
          }).toList();
          _isLoadingReviews = false;
        });
      } else {
        setState(() => _isLoadingReviews = false);
      }
    } catch (e) {
      setState(() {
        _isLoadingReviews = false;
      });
      debugPrint('Error loading reviews: $e');
    }
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please add a review title';
    }
    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }
    if (value.trim().length > 100) {
      return 'Title cannot exceed 100 characters';
    }
    return null;
  }

  String? _validateReview(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please write your review';
    }
    if (value.trim().length < 10) {
      return 'Please provide more details (min 10 characters)';
    }
    if (value.trim().length > 1000) {
      return 'Review cannot exceed 1000 characters';
    }
    return null;
  }

  String? _validateRating() {
    if (_rating == 0) {
      return 'Please select a rating';
    }
    return null;
  }

  String _getRatingDescription(double rating) {
    if (rating >= 4.5) return 'Excellent';
    if (rating >= 4.0) return 'Very Good';
    if (rating >= 3.0) return 'Good';
    if (rating >= 2.0) return 'Average';
    if (rating >= 1.0) return 'Poor';
    return 'Very Poor';
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.0) return Colors.green;
    if (rating >= 3.0) return Colors.orange;
    return Colors.red;
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ratingError = _validateRating();
    if (ratingError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ratingError),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isSubmitting = true;
      _hasError = false;
    });

    try {
      final response = await _dio.post(
        "$baseurl/add_review/$lid",
        data: {
          "HOSPITAL": widget.hospitalId,
          "Review": _reviewController.text.trim(),
          "Rating": _rating,
          "title": _titleController.text.trim(),
          "tags": _reviewTags,
          "timestamp": DateTime.now().toIso8601String(),
          "hospital_name": widget.hospitalName,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await _showSuccessDialog();
        
        // Clear form
        _formKey.currentState!.reset();
        setState(() {
          _rating = 0.0;
          _reviewTags.clear();
        });
        
        // Refresh reviews
        await _loadExistingReviews();
      } else if (response.statusCode == 409) {
        throw Exception('You have already reviewed this hospital');
      } else {
        throw Exception('Server responded with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleApiError(e);
    } catch (e) {
      _handleGenericError(e.toString());
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _handleApiError(DioException e) {
    String errorMessage = 'Failed to submit review';
    
    if (e.response != null) {
      switch (e.response!.statusCode) {
        case 400:
          errorMessage = 'Invalid review data. Please check your input.';
          break;
        case 401:
          errorMessage = 'Session expired. Please login again.';
          break;
        case 403:
          errorMessage = 'You do not have permission to review.';
          break;
        case 429:
          errorMessage = 'Too many review attempts. Please try again later.';
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

  void _handleGenericError(String error) {
    _showErrorDialog('Error: $error');
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
            Text('Review Submitted!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thank you for sharing your experience.', style: TextStyle(fontSize: 16)),
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
                      'Your review helps others make better healthcare decisions.',
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
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('RETURN TO HOSPITAL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Stay on page for another review
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
            child: Text('WRITE ANOTHER'),
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
            Text('Submission Failed'),
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

  Widget _buildHospitalHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                image: widget.hospitalImage != null
                    ? DecorationImage(
                        image: NetworkImage(widget.hospitalImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: widget.hospitalImage == null
                  ? Icon(
                      Icons.local_hospital,
                      size: 40,
                      color: Colors.blueAccent,
                    )
                  : null,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.hospitalName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  if (widget.hospitalLocation != null) ...[
                    SizedBox(height: 4),
                    Text(
                      widget.hospitalLocation!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  SizedBox(height: 8),
                  if (_existingReviews.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.star, size: 18, color: Colors.orange),
                        SizedBox(width: 4),
                        Text(
                          '${_calculateAverageRating().toStringAsFixed(1)}/5.0',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '(${_existingReviews.length} reviews)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateAverageRating() {
    if (_existingReviews.isEmpty) return 0.0;
    final total = _existingReviews.map((r) => r.rating).reduce((a, b) => a + b);
    return total / _existingReviews.length;
  }

  Widget _buildRatingStars() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Rating *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() => _rating = index + 1.0);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        index < _rating.floor()
                            ? Icons.star
                            : (index < _rating && _rating % 1 != 0)
                                ? Icons.star_half
                                : Icons.star_border,
                        size: 48,
                        color: Colors.orange,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 12),
              Text(
                _rating > 0
                    ? '${_rating.toStringAsFixed(1)} - ${_getRatingDescription(_rating)}'
                    : 'Tap stars to rate',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _rating > 0 ? _getRatingColor(_rating) : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Tags (Optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableTags.map((tag) {
            final isSelected = _reviewTags.contains(tag);
            return ChoiceChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    if (_reviewTags.length < 5) {
                      _reviewTags.add(tag);
                    }
                  } else {
                    _reviewTags.remove(tag);
                  }
                });
              },
              selectedColor: Colors.blueAccent.withOpacity(0.2),
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.blueAccent : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
        if (_reviewTags.length >= 5)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Maximum 5 tags selected',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildExistingReviews() {
    if (_isLoadingReviews) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CircularProgressIndicator(color: Colors.blueAccent),
              SizedBox(height: 10),
              Text('Loading reviews...'),
            ],
          ),
        ),
      );
    }

    if (_existingReviews.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(Icons.reviews, size: 50, color: Colors.grey[400]),
            SizedBox(height: 10),
            Text(
              'No reviews yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Be the first to review this hospital!',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Reviews (${_existingReviews.length})',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 10),
        ..._existingReviews.take(3).map((review) => _buildReviewCard(review)).toList(),
        if (_existingReviews.length > 3)
          TextButton(
            onPressed: () {
              // Show all reviews
            },
            child: Text('View all ${_existingReviews.length} reviews'),
          ),
      ],
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    review.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.orange),
                    SizedBox(width: 4),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4),
            if (review.title.isNotEmpty)
              Text(
                review.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            SizedBox(height: 8),
            Text(
              review.reviewText,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            if (review.tags.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: review.tags
                    .map((tag) => Chip(
                          label: Text(tag),
                          backgroundColor: Colors.blue[50],
                          labelStyle: TextStyle(fontSize: 10),
                          padding: EdgeInsets.zero,
                        ))
                    .toList(),
              ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM dd, yyyy').format(review.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.thumb_up, size: 16),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Write a Review",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => _showReviewGuidelines(context),
            tooltip: 'Review Guidelines',
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hospital Header
                  _buildHospitalHeader(),
                  
                  SizedBox(height: 25),

                  // Rating Section
                  _buildRatingStars(),

                  SizedBox(height: 25),

                  // Review Title
                  Text(
                    'Review Title *',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Summarize your experience in a few words',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                    ),
                    validator: _validateTitle,
                    maxLength: 100,
                  ),

                  SizedBox(height: 20),

                  // Tags Selection
                  _buildTagsSelection(),

                  SizedBox(height: 25),

                  // Review Text
                  Text(
                    'Detailed Review *',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _reviewController,
                    focusNode: _reviewFocusNode,
                    maxLines: 5,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      hintText: 'Share your detailed experience with this hospital...\n• How was the staff?\n• How was the cleanliness?\n• How was the treatment?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                    ),
                    validator: _validateReview,
                  ),
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${_reviewController.text.length}/1000',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Existing Reviews
                  _buildExistingReviews(),

                  SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _submitReview,
                      icon: _isSubmitting
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(Icons.reviews),
                      label: Text(
                        _isSubmitting ? 'SUBMITTING...' : 'SUBMIT REVIEW',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        shadowColor: Colors.blueAccent.withOpacity(0.5),
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Submitting your review...',
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

  void _showReviewGuidelines(BuildContext context) {
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
                'Review Guidelines',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildGuideline('Be Honest', 'Share your genuine experience'),
                    _buildGuideline('Be Specific', 'Mention staff names or departments if helpful'),
                    _buildGuideline('Be Respectful', 'Avoid offensive language or personal attacks'),
                    _buildGuideline('Be Relevant', 'Focus on healthcare aspects'),
                    _buildGuideline('Be Helpful', 'Provide constructive feedback'),
                    _buildGuideline('Privacy', 'Don\'t share personal medical information'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Got it!'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGuideline(String title, String description) {
    return ListTile(
      leading: Icon(Icons.check_circle, color: Colors.green),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(description),
    );
  }
}

// Data Models
class Review {
  final String userName;
  final double rating;
  final String title;
  final String reviewText;
  final DateTime date;
  final List<String> tags;

  Review({
    required this.userName,
    required this.rating,
    required this.title,
    required this.reviewText,
    required this.date,
    required this.tags,
  });
}