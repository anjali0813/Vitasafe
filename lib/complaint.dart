// import 'package:flutter/material.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/reg_api.dart';

// class ComplaintPage extends StatefulWidget {


//   const ComplaintPage({super.key});

//   @override
//   State<ComplaintPage> createState() => _ComplaintPageState();
// }

// class _ComplaintPageState extends State<ComplaintPage> {
//   final TextEditingController complaintController = TextEditingController();


//   List complaints = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadComplaints();
//   }

//   /// --------------------------- GET COMPLAINTS ---------------------------
//   Future<void> loadComplaints() async {
//     try {
//       final response = await dio.get("$baseurl/complaints/$lid");

//       if (response.statusCode == 200) {
//         setState(() {
//           complaints = response.data;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("GET Error: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   /// --------------------------- POST COMPLAINT ---------------------------
//   Future<void> submitComplaint() async {
//     String complaintText = complaintController.text.trim();

//     if (complaintText.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Complaint cannot be empty")),
//       );
//       return;
//     }

//     try {
//       final response = await dio.post(
//         "$baseurl/complaints/$lid",
//         data: {"Complaint": complaintText},
//       );

//       if (response.statusCode == 200) {
//         complaintController.clear();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Complaint submitted successfully")),
//         );
//         loadComplaints(); // refresh list
//       }
//     } catch (e) {
//       print("POST Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to submit complaint")),
//       );
//     }
//   }

//   /// --------------------------- UI ---------------------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Complaint Page"),
//         centerTitle: true,
//         backgroundColor: Color.fromARGB(255, 175, 156, 148),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
              
//               /// ----------- Complaint Input ------------
//               TextFormField(
//                 controller: complaintController,
//                 maxLines: 3,
//                 decoration: InputDecoration(
//                   labelText: 'Enter your complaint',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               /// ----------- Submit Button ------------
//               Center(
//                 child: ElevatedButton(
//                   onPressed: submitComplaint,
//                   child: const Text("SUBMIT"),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               /// ----------- Previous Complaints Title ------------
//               const Text(
//                 "Previous Complaints",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),

//               /// ----------- Complaints List ------------
//               isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : complaints.isEmpty
//                       ? const Center(child: Text("No complaints found"))
//                       : ListView.builder(
//                           shrinkWrap: true, // important for scrolling inside column
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: complaints.length,
//                           itemBuilder: (context, index) {
//                             final c = complaints[index];

