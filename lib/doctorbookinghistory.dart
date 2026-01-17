// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/reg_api.dart';
// import 'package:vitasafe/review.dart';

// class DoctorBookingHistoryPage extends StatefulWidget {
// // USER LOGIN ID

//   const DoctorBookingHistoryPage({super.key});

//   @override
//   State<DoctorBookingHistoryPage> createState() =>
//       _DoctorBookingHistoryPageState();
// }

// class _DoctorBookingHistoryPageState extends State<DoctorBookingHistoryPage> {
//   bool isLoading = true;
//   List history = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchHistory();
//   }

//   Future<void> fetchHistory() async {
//     try {
//       final response =
//           await Dio().get("$baseurl/doctor_booking_history/$lid");
//           print(response.data);

//       if (response.statusCode == 201) {
//         setState(() {
//           history = response.data;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching doctor booking history: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Doctor Booking History"),
//         backgroundColor: Colors.blue,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : history.isEmpty
//               ? const Center(
//                   child: Text(
//                     "No Booking History Found",
//                     style: TextStyle(fontSize: 17),
//                   ),
//                 )
//               : ListView.builder(
//                   itemCount: history.length,
//                   itemBuilder: (context, index) {
//                     final item = history[index];

//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(15),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               item['Doctor_name'] ?? 'Unknown Doctor',
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 5),

//                             Text("Hospital: ${item['Hosp_name']}"),
//                             Text("Date: ${item['Date']}"),
//                             Text("Time: ${item['Time']}"),
//                             Text("Token: ${item['Token']}"),
//                             Text("Status: ${item['Status']}"),

//                             const SizedBox(height: 8),

