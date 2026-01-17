// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/reg_api.dart';

// class VolunteerTaskAssignmentPage extends StatefulWidget {

//   const VolunteerTaskAssignmentPage({super.key});

//   @override
//   State<VolunteerTaskAssignmentPage> createState() =>
//       _VolunteerTaskAssignmentPageState();
// }

// class _VolunteerTaskAssignmentPageState
//     extends State<VolunteerTaskAssignmentPage> {
//   final Dio dio = Dio();

//   List tasks = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchTasks();
//   }

//   /// 🔹 GET TASKS
//   Future<void> fetchTasks() async {
//     try {
//       final response =
//           await dio.get("$baseurl/ViewTask/$lid");

//           print(response.data);

//       setState(() {
//         tasks = response.data;
//         isLoading = false;
//       });
//     } catch (e) {
//       debugPrint("Fetch error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to load tasks")),
//       );
//     }
//   }

//   /// 🔹 UPDATE TASK STATUS
//   Future<void> markCompleted(int taskId) async {
//     try {
//       await dio.put(
//         "$baseurl/ViewTask/$taskId",
//         data: {"Status": "Completed"},
//       );

//       fetchTasks();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Task marked as completed")),
//       );
//     } catch (e) {
//       debugPrint("Update error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to update task")),
//       );
//     }
//   }

//   Color statusColor(String status) {
//     switch (status) {
//       case "Completed":
//         return Colors.green;
//       case "Assigned":
//         return Colors.orange;
//       default:
//         return Colors.redAccent;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Volunteer Task Assignment"),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: tasks.length,
//               itemBuilder: (context, index) {
//                 final task = tasks[index];

//                 return Card(
//                   elevation: 3,
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   child: Padding(
//                     padding: const EdgeInsets.all(15),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           task["TaskName"] ?? "",
//                           style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.deepPurple),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           task["TaskDescription"] ?? "",
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 5),
//                               decoration: BoxDecoration(
//                                 color: statusColor(task["Status"]),
//                                 borderRadius:
//                                     BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 task["Status"],
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             if (task["Status"] != "Completed")
//                               ElevatedButton(
//                                 onPressed: () =>
//                                     markCompleted(task["id"]),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor:
//                                       Colors.deepPurple,
//                                 ),
//                                 child: const Text(
//                                   "Mark Completed",
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class VolunteerTaskAssignmentPage extends StatefulWidget {
  const VolunteerTaskAssignmentPage({super.key});

  @override
  State<VolunteerTaskAssignmentPage> createState() =>
      _VolunteerTaskAssignmentPageState();
}

