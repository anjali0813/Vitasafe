// import 'package:flutter/material.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/reg_api.dart'; // contains dio & lid

// class BedBookingHistoryPage extends StatefulWidget {
//   const BedBookingHistoryPage({super.key});

//   @override
//   State<BedBookingHistoryPage> createState() => _BedBookingHistoryPageState();
// }

// class _BedBookingHistoryPageState extends State<BedBookingHistoryPage> {

//   Future<List<dynamic>> fetchBedBookingHistory() async {
//     try {
//       final response = await dio.get('$baseurl/bedbooking_history/$lid');
//       print(response.data);
//       if (response.statusCode == 200) {
//         return response.data as List;
//       } else {
//         throw Exception('Failed to load booking history');
//       }
//     } catch (e) {
//       debugPrint("Error fetching booking history: $e");
//       throw Exception("Error fetching history");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Bed Booking History"),
//         backgroundColor: Colors.redAccent,
//       ),

//       body: FutureBuilder<List<dynamic>>(
//         future: fetchBedBookingHistory(),
//         builder: (context, snapshot) {

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return const Center(
//               child: Text("Error loading history"),
//             );
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No booking history found.",
//                 style: TextStyle(fontSize: 16),
//               ),
//             );
//           }

//           final historyList = snapshot.data!;

//           return ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: historyList.length,
//             itemBuilder: (context, index) {
//               final item = historyList[index];

//               return Card(
//                 elevation: 3,
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         item['hospital_name'] ?? "Unknown Hospital",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blueAccent,
//                         ),
//                       ),
//                       const SizedBox(height: 8),

//                       Text("Ward: ${item['ward']}",
//                           style: const TextStyle(fontSize: 15)),

//                       Text("Date: ${item['date']}",
//                           style: const TextStyle(fontSize: 15)),

//                       Text(
//                         "Status: ${item['Status']}",
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: item['Status'] == 'Confirmed'
//                               ? Colors.green
//                               : Colors.red,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class BedBookingHistoryPage extends StatefulWidget {
  const BedBookingHistoryPage({super.key});

  @override
  State<BedBookingHistoryPage> createState() => _BedBookingHistoryPageState();
}

class _BedBookingHistoryPageState extends State<BedBookingHistoryPage> {
  List<dynamic> _historyList = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  String _filterStatus = 'All'; // 'All', 'Confirmed', 'Pending', 'Cancelled'
  String _sortBy = 'Date (Newest)'; // 'Date (Newest)', 'Date (Oldest)', 'Status'

  @override
  void initState() {
    super.initState();
    _fetchBedBookingHistory();
  }

  Future<void> _fetchBedBookingHistory() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await dio.get('$baseurl/bedbooking_history/$lid');
      
