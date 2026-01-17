// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:vitasafe/BedBook.dart';
// import 'package:vitasafe/reg_api.dart';


// class BedListPage extends StatefulWidget {
//   final int hospitalId;
//   final String hospitalName;

//   const BedListPage({
//     super.key,
//     required this.hospitalId,
//     required this.hospitalName,
//   });

//   @override
//   State<BedListPage> createState() => _BedListPageState();
// }

// class _BedListPageState extends State<BedListPage> {
//   List beds = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchBeds();
//   }

//   Future<void> _fetchBeds() async {
//     try {
//       final response =
//           await Dio().get('$baseurl/view_bed/${widget.hospitalId}');
//       print(response.data);

//       if (response.statusCode == 200) {
//         setState(() {
//           beds = response.data;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching beds: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Beds - ${widget.hospitalName}"),
//         backgroundColor: Colors.blue,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : beds.isEmpty
//               ? const Center(child: Text("No Beds Available"))
//               : ListView.builder(
//                   itemCount: beds.length,
//                   itemBuilder: (context, index) {
//                     final bed = beds[index];

//                     return Card(
//                       elevation: 3,
//                       margin:
//                           const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                       child: ListTile(
//                         title: Text(
//                           "Ward: ${bed['ward']}",
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blueAccent),
//                         ),
//                         subtitle: Text(
//                             "Beds Available: ${bed['count'] ?? 0}"),
//                         trailing: ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => BedBookPage(
//                                           bedId: bed['bed_id'],
//                                         )));
//                           },
//                           child: const Text("BOOK"),
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

class BedListPage extends StatefulWidget {
  final int hospitalId;
  final String hospitalName;

  const BedListPage({
    super.key,
    required this.hospitalId,
    required this.hospitalName,
  });

  @override
  State<BedListPage> createState() => _BedListPageState();
}

class _BedListPageState extends State<BedListPage> {
  List beds = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  String selectedFilter = 'All';

  final List<String> wardFilters = ['All', 'General', 'ICU', 'Emergency', 'Maternity', 'Pediatric'];

  @override
  void initState() {
    super.initState();
    _fetchBeds();
  }

