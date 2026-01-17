// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:vitasafe/reg_api.dart'; // contains baseurl

// class BloodDonationHistoryPage extends StatefulWidget {
//   final int volunteerId;

//   const BloodDonationHistoryPage({super.key, required this.volunteerId});

//   @override
//   State<BloodDonationHistoryPage> createState() =>
//       _BloodDonationHistoryPageState();
// }

// class _BloodDonationHistoryPageState extends State<BloodDonationHistoryPage> {
//   List<dynamic> history = [];
//   bool isLoading = true;

//   final Dio dio = Dio();

//   @override
//   void initState() {
//     super.initState();
//     fetchHistory();
//   }

//   /// 🔹 Fetch accepted requests
//   Future<void> fetchHistory() async {
//     try {
//       final response =
//           await dio.get("$baseurl/history/${widget.volunteerId}");

//       if (response.statusCode == 200) {
//         setState(() {
//           history = response.data;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       debugPrint("History fetch error: $e");
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to fetch history")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Accepted Blood Requests History"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : history.isEmpty
//               ? const Center(
//                   child: Text(
//                     "No accepted blood requests yet.",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 )
//               : ListView.builder(
//                   padding: const EdgeInsets.all(12),
//                   itemCount: history.length,
//                   itemBuilder: (context, index) {
//                     final req = history[index];

//                     return Card(
//                       elevation: 4,
//                       margin: const EdgeInsets.only(bottom: 12),
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: Colors.redAccent.shade100,
//                           child: const Icon(
//                             Icons.bloodtype,
//                             color: Colors.white,
//                           ),
//                         ),
//                         title: Text(
//                           "Blood Group: ${req['Bloodgroup']}",
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 4),
//                             Text("Status: ${req['status']}"),
//                             Text("User: ${req['user_name']}"),
//                             Text("Contact: ${req['user_no']}"),
//                             Text(
//                                 "Location: ${req['user_latitude']}, ${req['user_longitude']}"),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodDonationHistoryPage extends StatefulWidget {
  final int volunteerId;
  final String? volunteerName;

  const BloodDonationHistoryPage({
    super.key,
    required this.volunteerId,
    this.volunteerName,
  });

  @override
  State<BloodDonationHistoryPage> createState() =>
      _BloodDonationHistoryPageState();
}

class _BloodDonationHistoryPageState extends State<BloodDonationHistoryPage> {
  List<dynamic> history = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  String selectedFilter = 'All';