      if (response.statusCode == 200) {
        final data = response.data as List;
        
        // Validate response data structure
        if (data.isNotEmpty) {
          for (var item in data) {
            if (item['date'] == null || item['Status'] == null) {
              throw Exception('Invalid data format received from server');
            }
          }
        }
        
        setState(() {
          _historyList = data;
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _historyList = [];
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
    String errorMessage = 'Failed to load booking history';
    
    if (e.response != null) {
      switch (e.response!.statusCode) {
        case 401:
          errorMessage = 'Session expired. Please login again.';
          break;
        case 403:
          errorMessage = 'Access denied. Please check your permissions.';
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
    
    debugPrint("Error fetching booking history: $error");
  }

  List<dynamic> _getFilteredAndSortedList() {
    List<dynamic> filteredList = List.from(_historyList);
    
    // Apply status filter
    if (_filterStatus != 'All') {
      filteredList = filteredList.where((item) {
        return item['Status']?.toString().toLowerCase() == 
               _filterStatus.toLowerCase();
      }).toList();
    }
    
    // Apply sorting
    filteredList.sort((a, b) {
      switch (_sortBy) {
        case 'Date (Newest)':
          final dateA = DateTime.tryParse(a['date'] ?? '');
          final dateB = DateTime.tryParse(b['date'] ?? '');
          if (dateA != null && dateB != null) {
            return dateB.compareTo(dateA);
          }
          return 0;
        case 'Date (Oldest)':
          final dateA = DateTime.tryParse(a['date'] ?? '');
          final dateB = DateTime.tryParse(b['date'] ?? '');
          if (dateA != null && dateB != null) {
            return dateA.compareTo(dateB);
          }
          return 0;
        case 'Status':
          return (a['Status'] ?? '').compareTo(b['Status'] ?? '');
        default:
          return 0;
      }
    });
    
    return filteredList;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildFilterChips() {
    final statuses = ['All', 'Confirmed', 'Pending', 'Cancelled'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: statuses.map((status) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(status),
              selected: _filterStatus == status,
              onSelected: (selected) {
                setState(() {
                  _filterStatus = status;
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.blueAccent.withOpacity(0.2),
              checkmarkColor: Colors.blueAccent,
              labelStyle: TextStyle(
                color: _filterStatus == status ? Colors.blueAccent : Colors.grey[700],
                fontWeight: _filterStatus == status ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _sortBy,
        icon: Icon(Icons.sort, color: Colors.blueAccent),
        items: [
          'Date (Newest)',
          'Date (Oldest)',
          'Status',
        ].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _sortBy = newValue;
            });
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_toggle_off,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            'No Booking History',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'You haven\'t made any bed bookings yet.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _fetchBedBookingHistory,
            icon: Icon(Icons.refresh),
            label: Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
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
            'Unable to Load History',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _fetchBedBookingHistory,
                icon: Icon(Icons.refresh),
                label: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
                label: Text('Go Back'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item, int index) {
    final status = item['Status']?.toString() ?? 'Unknown';
    final hospitalName = item['hospital_name']?.toString() ?? 'Not Specified';
    final ward = item['ward']?.toString() ?? 'Not Specified';
    final bedNumber = item['bed_number']?.toString() ?? 'N/A';
    final date = _formatDate(item['date']?.toString() ?? '');
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Optional: Show details dialog
          _showBookingDetails(item);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      hospitalName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
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
                        SizedBox(width: 4),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(status),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Icon(
                    Icons.medical_services,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ward: $ward',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Icon(
                    Icons.bed,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Bed: $bedNumber',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Date: $date',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              
              if (item['booking_time'] != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Booked on: ${_formatDate(item['booking_time'].toString())}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Tap for details',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBookingDetails(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              SizedBox(height: 20),
              Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 20),
              _buildDetailRow('Hospital', item['hospital_name']),
              _buildDetailRow('Ward', item['ward']),
              _buildDetailRow('Bed Number', item['bed_number']),
              _buildDetailRow('Booking Date', _formatDate(item['date']?.toString() ?? '')),
              _buildDetailRow('Status', item['Status'],
                valueStyle: TextStyle(
                  color: _getStatusColor(item['Status']?.toString() ?? ''),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (item['booking_time'] != null)
                _buildDetailRow('Booked On', _formatDate(item['booking_time'].toString())),
              if (item['remarks'] != null)
                _buildDetailRow('Remarks', item['remarks']),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, dynamic value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
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
              value?.toString() ?? 'N/A',
              style: valueStyle ?? TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _getFilteredAndSortedList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bed Booking History",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          if (_historyList.isNotEmpty) _buildSortDropdown(),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchBedBookingHistory,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Loading your booking history...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : _hasError
              ? _buildErrorState()
              : filteredList.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _fetchBedBookingHistory,
                      color: Colors.blueAccent,
                      backgroundColor: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${filteredList.length} Booking${filteredList.length != 1 ? 's' : ''}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    if (_filterStatus != 'All')
                                      Text(
                                        'Filtered: $_filterStatus',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                _buildFilterChips(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                                bottom: 20,
                              ),
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                return _buildHistoryCard(
                                  filteredList[index] as Map<String, dynamic>,
                                  index,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}