  Future<void> _fetchBeds() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      final response = await Dio().get(
        'YOUR_BASE_URL/view_bed/${widget.hospitalId}',
        options: Options(
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          setState(() {
            beds = response.data;
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
        errorMessage = "Failed to load beds: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  List get filteredBeds {
    if (selectedFilter == 'All') return beds;
    return beds.where((bed) {
      final ward = bed['ward']?.toString().toLowerCase() ?? '';
      return ward.contains(selectedFilter.toLowerCase());
    }).toList();
  }

  int get totalAvailableBeds {
    return filteredBeds.fold(0, (sum, bed) => sum + (bed['count'] as int? ?? 0));
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

  void _showBedDetails(dynamic bed) {
    final count = bed['count'] as int? ?? 0;
    final isAvailable = count > 0;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isAvailable ? Colors.green[50] : Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bed,
                    color: isAvailable ? Colors.green[700] : Colors.red[700],
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bed['ward']?.toString() ?? 'Ward',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        isAvailable
                            ? "$count beds available"
                            : "No beds available",
                        style: TextStyle(
                          color: isAvailable ? Colors.green[700] : Colors.red[700],
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildDetailRow(Icons.local_hospital, 'Hospital', widget.hospitalName),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.meeting_room, 'Ward Type', bed['ward']?.toString() ?? 'N/A'),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.bed, 'Available Beds', count.toString()),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.info_outline, 'Status',
                isAvailable ? 'Available' : 'Fully Occupied'),
            if (bed['facilities'] != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                  Icons.medical_services, 'Facilities', bed['facilities'].toString()),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: isAvailable
                    ? () {
                        Navigator.pop(context);
                        // Navigate to booking page
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => BedBookPage(
                        //       bedId: bed['bed_id'],
                        //       wardName: bed['ward']?.toString(),
                        //       hospitalName: widget.hospitalName,
                        //       availableCount: count,
                        //     ),
                        //   ),
                        // );
                        _showSnackBar("Booking feature - integrate with BedBookPage", Colors.blue);
                      }
                    : null,
                icon: const Icon(Icons.book_online),
                label: const Text("Book Bed"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  disabledForegroundColor: Colors.grey[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
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
              const SizedBox(height: 2),
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
              "Available Beds",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            Text(
              widget.hospitalName,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchBeds,
            tooltip: "Refresh",
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Stats Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[700]!, Colors.blue[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      icon: Icons.bed,
                      label: "Total Beds",
                      value: totalAvailableBeds.toString(),
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _buildStatCard(
                      icon: Icons.meeting_room,
                      label: "Wards",
                      value: filteredBeds.length.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: wardFilters.map((filter) {
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
                            color: isSelected ? Colors.blue[700] : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          checkmarkColor: Colors.blue[700],
                        ),
                      );
                    }).toList(),
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

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 16),
            Text(
              "Loading bed information...",
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
                onPressed: _fetchBeds,
                icon: const Icon(Icons.refresh),
                label: const Text("Try Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (filteredBeds.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bed_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "No Beds Available",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                selectedFilter == 'All'
                    ? "No beds are currently available at this hospital."
                    : "No $selectedFilter beds available. Try a different ward type.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selectedFilter != 'All')
                    OutlinedButton.icon(
                      onPressed: () => setState(() => selectedFilter = 'All'),
                      icon: const Icon(Icons.clear),
                      label: const Text("Clear Filter"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue[700],
                      ),
                    ),
                  if (selectedFilter != 'All') const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _fetchBeds,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Refresh"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredBeds.length,
      itemBuilder: (context, index) => _buildBedCard(filteredBeds[index], index),
    );
  }

  Widget _buildBedCard(dynamic bed, int index) {
    final wardName = bed['ward']?.toString() ?? 'Ward';
    final count = bed['count'] as int? ?? 0;
    final isAvailable = count > 0;
    final bedType = bed['bed_type']?.toString() ?? 'Standard';
    final facilities = bed['facilities']?.toString();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showBedDetails(bed),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isAvailable ? Colors.green[50] : Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.bed,
                      color: isAvailable ? Colors.green[700] : Colors.red[700],
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wardName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            bedType,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isAvailable ? Colors.green[50] : Colors.red[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isAvailable ? Colors.green[200]! : Colors.red[200]!,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isAvailable ? Icons.check_circle : Icons.cancel,
                          size: 16,
                          color: isAvailable ? Colors.green[700] : Colors.red[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isAvailable ? "Available" : "Full",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isAvailable ? Colors.green[700] : Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 24),

              // Bed Count Display
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isAvailable ? Colors.blue[50] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isAvailable ? Colors.blue[200]! : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bed,
                      color: isAvailable ? Colors.blue[700] : Colors.grey[600],
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      count.toString(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isAvailable ? Colors.blue[700] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "beds available",
                      style: TextStyle(
                        fontSize: 14,
                        color: isAvailable ? Colors.blue[700] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              if (facilities != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.medical_services, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        facilities,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 16),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isAvailable
                      ? () {
                          // Navigate to booking page
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => BedBookPage(
                          //       bedId: bed['bed_id'],
                          //       wardName: wardName,
                          //       hospitalName: widget.hospitalName,
                          //       availableCount: count,
                          //     ),
                          //   ),
                          // );
                          _showSnackBar(
                              "Booking feature - integrate with BedBookPage", Colors.blue);
                        }
                      : null,
                  icon: Icon(
                    isAvailable ? Icons.book_online : Icons.block,
                    size: 20,
                  ),
                  label: Text(isAvailable ? "Book Bed" : "Fully Occupied"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    disabledForegroundColor: Colors.grey[600],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
}