// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:vitasafe/reg_api.dart'; // contains baseurl

// class BloodDonationVolunteerPage extends StatefulWidget {
//   final int volunteerId;

//   const BloodDonationVolunteerPage({
//     super.key,
//     required this.volunteerId,
//   });

//   @override
//   State<BloodDonationVolunteerPage> createState() =>
//       _BloodDonationVolunteerPageState();
// }

// class _BloodDonationVolunteerPageState
//     extends State<BloodDonationVolunteerPage> {
//   List<dynamic> requests = [];
//   bool isLoading = true;

//   final Dio dio = Dio();

//   @override
//   void initState() {
//     super.initState();
//     fetchBloodRequests();
//   }

//   /// 🔹 Fetch blood requests (backend filters within 5 km)
//   Future<void> fetchBloodRequests() async {
//     try {
//       final response = await dio.get(
//         "$baseurl/requests",
//         queryParameters: {"volunteer_id": widget.volunteerId},
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           requests = response.data;
//           isLoading = false;
//         });
//         print(requests);
//       }
//     } catch (e) {
//       debugPrint("Fetch error: $e");
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to fetch requests")),
//       );
//     }
//   }

//   /// 🔹 Accept a blood request
//   Future<void> acceptRequest(int requestId) async {
//     try {
//       final response = await dio.post(
//         "$baseurl/acceptrequest/$requestId",
//         data: {"VolunteerID": widget.volunteerId},
//       );

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Request Accepted")),
//         );
//         fetchBloodRequests(); // refresh list
//       }
//     } catch (e) {
//       debugPrint("Accept error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Accept failed")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Nearby Blood Requests"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : requests.isEmpty
//               ? const Center(
//                   child: Text(
//                     "No nearby blood requests",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 )
//               : ListView.builder(
//                   padding: const EdgeInsets.all(12),
//                   itemCount: requests.length,
//                   itemBuilder: (context, index) {
//                     final req = requests[index];

//                     return Card(
//                       elevation: 4,
//                       margin: const EdgeInsets.only(bottom: 12),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 CircleAvatar(
//                                   backgroundColor:
//                                       Colors.redAccent.shade100,
//                                   child: const Icon(
//                                     Icons.bloodtype,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 Expanded(
//                                   child: Text(
//                                     "Blood Group: ${req['Bloodgroup']}",
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16),
//                                   ),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: req['status'] == "Accepted"
//                                       ? null
//                                       : () => acceptRequest(req['id']),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.redAccent,
//                                   ),
//                                   child: Text(req['status'] == "Accepted"
//                                       ? "Accepted"
//                                       : "Accept"),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             Text("Status: ${req['status']}"),
//                             const SizedBox(height: 4),
//                             Text("User: ${req['user_name']}"),
//                             // Text("Email: ${req['user_email']}"),
//                             Text("Contact: ${req['user_no']}"),
//                             // Text("DOB: ${req['user_dob']}"),
//                             const SizedBox(height: 4),
//                             // if (req['volunteer_name'] != "")
//                               // Column(
//                               //   crossAxisAlignment:
//                               //       CrossAxisAlignment.start,
//                               //   children: [
//                               //     const Divider(),
//                               //     Text(
//                               //         "Volunteer: ${req['volunteer_name']}"),
//                               //     Text(
//                               //         "Volunteer Email: ${req['volunteer_email']}"),
//                               //     Text(
//                               //         "Volunteer Phone: ${req['volunteer_phone']}"),
//                               //   ],
//                               // ),
//                             const SizedBox(height: 4),
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
import 'package:vitasafe/reg_api.dart';

class BloodDonationVolunteerPage extends StatefulWidget {
  final int volunteerId;

  const BloodDonationVolunteerPage({
    super.key,
    required this.volunteerId,
  });

  @override
  State<BloodDonationVolunteerPage> createState() =>
      _BloodDonationVolunteerPageState();
}

