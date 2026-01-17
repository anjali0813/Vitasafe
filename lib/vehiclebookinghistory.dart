// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/reg_api.dart';

// class VehicleBookingHistoryPage extends StatefulWidget {
  

//   const VehicleBookingHistoryPage({super.key});

//   @override
//   State<VehicleBookingHistoryPage> createState() =>
//       _VehicleBookingHistoryPageState();
// }

// class _VehicleBookingHistoryPageState
//     extends State<VehicleBookingHistoryPage> {
//   bool isLoading = true;
//   List historyList = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchHistory();
//   }

//   Future<void> fetchHistory() async {
//     try {
//       final response = await Dio()
//           .get("$baseurl/ambulancebooking_history/$lid");

//       print(response.data);

//       if (response.statusCode == 200) {
//         setState(() {
//           historyList = response.data;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching ambulance booking history: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Ambulance Booking History"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : historyList.isEmpty
//               ? const Center(
//                   child: Text(
//                     "No ambulance booking history found.",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 )
//               : ListView.builder(
//                   padding: const EdgeInsets.all(12),
//                   itemCount: historyList.length,
//                   itemBuilder: (context, index) {
//                     final item = historyList[index];

//                     return Card(
//                       elevation: 3,
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Driver: ${item['driver_name']}",
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.blueAccent,
//                               ),
//                             ),
//                             const SizedBox(height: 5),

//                             Text("Hospital: ${item['hospital_name']}"),
//                             Text("Vehicle No: ${item['vehicle_no']}"),
//                             Text("Date: ${item['Date']}"),
//                             Text(
//                               "Status: ${item['status']}",
//                               style: TextStyle(
//                                 color: item['status'] == "Completed"
//                                     ? Colors.green
//                                     : item['status'] == "Pending"
//                                         ? Colors.orange
//                                         : Colors.red,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
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
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class VehicleBookingHistoryPage extends StatefulWidget {
  const VehicleBookingHistoryPage({super.key});

  @override
  State<VehicleBookingHistoryPage> createState() =>
      _VehicleBookingHistoryPageState();
}