class _VolunteerTaskAssignmentPageState
    extends State<VolunteerTaskAssignmentPage> with SingleTickerProviderStateMixin {
  final Dio dio = Dio();

  List tasks = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  String selectedFilter = 'All';
  late TabController _tabController;

  final List<String> statusFilters = ['All', 'Assigned', 'In Progress', 'Completed'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          selectedFilter = statusFilters[_tabController.index];
        });
      }
    });
    fetchTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchTasks() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      final response = await dio.get(
        'YOUR_BASE_URL/ViewTask/USER_ID',
        options: Options(
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          setState(() {
            tasks = response.data;
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
        errorMessage = "Failed to load tasks: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  Future<void> updateTaskStatus(int taskId, String newStatus) async {
    try {
      final response = await dio.put(
        'YOUR_BASE_URL/ViewTask/$taskId',
        data: {"Status": newStatus},
        options: Options(
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchTasks();
        _showSnackBar("Task status updated to $newStatus", Colors.green);
      } else {
        _showSnackBar("Failed to update task status", Colors.red);
      }
    } on DioException catch (e) {
      String message = "Network error";
      if (e.type == DioExceptionType.connectionTimeout) {
        message = "Connection timeout";
      } else if (e.type == DioExceptionType.connectionError) {
        message = "No internet connection";
      }
      _showSnackBar(message, Colors.red);
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}", Colors.red);
    }
  }

  void _showStatusUpdateDialog(dynamic task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Update Task Status"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task['TaskName'] ?? 'Task',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text("Select new status:"),
            const SizedBox(height: 12),
            ...['Assigned', 'In Progress', 'Completed'].map((status) {
              final isCurrentStatus = task['Status'] == status;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: isCurrentStatus
                      ? null
                      : () {
                          Navigator.pop(context);
                          updateTaskStatus(task['id'], status);
                        },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isCurrentStatus
                          ? _getStatusColor(status).withOpacity(0.3)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCurrentStatus
                            ? _getStatusColor(status)
                            : Colors.grey[300]!,
                        width: isCurrentStatus ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getStatusIcon(status),
                          color: _getStatusColor(status),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          status,
                          style: TextStyle(
                            fontWeight: isCurrentStatus
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isCurrentStatus
                                ? _getStatusColor(status)
                                : Colors.black87,
                          ),
                        ),
                        if (isCurrentStatus) ...[
                          const Spacer(),
                          Text(
                            "Current",
                            style: TextStyle(
                              fontSize: 12,
                              color: _getStatusColor(status),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(dynamic task) {
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
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.task_alt, color: Colors.purple[700], size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        task['TaskName'] ?? 'Task',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(task['Status']).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(task['Status']),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(task['Status']),
                        size: 16,
                        color: _getStatusColor(task['Status']),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        task['Status'] ?? 'Unknown',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(task['Status']),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 32),
                _buildDetailSection(
                  'Description',
                  task['TaskDescription']?.toString() ?? 'No description provided',
                  Icons.description,
                ),
                if (task['AssignedDate'] != null) ...[
                  const SizedBox(height: 16),
                  _buildDetailSection(
                    'Assigned Date',
                    _formatDate(task['AssignedDate']),
                    Icons.calendar_today,
                  ),
                ],
                if (task['DueDate'] != null) ...[
                  const SizedBox(height: 16),
                  _buildDetailSection(
                    'Due Date',
                    _formatDate(task['DueDate']),
                    Icons.event,
                  ),
                ],
                if (task['Priority'] != null) ...[
                  const SizedBox(height: 16),
                  _buildDetailSection(
                    'Priority',
                    task['Priority'].toString(),
                    Icons.priority_high,
                  ),
                ],
                if (task['Location'] != null) ...[
                  const SizedBox(height: 16),
                  _buildDetailSection(
                    'Location',
                    task['Location'].toString(),
                    Icons.location_on,
                  ),
                ],
                const SizedBox(height: 24),
                if (task['Status'] != 'Completed')
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showStatusUpdateDialog(task);
                      },
                      icon: const Icon(Icons.update),
                      label: const Text("Update Status"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[700],
                        foregroundColor: Colors.white,
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
      ),
    );
  }

  Widget _buildDetailSection(String label, String value, IconData icon) {
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

  String _formatDate(dynamic date) {
    try {
      if (date == null) return 'Not set';
      final DateTime dateTime = date is String ? DateTime.parse(date) : date;
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (e) {
      return date.toString();
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

  List get filteredTasks {
    if (selectedFilter == 'All') return tasks;
    return tasks.where((task) => task['Status'] == selectedFilter).toList();
  }

  Map<String, int> get taskStatistics {
    return {
      'Total': tasks.length,
      'Assigned': tasks.where((t) => t['Status'] == 'Assigned').length,
      'In Progress': tasks.where((t) => t['Status'] == 'In Progress').length,
      'Completed': tasks.where((t) => t['Status'] == 'Completed').length,
    };
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return Colors.blue;
      case 'Assigned':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'Completed':
        return Icons.check_circle;
      case 'In Progress':
        return Icons.pending;
      case 'Assigned':
        return Icons.assignment;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "My Tasks",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.purple[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchTasks,
            tooltip: "Refresh",
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Colors.purple[700],
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: statusFilters.map((filter) {
                final count = filter == 'All'
                    ? taskStatistics['Total']
                    : taskStatistics[filter];
                return Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(filter),
                      if (count != null && count > 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            count.toString(),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Statistics Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    taskStatistics['Total']!,
                    Icons.task_alt,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Completed',
                    taskStatistics['Completed']!,
                    Icons.check_circle,
                    Colors.green,
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

  Widget _buildStatCard(String label, int value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
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
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
            const SizedBox(height: 16),
            Text(
              "Loading tasks...",
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
                onPressed: fetchTasks,
                icon: const Icon(Icons.refresh),
                label: const Text("Try Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (filteredTasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.task, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "No Tasks Found",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                selectedFilter == 'All'
                    ? "You don't have any assigned tasks yet."
                    : "No tasks with status: $selectedFilter",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              if (selectedFilter != 'All')
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedFilter = 'All';
                      _tabController.animateTo(0);
                    });
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text("Show All Tasks"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.purple[700],
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) => _buildTaskCard(filteredTasks[index]),
    );
  }

  Widget _buildTaskCard(dynamic task) {
    final status = task['Status']?.toString() ?? 'Unknown';
    final isCompleted = status == 'Completed';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showTaskDetails(task),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getStatusIcon(status),
                      color: _getStatusColor(status),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['TaskName']?.toString() ?? 'Unnamed Task',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[700],
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(status),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                task['TaskDescription']?.toString() ?? 'No description',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (task['DueDate'] != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.event, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      "Due: ${_formatDate(task['DueDate'])}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
              if (!isCompleted) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showStatusUpdateDialog(task),
                    icon: const Icon(Icons.update, size: 18),
                    label: const Text("Update Status"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.purple[700],
                      side: BorderSide(color: Colors.purple[700]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}