//                             ElevatedButton(
//   onPressed: () {
//     print(item['Hosp_id'].runtimeType);
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ReviewPage(
//           hospitalId: item['Hosp_id'],
//           hospitalName: item['Hosp_name'],
//         ),
//       ),
//     );
//   },
//   child: const Text("Give Review"),
// )


//                             // Row(
//                             //   mainAxisAlignment: MainAxisAlignment.end,
//                             //   children: [
//                             //     Icon(Icons.local_hospital,
//                             //         color: Colors.redAccent),
//                             //     Text("  Hospital ID: ${item['Hosp_id']}"),
//                             //   ],
//                             // ),
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
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';
import 'package:vitasafe/review.dart';

class DoctorBookingHistoryPage extends StatefulWidget {
  const DoctorBookingHistoryPage({super.key});

  @override
  State<DoctorBookingHistoryPage> createState() =>
      _DoctorBookingHistoryPageState();
}

class _DoctorBookingHistoryPageState extends State<DoctorBookingHistoryPage> {
  bool isLoading = true;
  List history = [];
  String? errorMessage;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _validateLoginId();
    fetchHistory();
  }

  void _validateLoginId() {
    if (lid == null || lid.toString().isEmpty || lid! <= 0) {
      setState(() {
        errorMessage = 'Invalid user session. Please login again.';
        isLoading = false;
      });
    }
  }

  Future<void> fetchHistory() async {
    if (lid == null || lid! <= 0) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await dio.get(
        "$baseurl/doctor_booking_history/$lid",
        options: Options(
          validateStatus: (status) => status! < 500,
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      debugPrint("Response: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data is List) {
          setState(() {
            history = data;
            isLoading = false;
          });
        } else if (data is Map && data.containsKey('history')) {
          setState(() {
            history = data['history'] ?? [];
            isLoading = false;
          });
        } else if (data is Map && data.containsKey('bookings')) {
          setState(() {
            history = data['bookings'] ?? [];
            isLoading = false;
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else if (response.statusCode == 404) {
        setState(() {
          history = [];
          isLoading = false;
        });
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String message = 'Failed to fetch booking history';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.connectionError) {
        message = 'No internet connection. Please try again.';
      } else if (e.response?.statusCode == 401) {
        message = 'Unauthorized. Please login again.';
      } else if (e.response?.statusCode == 404) {
        setState(() {
          history = [];
          isLoading = false;
        });
        return;
      } else if (e.response != null) {
        message = 'Error: ${e.response?.statusCode}';
      }

      setState(() {
        errorMessage = message;
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red[700],
            duration: const Duration(seconds: 3),
          ),
        );
      }

      debugPrint("Error fetching doctor booking history: $e");
    } catch (e) {
      setState(() {
        errorMessage = 'An unexpected error occurred';
        isLoading = false;
      });
      debugPrint("Error: $e");
    }
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;

    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(String? status) {
    if (status == null) return Icons.help_outline;

    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'completed':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  String _formatDate(dynamic date) {
    try {
      if (date == null) return 'N/A';
      
      if (date is String) {
        final parsed = DateTime.tryParse(date);
        if (parsed != null) {
          return '${parsed.day}/${parsed.month}/${parsed.year}';
        }
        return date;
      }
      
      return date.toString();
    } catch (e) {
      return 'Invalid date';
    }
  }

  String _formatTime(dynamic time) {
    try {
      if (time == null) return 'N/A';
      return time.toString();
    } catch (e) {
      return 'Invalid time';
    }
  }

  void _navigateToReview(Map item) {
    final hospitalId = item['Hosp_id'];
    final hospitalName = item['Hosp_name'];

    if (hospitalId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hospital information not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewPage(
          hospitalId: hospitalId,
          hospitalName: hospitalName ?? 'Unknown Hospital',
        ),
      ),
    );
  }

  void _showBookingDetails(Map item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.medical_services,
                      color: Colors.blue[700],
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailSection(
                icon: Icons.person,
                title: 'Doctor Information',
                items: [
                  _buildDetailItem(
                    'Doctor Name',
                    item['Doctor_name'] ?? 'Unknown',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailSection(
                icon: Icons.local_hospital,
                title: 'Hospital Information',
                items: [
                  _buildDetailItem(
                    'Hospital Name',
                    item['Hosp_name'] ?? 'Unknown',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailSection(
                icon: Icons.calendar_today,
                title: 'Appointment Details',
                items: [
                  _buildDetailItem('Date', _formatDate(item['Date'])),
                  _buildDetailItem('Time', _formatTime(item['Time'])),
                  _buildDetailItem('Token Number', item['Token']?.toString() ?? 'N/A'),
                  _buildDetailItem('Status', item['Status'] ?? 'Unknown'),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToReview(item);
                  },
                  icon: const Icon(Icons.rate_review),
                  label: const Text('Give Review'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection({
    required IconData icon,
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items,
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 16,
            color: statusColor,
          ),
          const SizedBox(width: 4),
          Text(
            status ?? 'Unknown',
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
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
          "Doctor Booking History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : fetchHistory,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchHistory,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading booking history...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: fetchHistory,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "No Booking History Found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Your doctor appointments will appear here",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: fetchHistory,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        final doctorName = item['Doctor_name']?.toString() ?? 'Unknown Doctor';
        final hospitalName = item['Hosp_name']?.toString() ?? 'Unknown Hospital';
        final date = _formatDate(item['Date']);
        final time = _formatTime(item['Time']);
        final token = item['Token']?.toString() ?? 'N/A';
        final status = item['Status']?.toString() ?? 'Unknown';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: _getStatusColor(status).withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: InkWell(
            onTap: () => _showBookingDetails(item),
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
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.medical_services,
                          color: Colors.blue[700],
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctorName,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.local_hospital,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    hospitalName,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoChip(
                          Icons.calendar_today,
                          'Date',
                          date,
                          Colors.purple,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildInfoChip(
                          Icons.access_time,
                          'Time',
                          time,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoChip(
                          Icons.confirmation_number,
                          'Token',
                          token,
                          Colors.teal,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getStatusColor(status).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getStatusIcon(status),
                                size: 16,
                                color: _getStatusColor(status),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _getStatusColor(status),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _navigateToReview(item),
                      icon: const Icon(Icons.rate_review, size: 18),
                      label: const Text('Give Review'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue[700],
                        side: BorderSide(color: Colors.blue[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.9),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}