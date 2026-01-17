// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:vitasafe/Doctorbook.dart';
// import 'package:vitasafe/reg_api.dart';

// class HospitalDoctorsPage extends StatefulWidget {
//   final int hospitalId;
//   final String hospitalName;

//   const HospitalDoctorsPage({
//     super.key,
//     required this.hospitalId,
//     required this.hospitalName,
//   });

//   @override
//   State<HospitalDoctorsPage> createState() => _HospitalDoctorsPageState();
// }

// class _HospitalDoctorsPageState extends State<HospitalDoctorsPage> {
//   bool isLoading = true;
//   List doctors = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchDoctors();
//   }

//   Future<void> _fetchDoctors() async {
//     try {
//       final response = await Dio().get('$baseurl/Doctor_view/${widget.hospitalId}');
//       print(response.data);
      
//       if (response.statusCode == 200 && response.data is List) {
//         setState(() {
//           doctors = response.data;
//           isLoading = false;
//         });
//       } else {
//         throw Exception("Invalid response format");
//       }
//     } catch (e) {
//       debugPrint("Doctor fetch error: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Doctors - ${widget.hospitalName}"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : doctors.isEmpty
//               ? const Center(
//                   child: Text(
//                     "No doctors found for this hospital.",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 )
//               : ListView.builder(
//                   itemCount: doctors.length,
//                   itemBuilder: (context, index) {
//                     final doc = doctors[index];
//                     return Card(
//                       margin: const EdgeInsets.all(10),
//                       elevation: 3,
//                       child: ListTile(
//                         onTap: () {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => DoctorBookingPage(
//         doctorId: doc['id'],      // adjust ID key
//         doctorName: doc['DoctorName'],   // adjust key
//         specialization: doc['Department'],
//       ),
//     ),
//   );
// },
//                         title: Text(
//                           doc['DoctorName'] ?? "Unknown Doctor",
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blueAccent),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Specialization: ${doc['Department'] ?? 'N/A'}"),
//                             Text("Place: ${doc['Place'] ?? 'N/A'}"),
//                             Text("Phone: ${doc['contact_no'] ?? 'N/A'}"),
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
import 'package:vitasafe/Doctorbook.dart';
import 'package:vitasafe/reg_api.dart';

class HospitalDoctorsPage extends StatefulWidget {
  final int hospitalId;
  final String hospitalName;
  final String? hospitalLocation;
  final String? hospitalImage;

  const HospitalDoctorsPage({
    super.key,
    required this.hospitalId,
    required this.hospitalName,
    this.hospitalLocation,
    this.hospitalImage,
  });

  @override
  State<HospitalDoctorsPage> createState() => _HospitalDoctorsPageState();
}