class _BloodDonationVolunteerPageState
    extends State<BloodDonationVolunteerPage> {
  List<dynamic> requests = [];
  bool isLoading = true;
  String? errorMessage;
  Set<int> processingRequests = {};

  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _validateVolunteerId();
    fetchBloodRequests();
  }

  void _validateVolunteerId() {
    if (widget.volunteerId <= 0) {
      setState(() {
        errorMessage = 'Invalid volunteer ID';
        isLoading = false;
      });
    }
  }

  Future<void> fetchBloodRequests() async {
    if (widget.volunteerId <= 0) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await dio.get(
        "$baseurl/requests",
        queryParameters: {"volunteer_id": widget.volunteerId},
        options: Options(
          validateStatus: (status) => status! < 500,
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is List) {
          setState(() {
            requests = data;
            isLoading = false;
          });
        } else if (data is Map && data.containsKey('requests')) {
          setState(() {
            requests = data['requests'] ?? [];
            isLoading = false;
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String message = 'Failed to fetch blood requests';
      
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.connectionError) {
        message = 'No internet connection.';
      } else if (e.response?.statusCode == 404) {
        message = 'No blood requests found.';
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
          ),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An unexpected error occurred';
        isLoading = false;
      });
      debugPrint("Fetch error: $e");
    }
  }

  Future<void> acceptRequest(int? requestId, int index) async {
    if (requestId == null || requestId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid request ID")),
      );
      return;
    }

    if (processingRequests.contains(requestId)) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Acceptance"),
        content: const Text(
          "Are you sure you want to accept this blood donation request?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: const Text("Accept"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      processingRequests.add(requestId);
    });

    try {
      final response = await dio.post(
        "$baseurl/acceptrequest/$requestId",
        data: {"VolunteerID": widget.volunteerId},
        options: Options(
          validateStatus: (status) => status! < 500,
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Request accepted successfully!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
        await fetchBloodRequests();
      } else {
        throw Exception('Failed to accept request');
      }
    } on DioException catch (e) {
      String message = 'Failed to accept request';
      
      if (e.type == DioExceptionType.connectionTimeout) {
        message = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        message = 'No internet connection.';
      } else if (e.response?.statusCode == 409) {
        message = 'Request already accepted by another volunteer.';
      } else if (e.response != null) {
        message = 'Error: ${e.response?.statusCode}';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red[700],
            duration: const Duration(seconds: 3),
          ),
        );
      }
      debugPrint("Accept error: $e");
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("An unexpected error occurred"),
            backgroundColor: Colors.red,
          ),
        );
      }
      debugPrint("Accept error: $e");
    } finally {
      setState(() {
        processingRequests.remove(requestId);
      });
    }
  }

  Color _getBloodGroupColor(String? bloodGroup) {
    if (bloodGroup == null) return Colors.redAccent;
    
    switch (bloodGroup.toUpperCase()) {
      case 'A+':
      case 'A-':
        return Colors.red[600]!;
      case 'B+':
      case 'B-':
        return Colors.orange[700]!;
      case 'AB+':
      case 'AB-':
        return Colors.purple[600]!;
      case 'O+':
      case 'O-':
        return Colors.pink[700]!;
      default:
        return Colors.redAccent;
    }
  }

  String _formatCoordinates(dynamic lat, dynamic lng) {
    try {
      if (lat == null || lng == null) return 'Location unavailable';
      
      final latStr = lat.toString();
      final lngStr = lng.toString();
      
      final latNum = double.parse(latStr);
      final lngNum = double.parse(lngStr);
      
      return '${latNum.toStringAsFixed(4)}, ${lngNum.toStringAsFixed(4)}';
    } catch (e) {
      return 'Location unavailable';
    }
  }

  Widget _buildStatusChip(String? status) {
    final isAccepted = status?.toLowerCase() == 'accepted';
    final isPending = status?.toLowerCase() == 'pending';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAccepted
            ? Colors.green[50]
            : isPending
                ? Colors.orange[50]
                : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAccepted
              ? Colors.green
              : isPending
                  ? Colors.orange
                  : Colors.grey,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAccepted
                ? Icons.check_circle
                : isPending
                    ? Icons.pending
                    : Icons.help_outline,
            size: 16,
            color: isAccepted
                ? Colors.green
                : isPending
                    ? Colors.orange
                    : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            status ?? 'Unknown',
            style: TextStyle(
              color: isAccepted
                  ? Colors.green[800]
                  : isPending
                      ? Colors.orange[800]
                      : Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showRequestDetails(Map req) {
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
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _getBloodGroupColor(req['Bloodgroup']),
                    child: Text(
                      req['Bloodgroup'] ?? 'N/A',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Blood Request Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildStatusChip(req['status']),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailSection(
                icon: Icons.person,
                title: 'Patient Information',
                items: [
                  _buildDetailItem('Name', req['user_name']),
                  _buildDetailItem('Contact', req['user_no']),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailSection(
                icon: Icons.bloodtype,
                title: 'Blood Details',
                items: [
                  _buildDetailItem('Blood Group', req['Bloodgroup']),
                  _buildDetailItem('Request Status', req['status']),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailSection(
                icon: Icons.location_on,
                title: 'Location',
                items: [
                  _buildDetailItem(
                    'Coordinates',
                    _formatCoordinates(req['user_latitude'], req['user_longitude']),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (req['status']?.toLowerCase() != 'accepted')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: processingRequests.contains(req['id'])
                        ? null
                        : () {
                            Navigator.pop(context);
                            acceptRequest(req['id'], 0);
                          },
                    icon: processingRequests.contains(req['id'])
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.check_circle),
                    label: Text(
                      processingRequests.contains(req['id'])
                          ? 'Processing...'
                          : 'Accept Request',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
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
              Icon(icon, size: 20, color: Colors.redAccent),
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

  Widget _buildDetailItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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
              value?.toString() ?? 'N/A',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nearby Blood Requests",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : fetchBloodRequests,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchBloodRequests,
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
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
            ),
            SizedBox(height: 16),
            Text(
              'Loading blood requests...',
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
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: fetchBloodRequests,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
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

    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bloodtype_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "No nearby blood requests",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Pull down to refresh",
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final req = requests[index];
        final bloodGroup = req['Bloodgroup']?.toString() ?? 'Unknown';
        final status = req['status']?.toString() ?? 'Unknown';
        final userName = req['user_name']?.toString() ?? 'Unknown';
        final userContact = req['user_no']?.toString() ?? 'N/A';
        final isAccepted = status.toLowerCase() == 'accepted';
        final isProcessing = processingRequests.contains(req['id']);

        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: _getBloodGroupColor(bloodGroup).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: InkWell(
            onTap: () => _showRequestDetails(req),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _getBloodGroupColor(bloodGroup)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getBloodGroupColor(bloodGroup),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            bloodGroup,
                            style: TextStyle(
                              color: _getBloodGroupColor(bloodGroup),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
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
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.phone,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  userContact,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _buildStatusChip(status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _formatCoordinates(
                                    req['user_latitude'], req['user_longitude']),
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
                      ),
                      const SizedBox(width: 8),
                      if (!isAccepted)
                        SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            onPressed: isProcessing
                                ? null
                                : () => acceptRequest(req['id'], index),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: isProcessing
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Text(
                                    "Accept",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
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
      },
    );
  }
}