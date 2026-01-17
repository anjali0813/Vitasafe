// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> init() async {
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings settings =
//         InitializationSettings(android: androidSettings);

//     await _notificationsPlugin.initialize(settings);
//   }

//   static Future<void> showNotification({
//     required String title,
//     required String body,
//   }) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'alert_channel',
//       'Alerts',
//       channelDescription: 'Channel for urgent alerts',
//       importance: Importance.high,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );

//     const NotificationDetails platformDetails =
//         NotificationDetails(android: androidDetails);

//     await _notificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformDetails,
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationTestPage extends StatefulWidget {
  const NotificationTestPage({super.key});

  @override
  State<NotificationTestPage> createState() => _NotificationTestPageState();
}

class _NotificationTestPageState extends State<NotificationTestPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  
  bool isInitialized = false;
  bool isSending = false;
  String selectedPriority = 'High';
  String selectedCategory = 'Alert';
  
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final List<String> priorityLevels = ['Low', 'Default', 'High', 'Max'];
  final List<String> categories = [
    'Alert',
    'Emergency',
    'Information',
    'Warning',
    'Reminder',
    'Update'
  ];

  List<Map<String, dynamic>> notificationHistory = [];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  Future<void> _initializeNotifications() async {
    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      const InitializationSettings settings =
          InitializationSettings(android: androidSettings);

      final bool? initialized = await _notificationsPlugin.initialize(
        settings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notification clicked: ${response.payload}');
        },
      );

      setState(() => isInitialized = initialized ?? false);

      if (isInitialized) {
        _showSnackBar('Notifications initialized successfully', Colors.green);
      } else {
        _showSnackBar('Failed to initialize notifications', Colors.red);
      }
    } catch (e) {
      setState(() => isInitialized = false);
      _showSnackBar('Error: ${e.toString()}', Colors.red);
    }
  }

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!isInitialized) {
      _showSnackBar('Notifications not initialized. Please restart the app.', Colors.orange);
      return;
    }

    setState(() => isSending = true);

    try {
      final importance = _getImportance(selectedPriority);
      final priority = _getPriority(selectedPriority);

      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        '${selectedCategory.toLowerCase()}_channel',
        selectedCategory,
        channelDescription: 'Channel for $selectedCategory notifications',
        importance: importance,
        priority: priority,
        ticker: 'ticker',
        icon: '@mipmap/ic_launcher',
        color: _getCategoryColor(selectedCategory),
        playSound: true,
        enableVibration: true,
        styleInformation: BigTextStyleInformation(
          bodyController.text,
          contentTitle: titleController.text,
        ),
      );

      final NotificationDetails platformDetails =
          NotificationDetails(android: androidDetails);

      await _notificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        titleController.text,
        bodyController.text,
        platformDetails,
        payload: 'notification_payload',
      );

      // Add to history
      setState(() {
        notificationHistory.insert(0, {
          'title': titleController.text,
          'body': bodyController.text,
          'priority': selectedPriority,
          'category': selectedCategory,
          'time': DateTime.now(),
        });
        
        // Keep only last 10 notifications
        if (notificationHistory.length > 10) {
          notificationHistory.removeLast();
        }
      });

      _showSnackBar('Notification sent successfully!', Colors.green);
      _clearForm();
    } catch (e) {
      _showSnackBar('Error sending notification: ${e.toString()}', Colors.red);
    } finally {
      setState(() => isSending = false);
    }
  }

  Importance _getImportance(String priority) {
    switch (priority) {
      case 'Max':
        return Importance.max;
      case 'High':
        return Importance.high;
      case 'Default':
        return Importance.defaultImportance;
      case 'Low':
        return Importance.low;
      default:
        return Importance.defaultImportance;
    }
  }

  Priority _getPriority(String priority) {
    switch (priority) {
      case 'Max':
        return Priority.max;
      case 'High':
        return Priority.high;
      case 'Default':
        return Priority.defaultPriority;
      case 'Low':
        return Priority.low;
      default:
        return Priority.defaultPriority;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Emergency':
        return Colors.red;
      case 'Alert':
        return Colors.orange;
      case 'Warning':
        return Colors.amber;
      case 'Information':
        return Colors.blue;
      case 'Update':
        return Colors.green;
      case 'Reminder':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Emergency':
        return Icons.emergency;
      case 'Alert':
        return Icons.warning_amber;
      case 'Warning':
        return Icons.error_outline;
      case 'Information':
        return Icons.info_outline;
      case 'Update':
        return Icons.update;
      case 'Reminder':
        return Icons.notifications_active;
      default:
        return Icons.notifications;
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

  void _clearForm() {
    titleController.clear();
    bodyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Notification Manager",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.indigo[700],
        foregroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isInitialized ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  isInitialized ? Icons.check_circle : Icons.error,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  isInitialized ? 'Active' : 'Inactive',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo[700]!, Colors.indigo[500]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_active,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Send Test Notification",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Create and send custom notifications to test your app",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Form Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Selection
                    _buildSectionTitle("Notification Category *"),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCategory,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.indigo[700]),
                          items: categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Row(
                                children: [
                                  Icon(
                                    _getCategoryIcon(category),
                                    size: 20,
                                    color: _getCategoryColor(category),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(category),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() => selectedCategory = newValue!);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Title Field
                    _buildSectionTitle("Notification Title *"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: titleController,
                      maxLength: 50,
                      decoration: _buildInputDecoration(
                        labelText: "Enter notification title",
                        hintText: "e.g., Emergency Alert",
                        prefixIcon: Icons.title,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title is required';
                        }
                        if (value.trim().length < 3) {
                          return 'Title must be at least 3 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Body Field
                    _buildSectionTitle("Notification Message *"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: bodyController,
                      maxLines: 4,
                      maxLength: 200,
                      decoration: _buildInputDecoration(
                        labelText: "Enter notification message",
                        hintText: "Describe the notification content...",
                        prefixIcon: Icons.message,
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Message is required';
                        }
                        if (value.trim().length < 5) {
                          return 'Message must be at least 5 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Priority Selection
                    _buildSectionTitle("Priority Level *"),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          _buildPriorityOption('Low', 'Minimal importance'),
                          Divider(height: 1, color: Colors.grey[300]),
                          _buildPriorityOption('Default', 'Normal priority'),
                          Divider(height: 1, color: Colors.grey[300]),
                          _buildPriorityOption('High', 'Important notification'),
                          Divider(height: 1, color: Colors.grey[300]),
                          _buildPriorityOption('Max', 'Critical alert'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Preview Card
                    _buildSectionTitle("Preview"),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getCategoryIcon(selectedCategory),
                                color: _getCategoryColor(selectedCategory),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  titleController.text.isEmpty
                                      ? 'Notification Title'
                                      : titleController.text,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(selectedPriority),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  selectedPriority,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            bodyController.text.isEmpty
                                ? 'Notification message will appear here...'
                                : bodyController.text,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Just now',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Send Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: (isSending || !isInitialized) ? null : _sendNotification,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[700],
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[400],
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isSending
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Sending...",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.send, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    !isInitialized
                                        ? "Service Not Available"
                                        : "Send Notification",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Clear Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: _clearForm,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.indigo[700],
                          side: BorderSide(color: Colors.indigo[700]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Clear Form"),
                      ),
                    ),

                    // Notification History
                    if (notificationHistory.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionTitle("Recent Notifications"),
                          TextButton(
                            onPressed: () {
                              setState(() => notificationHistory.clear());
                            },
                            child: const Text("Clear All"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...notificationHistory.map((notification) {
                        return _buildHistoryCard(notification);
                      }).toList(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      alignLabelWithHint: alignLabelWithHint,
      prefixIcon: Icon(prefixIcon, color: Colors.indigo[700]),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.indigo[700]!, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildPriorityOption(String level, String description) {
    final isSelected = selectedPriority == level;
    final color = _getPriorityColor(level);

    return InkWell(
      onTap: () => setState(() => selectedPriority = level),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? color : Colors.grey[400]!,
                  width: 2,
                ),
                color: isSelected ? color : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? color : Colors.grey[800],
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Max':
        return Colors.red;
      case 'High':
        return Colors.orange;
      case 'Default':
        return Colors.blue;
      case 'Low':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Widget _buildHistoryCard(Map<String, dynamic> notification) {
    final DateTime time = notification['time'];
    final String timeAgo = _getTimeAgo(time);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getCategoryIcon(notification['category']),
                  size: 16,
                  color: _getCategoryColor(notification['category']),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    notification['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(notification['priority']),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    notification['priority'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              notification['body'],
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              timeAgo,
              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime time) {
    final Duration diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}