class _HospitalDoctorsPageState extends State<HospitalDoctorsPage> {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  List<dynamic> _doctors = [];
  List<dynamic> _filteredDoctors = [];
  String _searchQuery = '';
  String _selectedSpecialization = 'All';
  final TextEditingController _searchController = TextEditingController();
  final Dio _dio = Dio();
  final List<String> _specializations = ['All'];
  final Map<String, int> _availabilityStatus = {}; // doctorId -> available slots

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
    _setupSearchListener();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _setupSearchListener() {
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
        _applyFilters();
      });
    });
  }

  Future<void> _fetchDoctors() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await _dio.get(
        '$baseurl/Doctor_view/${widget.hospitalId}',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          final data = response.data as List;
          
          // Validate data structure
          for (var doctor in data) {
            if (doctor['id'] == null || doctor['DoctorName'] == null) {
              throw Exception('Invalid doctor data format');
            }
          }
          
          // Extract unique specializations
          final specializations = data
              .map((doc) => doc['Department']?.toString() ?? 'General')
              .where((spec) => spec.isNotEmpty)
              .toSet()
              .toList()
            ..sort();
          
          setState(() {
            _doctors = data;
            _filteredDoctors = List.from(data);
            _specializations
              ..clear()
              ..add('All')
              ..addAll(specializations);
            _isLoading = false;
          });
          
          // Fetch availability for each doctor
          await _fetchDoctorsAvailability();
        } else {
          throw Exception('Invalid response format: Expected List');
        }
      } else if (response.statusCode == 404) {
        setState(() {
          _doctors = [];
          _filteredDoctors = [];
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

  Future<void> _fetchDoctorsAvailability() async {
    try {
      for (var doctor in _doctors) {
        final doctorId = doctor['id'];
        if (doctorId != null) {
          // Mock availability check - replace with actual API call
          final availableSlots = await _getDoctorAvailability(doctorId);
          _availabilityStatus[doctorId.toString()] = availableSlots;
        }
      }
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error fetching availability: $e');
    }
  }

  Future<int> _getDoctorAvailability(int doctorId) async {
    // Mock implementation - replace with actual API
    // Example: await _dio.get('$baseurl/doctor-availability/$doctorId');
    await Future.delayed(const Duration(milliseconds: 100));
    return DateTime.now().millisecond % 10; // Random slots for demo
  }

  void _handleApiError(DioException e) {
    String errorMessage = 'Failed to load doctors list';
    
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
    List<dynamic> filtered = List.from(_doctors);
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((doctor) {
        final name = doctor['DoctorName']?.toString().toLowerCase() ?? '';
        final specialization = doctor['Department']?.toString().toLowerCase() ?? '';
        final place = doctor['Place']?.toString().toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        
        return name.contains(query) ||
               specialization.contains(query) ||
               place.contains(query);
      }).toList();
    }
    
    // Apply specialization filter
    if (_selectedSpecialization != 'All') {
      filtered = filtered.where((doctor) {
        final spec = doctor['Department']?.toString() ?? '';
        return spec == _selectedSpecialization;
      }).toList();
    }
    
    setState(() {
      _filteredDoctors = filtered;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchQuery = '';
    _applyFilters();
  }

  Widget _buildHospitalHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.hospitalImage != null)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(widget.hospitalImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.local_hospital,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.hospitalName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.hospitalLocation != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.hospitalLocation!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      '${_doctors.length} Doctor${_doctors.length != 1 ? 's' : ''} Available',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search doctors by name or specialization...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.redAccent),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: _clearSearch,
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    if (_specializations.length <= 1) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _specializations.map((spec) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Text(spec),
                selected: _selectedSpecialization == spec,
                onSelected: (selected) {
                  setState(() {
                    _selectedSpecialization = spec;
                    _applyFilters();
                  });
                },
                backgroundColor: Colors.grey[200],
                selectedColor: Colors.redAccent.withOpacity(0.2),
                checkmarkColor: Colors.redAccent,
                labelStyle: TextStyle(
                  color: _selectedSpecialization == spec 
                    ? Colors.redAccent 
                    : Colors.grey[700],
                  fontWeight: _selectedSpecialization == spec 
                    ? FontWeight.bold 
                    : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            _searchQuery.isNotEmpty || _selectedSpecialization != 'All'
                ? 'No matching doctors found'
                : 'No doctors available at this hospital',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try a different search term'
                : 'Check back later for available doctors',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          if (_searchQuery.isNotEmpty || _selectedSpecialization != 'All')
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _selectedSpecialization = 'All';
                    _searchController.clear();
                    _applyFilters();
                  });
                },
                icon: Icon(Icons.refresh),
                label: Text('Clear Filters'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
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
          const SizedBox(height: 20),
          Text(
            'Unable to Load Doctors',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _fetchDoctors,
                icon: Icon(Icons.refresh),
                label: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
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

  Widget _buildDoctorCard(Map<String, dynamic> doctor, int index) {
    final doctorId = doctor['id']?.toString();
    final doctorName = doctor['DoctorName']?.toString() ?? 'Unknown Doctor';
    final specialization = doctor['Department']?.toString() ?? 'General';
    final place = doctor['Place']?.toString();
    final contactNo = doctor['contact_no']?.toString();
    final experience = doctor['experience']?.toString();
    final qualifications = doctor['qualifications']?.toString();
    final consultationFee = doctor['consultation_fee']?.toString();
    final availableSlots = doctorId != null ? _availabilityStatus[doctorId] ?? 0 : 0;
    final isAvailable = availableSlots > 0;
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _navigateToBooking(doctor);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor Avatar
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                doctorName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
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
                                color: isAvailable 
                                  ? Colors.green.withOpacity(0.1) 
                                  : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isAvailable ? Colors.green : Colors.orange,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                isAvailable 
                                  ? '$availableSlots slots' 
                                  : 'No slots',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isAvailable ? Colors.green : Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          specialization,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (place != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  place,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Doctor Details
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  if (experience != null)
                    _buildDetailChip('$experience years', Icons.work_history),
                  if (qualifications != null)
                    _buildDetailChip(qualifications, Icons.school),
                  if (contactNo != null)
                    _buildDetailChip(contactNo, Icons.phone),
                  if (consultationFee != null)
                    _buildDetailChip('₹$consultationFee', Icons.attach_money),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _navigateToBooking(doctor),
                    icon: Icon(Icons.schedule, size: 18),
                    label: Text('Book Appointment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showDoctorDetails(doctor),
                    icon: Icon(Icons.info_outline, color: Colors.grey[600]),
                    tooltip: 'View Details',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToBooking(Map<String, dynamic> doctor) {
    final doctorId = doctor['id'] ?? 0;
    final doctorName = doctor['DoctorName']?.toString() ?? 'Unknown Doctor';
    final specialization = doctor['Department']?.toString() ?? 'General';
    final consultationFee = doctor['consultation_fee'] != null
        ? double.tryParse(doctor['consultation_fee'].toString())
        : null;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorBookingPage(
          doctorId: doctorId is int ? doctorId : int.tryParse(doctorId.toString()) ?? 0,
          doctorName: doctorName,
          specialization: specialization,
          hospitalName: widget.hospitalName,
          consultationFee: consultationFee,
          doctorImage: doctor['photo_url']?.toString(),
        ),
      ),
    );
  }

  void _showDoctorDetails(Map<String, dynamic> doctor) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return DoctorDetailsSheet(
          doctor: doctor,
          hospitalName: widget.hospitalName,
          onBookAppointment: () => _navigateToBooking(doctor),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Hospital Header
          _buildHospitalHeader(),
          
          // Search Bar
          _buildSearchBar(),
          
          // Filter Chips
          if (_doctors.isNotEmpty) ...[
            _buildFilterChips(),
            const SizedBox(height: 8),
          ],
          
          // Results Count
          if (_filteredDoctors.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_filteredDoctors.length} Doctor${_filteredDoctors.length != 1 ? 's' : ''} Found',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  if (_searchQuery.isNotEmpty || _selectedSpecialization != 'All')
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _selectedSpecialization = 'All';
                          _searchController.clear();
                          _applyFilters();
                        });
                      },
                      icon: Icon(Icons.filter_alt_off, size: 16),
                      label: Text('Clear Filters'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                      ),
                    ),
                ],
              ),
            ),
          ],
          
          // Doctors List or Loading/Error/Empty State
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.redAccent,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Loading doctors...',
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
                    : _filteredDoctors.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: _fetchDoctors,
                            color: Colors.redAccent,
                            backgroundColor: Colors.white,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 20),
                              itemCount: _filteredDoctors.length,
                              itemBuilder: (context, index) {
                                final doctor = _filteredDoctors[index] as Map<String, dynamic>;
                                return _buildDoctorCard(doctor, index);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

// Doctor Details Bottom Sheet
class DoctorDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final String hospitalName;
  final VoidCallback onBookAppointment;

  const DoctorDetailsSheet({
    super.key,
    required this.doctor,
    required this.hospitalName,
    required this.onBookAppointment,
  });

  @override
  Widget build(BuildContext context) {
    final doctorName = doctor['DoctorName']?.toString() ?? 'Unknown Doctor';
    final specialization = doctor['Department']?.toString() ?? 'General';
    final place = doctor['Place']?.toString();
    final contactNo = doctor['contact_no']?.toString();
    final experience = doctor['experience']?.toString();
    final qualifications = doctor['qualifications']?.toString();
    final consultationFee = doctor['consultation_fee']?.toString();
    final about = doctor['about']?.toString();
    
    return SingleChildScrollView(
      child: Padding(
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
            const SizedBox(height: 20),
            
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        specialization,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.local_hospital, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              hospitalName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Details Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                if (experience != null)
                  _buildDetailItem('Experience', '$experience years', Icons.work_history),
                if (consultationFee != null)
                  _buildDetailItem('Consultation Fee', '₹$consultationFee', Icons.attach_money),
                if (place != null)
                  _buildDetailItem('Location', place, Icons.location_on),
                if (contactNo != null)
                  _buildDetailItem('Contact', contactNo, Icons.phone),
              ],
            ),
            
            if (qualifications != null) ...[
              const SizedBox(height: 20),
              Text(
                'Qualifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                qualifications,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
              ),
            ],
            
            if (about != null) ...[
              const SizedBox(height: 20),
              Text(
                'About',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                about,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
              ),
            ],
            
            const SizedBox(height: 30),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onBookAppointment,
                    icon: Icon(Icons.schedule),
                    label: Text('Book Appointment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.redAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}