class _VehicleBookingHistoryPageState
    extends State<VehicleBookingHistoryPage> {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  List<dynamic> _historyList = [];
  List<dynamic> _filteredList = [];
  String _filterStatus = 'All'; // 'All', 'Completed', 'Pending', 'Cancelled', 'In Progress'
  String _sortBy = 'Date (Newest)'; // 'Date (Newest)', 'Date (Oldest)', 'Status'
  final Dio _dio = Dio();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchHistory() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await _dio.get(
        "$baseurl/ambulancebooking_history/$lid",
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
            if (item['Date'] == null || item['status'] == null) {
              throw Exception('Invalid data format received from server');
            }
          }
        }
        
        setState(() {
          _historyList = data;
          _filteredList = List.from(data);
          _isLoading = false;
          _applyFilters(); // Initial filter application
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _historyList = [];
          _filteredList = [];
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
  }

  void _applyFilters() {
    List<dynamic> filtered = List.from(_historyList);
    
    // Apply status filter
    if (_filterStatus != 'All') {
      filtered = filtered.where((item) {
        final status = item['status']?.toString().toLowerCase();
        return status == _filterStatus.toLowerCase();
      }).toList();
    }
    
    // Apply sorting
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'Date (Newest)':
          final dateA = DateTime.tryParse(a['Date'] ?? '');
          final dateB = DateTime.tryParse(b['Date'] ?? '');
          if (dateA != null && dateB != null) {
            return dateB.compareTo(dateA);
          }
          return 0;
        case 'Date (Oldest)':
          final dateA = DateTime.tryParse(a['Date'] ?? '');
          final dateB = DateTime.tryParse(b['Date'] ?? '');
          if (dateA != null && dateB != null) {
            return dateA.compareTo(dateB);
          }
          return 0;
        case 'Status':
          return (a['status'] ?? '').compareTo(b['status'] ?? '');
        default:
          return 0;
      }
    });
    
    setState(() {
      _filteredList = filtered;
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'confirmed':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'in progress':
        return Icons.hourglass_empty;
      case 'pending':
        return Icons.pending;
      case 'cancelled':
        return Icons.cancel;
      case 'confirmed':
        return Icons.verified;
      default:
        return Icons.help_outline;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Date not available';
    
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatTime(String? timeString) {
    if (timeString == null) return '';
    
    try {
      return DateFormat('hh:mm a').format(DateTime.parse('2000-01-01 $timeString'));
    } catch (e) {
      return timeString;
    }
  }

  Widget _buildFilterChips() {
    final statuses = ['All', 'Completed', 'Pending', 'Cancelled', 'In Progress', 'Confirmed'];
    
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
                  _applyFilters();
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.redAccent.withOpacity(0.2),
              checkmarkColor: Colors.redAccent,
              labelStyle: TextStyle(
                color: _filterStatus == status ? Colors.redAccent : Colors.grey[700],
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
        icon: Icon(Icons.sort, color: Colors.redAccent),
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
              _applyFilters();
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
            Icons.local_shipping,
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
            _filterStatus != 'All'
                ? 'No $_filterStatus ambulance bookings found'
                : 'You haven\'t booked any ambulance yet.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _fetchHistory,
            icon: Icon(Icons.refresh),
            label: Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
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
                onPressed: _fetchHistory,
                icon: Icon(Icons.refresh),
                label: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
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

  Widget _buildStatsSummary() {
    if (_historyList.isEmpty) return SizedBox();
    
    final total = _historyList.length;
    final completed = _historyList.where((item) => 
      item['status']?.toString().toLowerCase() == 'completed').length;
    final pending = _historyList.where((item) => 
      item['status']?.toString().toLowerCase() == 'pending').length;
    final cancelled = _historyList.where((item) => 
      item['status']?.toString().toLowerCase() == 'cancelled').length;
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Booking Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total', total.toString(), Colors.blue),
                _buildStatItem('Completed', completed.toString(), Colors.green),
                _buildStatItem('Pending', pending.toString(), Colors.orange),
                _buildStatItem('Cancelled', cancelled.toString(), Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> item, int index) {
    final status = item['status']?.toString() ?? 'Unknown';
    final driverName = item['driver_name']?.toString() ?? 'Not Assigned';
    final hospitalName = item['hospital_name']?.toString() ?? 'Not Specified';
    final vehicleNo = item['vehicle_no']?.toString() ?? 'Not Available';
    final date = _formatDate(item['Date']?.toString());
    final pickLocation = item['pickup_location']?.toString();
    final dropLocation = item['drop_location']?.toString();
    final bookingTime = item['booking_time']?.toString();
    final estimatedTime = item['estimated_time']?.toString();
    final driverContact = item['driver_contact']?.toString();
    final fare = item['fare']?.toString();
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showBookingDetails(item),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                          size: 14,
                          color: _getStatusColor(status),
                        ),
                        SizedBox(width: 4),
                        Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              // Driver and Vehicle Info
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driverName,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Vehicle: $vehicleNo',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              // Hospital Info
              Row(
                children: [
                  Icon(
                    Icons.local_hospital,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hospitalName,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              if (pickLocation != null) ...[
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pickup: $pickLocation',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              
              if (dropLocation != null) ...[
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.flag,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Drop: $dropLocation',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              
              if (fare != null) ...[
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Fare:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      '₹$fare',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ],
              
              SizedBox(height: 12),
              Divider(height: 1),
              SizedBox(height: 8),
              
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Tap for details',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.info_outline,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                  ],
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
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
              
              _buildDetailRow('Booking ID', item['id']?.toString() ?? 'N/A'),
              _buildDetailRow('Status', item['status']?.toString() ?? 'Unknown',
                valueStyle: TextStyle(
                  color: _getStatusColor(item['status']?.toString() ?? ''),
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildDetailRow('Driver', item['driver_name']?.toString() ?? 'Not Assigned'),
              _buildDetailRow('Driver Contact', item['driver_contact']?.toString() ?? 'N/A'),
              _buildDetailRow('Hospital', item['hospital_name']?.toString() ?? 'Not Specified'),
              _buildDetailRow('Vehicle Number', item['vehicle_no']?.toString() ?? 'N/A'),
              _buildDetailRow('Booking Date', _formatDate(item['Date']?.toString())),
              if (item['pickup_time'] != null)
                _buildDetailRow('Pickup Time', _formatTime(item['pickup_time']?.toString())),
              if (item['estimated_time'] != null)
                _buildDetailRow('Estimated Arrival', item['estimated_time']!.toString()),
              if (item['pickup_location'] != null)
                _buildDetailRow('Pickup Location', item['pickup_location']),
              if (item['drop_location'] != null)
                _buildDetailRow('Drop Location', item['drop_location']),
              if (item['fare'] != null)
                _buildDetailRow('Fare', '₹${item['fare']}'),
              if (item['payment_status'] != null)
                _buildDetailRow('Payment', item['payment_status']),
              if (item['booking_time'] != null)
                _buildDetailRow('Booked On', _formatDate(item['booking_time']?.toString())),
              
              SizedBox(height: 30),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Close'),
                    ),
                  ),
                  if (item['driver_contact'] != null) ...[
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Implement call functionality
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Calling driver...'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        icon: Icon(Icons.phone, size: 20),
                        label: Text('Call Driver'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {TextStyle? valueStyle}) {
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
              value,
              style: valueStyle ?? TextStyle(color: Colors.grey[800]),
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
        title: Text(
          "Ambulance Booking History",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          if (_historyList.isNotEmpty) _buildSortDropdown(),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchHistory,
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
                    color: Colors.redAccent,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Loading booking history...',
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
              : _historyList.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _fetchHistory,
                      color: Colors.redAccent,
                      backgroundColor: Colors.white,
                      child: Column(
                        children: [
                          // Stats Summary
                          _buildStatsSummary(),
                          
                          // Filter Chips
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${_filteredList.length} Booking${_filteredList.length != 1 ? 's' : ''}',
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
                                          color: Colors.redAccent,
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
                          
                          // Bookings List
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.only(bottom: 20),
                              itemCount: _filteredList.length,
                              itemBuilder: (context, index) {
                                return _buildBookingCard(
                                  _filteredList[index] as Map<String, dynamic>,
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