  final Dio dio = Dio();
  final List<String> statusFilters = ['All', 'Completed', 'Pending', 'Cancelled'];
  final List<String> bloodGroups = ['All', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String selectedBloodGroup = 'All';

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      final response = await dio.get(
        'YOUR_BASE_URL/history/${widget.volunteerId}',
        options: Options(
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          setState(() {
            history = response.data;
            isLoading = false;
          });
        } else {
          throw Exception("Invalid data format received");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
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
      setState(() {
        hasError = true;
        errorMessage = message;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = "Failed to fetch history: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  List get filteredHistory {
    return history.where((item) {
      final matchesStatus = selectedFilter == 'All' || 
          item['status']?.toString() == selectedFilter;
      final matchesBloodGroup = selectedBloodGroup == 'All' || 
          item['Bloodgroup']?.toString() == selectedBloodGroup;
      return matchesStatus && matchesBloodGroup;
    }).toList();
  }

  Map<String, int> get statistics {
    return {
      'Total': history.length,
      'Completed': history.where((h) => h['status'] == 'Completed').length,
      'Pending': history.where((h) => h['status'] == 'Pending').length,
    };
  }

  Future<void> _makePhoneCall(String? phone) async {
    if (phone == null || phone.isEmpty) {
      _showSnackBar("Phone number not available", Colors.orange);
      return;
    }

    try {
      final uri = Uri.parse("tel:${phone.replaceAll(RegExp(r'[^0-9+]'), '')}");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _showSnackBar("Cannot make phone calls", Colors.red);
      }
    } catch (e) {
      _showSnackBar("Error making call", Colors.red);
    }
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

  void _showRequestDetails(dynamic request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getBloodGroupColor(request['Bloodgroup']).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bloodtype,
                        color: _getBloodGroupColor(request['Bloodgroup']),
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request['Bloodgroup']?.toString() ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: _getBloodGroupColor(request['Bloodgroup']),
                            ),
                          ),
                          Text(
                            "Blood Group",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(request['status']),
                  ],
                ),
                const Divider(height: 32),
                _buildDetailRow(Icons.person, 'Patient Name',
                    request['user_name']?.toString() ?? 'Not available'),
                const SizedBox(height: 16),
                _buildDetailRow(Icons.phone, 'Contact Number',
                    request['user_no']?.toString() ?? 'Not available'),
                const SizedBox(height: 16),
                _buildDetailRow(Icons.location_on, 'Location',
                    request['user_location']?.toString() ?? 
                    'Lat: ${request['user_latitude']}, Long: ${request['user_longitude']}'),
                if (request['request_date'] != null) ...[
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.calendar_today, 'Request Date',
                      _formatDate(request['request_date'])),
                ],
                if (request['donation_date'] != null) ...[
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.event, 'Donation Date',
                      _formatDate(request['donation_date'])),
                ],
                if (request['units'] != null) ...[
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.water_drop, 'Units Required',
                      '${request['units']} units'),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _makePhoneCall(request['user_no']?.toString());
                        },
                        icon: const Icon(Icons.call, size: 18),
                        label: const Text("Call"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green[700],
                          side: BorderSide(color: Colors.green[700]!),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          // Navigate to map or location
                        },
                        icon: const Icon(Icons.directions, size: 18),
                        label: const Text("Directions"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String? status) {
    final displayStatus = status ?? 'Unknown';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getStatusColor(status)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status),
            size: 14,
            color: _getStatusColor(status),
          ),
          const SizedBox(width: 4),
          Text(
            displayStatus,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _getStatusColor(status),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    try {
      if (date == null) return 'Not set';
      final DateTime dateTime = date is String ? DateTime.parse(date) : date;
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (e) {
      return date.toString();
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'Completed':
        return Icons.check_circle;
      case 'Pending':
        return Icons.pending;
      case 'Cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  Color _getBloodGroupColor(String? bloodGroup) {
    return Colors.red[700] ?? Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Blood Donation History",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            if (widget.volunteerName != null)
              Text(
                widget.volunteerName!,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
          ],
        ),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchHistory,
            tooltip: "Refresh",
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics Cards
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red[700]!, Colors.red[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Donations',
                        statistics['Total']!,
                        Icons.bloodtype,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Completed',
                        statistics['Completed']!,
                        Icons.check_circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...statusFilters.map((filter) {
                        final isSelected = selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() => selectedFilter = filter);
                            },
                            backgroundColor: Colors.white.withOpacity(0.2),
                            selectedColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.red[700] : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            checkmarkColor: Colors.red[700],
                          ),
                        );
                      }).toList(),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.white.withOpacity(0.3),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      ...bloodGroups.take(5).map((group) {
                        final isSelected = selectedBloodGroup == group;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(group),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() => selectedBloodGroup = group);
                            },
                            backgroundColor: Colors.white.withOpacity(0.2),
                            selectedColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.red[700] : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            checkmarkColor: Colors.red[700],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
            const SizedBox(height: 16),
            Text(
              "Loading donation history...",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                "Error",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: fetchHistory,
                icon: const Icon(Icons.refresh),
                label: const Text("Try Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (filteredHistory.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "No Records Found",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                selectedFilter == 'All' && selectedBloodGroup == 'All'
                    ? "You haven't accepted any blood donation requests yet."
                    : "No records match the selected filters.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              if (selectedFilter != 'All' || selectedBloodGroup != 'All')
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedFilter = 'All';
                      selectedBloodGroup = 'All';
                    });
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text("Clear Filters"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red[700],
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredHistory.length,
      itemBuilder: (context, index) => _buildHistoryCard(filteredHistory[index], index),
    );
  }

  Widget _buildHistoryCard(dynamic request, int index) {
    final bloodGroup = request['Bloodgroup']?.toString() ?? 'Unknown';
    final userName = request['user_name']?.toString() ?? 'Anonymous';
    final userPhone = request['user_no']?.toString() ?? 'N/A';
    final status = request['status']?.toString() ?? 'Unknown';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showRequestDetails(request),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getBloodGroupColor(bloodGroup).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      bloodGroup,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getBloodGroupColor(bloodGroup),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              userPhone,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(status),
                ],
              ),
              const SizedBox(height: 12),
              if (request['request_date'] != null)
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(request['request_date']),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _makePhoneCall(userPhone),
                      icon: const Icon(Icons.call, size: 16),
                      label: const Text("Call"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green[700],
                        side: BorderSide(color: Colors.green[700]!),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showRequestDetails(request),
                      icon: const Icon(Icons.info_outline, size: 16),
                      label: const Text("Details"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}