//                             return Card(
//                               child: ListTile(
//                                 title: Text(c["Complaint"]),
//                                 subtitle: Text(
//                                   "Reply: ${c["Reply"] ?? "Pending"}",
//                                 ),
//                                 trailing: Text(c["Date"] ?? ""),
//                               ),
//                             );
//                           },
//                         ),
//             ],
//           ),
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

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final TextEditingController _complaintController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  List<dynamic> _complaints = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _hasError = false;
  String _errorMessage = '';
  String _filterStatus = 'All'; // 'All', 'Pending', 'Resolved'
  final FocusNode _complaintFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadComplaints();
    
    // Listen for when the complaint field gains focus
    _complaintFocusNode.addListener(() {
      if (_complaintFocusNode.hasFocus) {
        // Scroll to the input field when it gets focus
        Future.delayed(const Duration(milliseconds: 300), () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _complaintController.dispose();
    _complaintFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// --------------------------- VALIDATIONS ---------------------------
  String? _validateComplaint(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your complaint';
    }
    
    if (value.trim().length < 10) {
      return 'Complaint must be at least 10 characters long';
    }
    
    if (value.trim().length > 1000) {
      return 'Complaint cannot exceed 1000 characters';
    }
    
    // Check for spam/multiple spaces
    if (RegExp(r'\s{5,}').hasMatch(value)) {
      return 'Please avoid excessive spaces';
    }
    
    return null;
  }

  /// --------------------------- GET COMPLAINTS ---------------------------
  Future<void> _loadComplaints() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await dio.get(
        "$baseurl/complaints/$lid",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        
        // Validate data structure
        if (data.isNotEmpty) {
          for (var item in data) {
            if (item['Complaint'] == null) {
              throw Exception('Invalid complaint data received');
            }
          }
        }
        
        setState(() {
          _complaints = data;
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _complaints = [];
          _isLoading = false;
        });
      } else {
        throw Exception('Server responded with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleApiError(e);
    } catch (e) {
      _handleGenericError(e.toString());
    }
  }

  void _handleApiError(DioException e) {
    String errorMessage = 'Failed to load complaints';
    
    if (e.response != null) {
      switch (e.response!.statusCode) {
        case 401:
          errorMessage = 'Session expired. Please login again.';
          break;
        case 403:
          errorMessage = 'Access denied. Please check your permissions.';
          break;
        case 429:
          errorMessage = 'Too many requests. Please try again later.';
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

  /// --------------------------- POST COMPLAINT ---------------------------
  Future<void> _submitComplaint() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isSubmitting = true;
    });

    final String complaintText = _complaintController.text.trim();

    try {
      final response = await dio.post(
        "$baseurl/complaints/$lid",
        data: {
          "Complaint": complaintText,
          "timestamp": DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        _showSuccessDialog();
        _complaintController.clear();
        _formKey.currentState!.reset();
        
        // Refresh complaints list
        await _loadComplaints();
      } else if (response.statusCode == 400) {
        _showErrorDialog('Invalid complaint format. Please check and try again.');
      } else if (response.statusCode == 409) {
        _showErrorDialog('A similar complaint was recently submitted. Please wait.');
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        _showErrorDialog('Too many submissions. Please wait before submitting another complaint.');
      } else {
        _showErrorDialog('Failed to submit complaint. Please check your connection and try again.');
      }
    } catch (e) {
      _showErrorDialog('An unexpected error occurred: $e');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showSuccessDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 24),
            SizedBox(width: 10),
            Text('Complaint submitted successfully!'),
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
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 24),
            SizedBox(width: 10),
            Text('Submission Failed'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  /// --------------------------- UI HELPERS ---------------------------
  Color _getStatusColor(String? status) {
    if (status == null || status.isEmpty) return Colors.grey;
    
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'in progress':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    if (status == null || status.isEmpty) return Icons.help_outline;
    
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending;
      case 'resolved':
        return Icons.check_circle;
      case 'in progress':
        return Icons.hourglass_empty;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown date';
    
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  List<dynamic> _getFilteredComplaints() {
    if (_filterStatus == 'All') return _complaints;
    
    return _complaints.where((complaint) {
      final reply = complaint['Reply']?.toString().toLowerCase() ?? '';
      if (_filterStatus == 'Pending') {
        return reply.isEmpty || reply == 'pending' || reply == 'null';
      } else if (_filterStatus == 'Resolved') {
        return reply.isNotEmpty && reply != 'pending' && reply != 'null';
      }
      return true;
    }).toList();
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Pending', 'Resolved'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(filter),
              selected: _filterStatus == filter,
              onSelected: (selected) {
                setState(() {
                  _filterStatus = filter;
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Color(0xFFAF9C94).withOpacity(0.3),
              checkmarkColor: Color(0xFFAF9C94),
              labelStyle: TextStyle(
                color: _filterStatus == filter ? Color(0xFFAF9C94) : Colors.grey[700],
                fontWeight: _filterStatus == filter ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_satisfied_alt,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            'No Complaints Yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'You haven\'t submitted any complaints yet.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Use the form above to submit your first complaint.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.redAccent,
          ),
          SizedBox(height: 20),
          Text(
            'Unable to Load Complaints',
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
            onPressed: _loadComplaints,
            icon: Icon(Icons.refresh),
            label: Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFAF9C94),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintCard(Map<String, dynamic> complaint, int index) {
    final complaintText = complaint['Complaint']?.toString() ?? 'No complaint text';
    final reply = complaint['Reply']?.toString();
    final date = complaint['Date']?.toString();
    final isResolved = reply != null && reply.isNotEmpty && reply != 'pending' && reply != 'null';
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Complaint header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(reply).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(reply).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(reply),
                        size: 14,
                        color: _getStatusColor(reply),
                      ),
                      SizedBox(width: 4),
                      Text(
                        isResolved ? 'Resolved' : 'Pending',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(reply),
                        ),
                      ),
                    ],
                  ),
                ),
                if (date != null)
                  Text(
                    _formatDate(date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
            
            SizedBox(height: 12),
            
            // Complaint text
            Text(
              'Your Complaint:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 6),
            Text(
              complaintText,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
              ),
            ),
            
            // Reply section (if exists)
            if (reply != null && reply.isNotEmpty && reply != 'pending' && reply != 'null') ...[
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[100]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.admin_panel_settings, size: 18, color: Colors.green[700]),
                        SizedBox(width: 8),
                        Text(
                          'Admin Reply:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      reply,
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// --------------------------- MAIN UI ---------------------------
  @override
  Widget build(BuildContext context) {
    final filteredComplaints = _getFilteredComplaints();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Complaints & Feedback",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFAF9C94),
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadComplaints,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadComplaints,
        color: Color(0xFFAF9C94),
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // New Complaint Section
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.edit_note, color: Color(0xFFAF9C94), size: 24),
                            SizedBox(width: 10),
                            Text(
                              'Submit New Complaint',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _complaintController,
                            focusNode: _complaintFocusNode,
                            maxLines: 5,
                            maxLength: 1000,
                            decoration: InputDecoration(
                              labelText: 'Describe your issue or feedback',
                              hintText: 'Please provide detailed information about your complaint...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFAF9C94), width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: _validateComplaint,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _isSubmitting ? null : _submitComplaint,
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
                                  _isSubmitting ? 'SUBMITTING...' : 'SUBMIT COMPLAINT',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFAF9C94),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  disabledBackgroundColor: Color(0xFFAF9C94).withOpacity(0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Character count: ${_complaintController.text.length}/1000',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 30),
                
                // Previous Complaints Section
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Previous Complaints',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            if (_complaints.isNotEmpty)
                              Text(
                                '${filteredComplaints.length} complaint${filteredComplaints.length != 1 ? 's' : ''}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 12),
                        
                        if (_complaints.isNotEmpty) ...[
                          _buildFilterChips(),
                          SizedBox(height: 16),
                        ],
                        
                        // Complaints List
                        _isLoading
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(40.0),
                                  child: Column(
                                    children: [
                                      CircularProgressIndicator(
                                        color: Color(0xFFAF9C94),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Loading your complaints...',
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : _hasError
                                ? _buildErrorState()
                                : filteredComplaints.isEmpty
                                    ? _buildEmptyState()
                                    : Column(
                                        children: [
                                          ...filteredComplaints.asMap().entries.map((entry) {
                                            final index = entry.key;
                                            final complaint = entry.value as Map<String, dynamic>;
                                            return _buildComplaintCard(complaint, index);
                                          }).toList(),
                                          SizedBox(height: 20),
                                          if (filteredComplaints.length < _complaints.length)
                                            Text(
                                              'Showing ${filteredComplaints.length} of ${_complaints.length} complaints',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                        ],
                                      ),
                      ],
                    ),
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