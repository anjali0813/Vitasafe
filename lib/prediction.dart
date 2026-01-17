// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/reg_api.dart';

// class FirstAidChatBotPage extends StatefulWidget {
//   const FirstAidChatBotPage({super.key});

//   @override
//   State<FirstAidChatBotPage> createState() => _FirstAidChatBotPageState();
// }

// class _FirstAidChatBotPageState extends State<FirstAidChatBotPage> {
//   final TextEditingController _controller = TextEditingController();
//   final Dio _dio = Dio();

//   List<Map<String, String>> messages = [];

//   final String apiUrl = "$baseurl/bot/"; 
//   // For real device use your system IP

//   @override
//   void initState() {
//     super.initState();
//     fetchChatHistory();
//   }

//   // ---------------- FETCH HISTORY ----------------
//   Future<void> fetchChatHistory() async {
//     try {
//       Response response = await _dio.get('$apiUrl$lid');

//       List history = response.data["history"];

//       setState(() {
//         messages = history.reversed.map<Map<String, String>>((chat) {
//           return {
//             "user": chat["symptoms"],
//             "bot": chat["advice"]
//           };
//         }).toList();
//       });
//     } catch (e) {
//       debugPrint("History error: $e");
//     }
//   }

//   // ---------------- SEND MESSAGE ----------------
//   Future<void> sendMessage() async {
//     if (_controller.text.isEmpty) return;

//     String userMessage = _controller.text;

//     setState(() {
//       messages.add({"user": userMessage});
//     });

//     _controller.clear();

//     try {
//       Response response = await _dio.post(
//         '$apiUrl$lid',
//         data: {"message": userMessage},
//       );
//       print(  response.data);

//       setState(() {
//         messages.add({
//           "bot": response.data["first_aid_advice"]
//         });
//       });
//     } catch (e) {
//       debugPrint("Send error: $e");
//     }
//   }

//   // ---------------- UI ----------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("First Aid Assistant"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 bool isUser = messages[index].containsKey("user");
//                 return Align(
//                   alignment:
//                       isUser ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 5),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: isUser
//                           ? Colors.blueAccent
//                           : Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       isUser
//                           ? messages[index]["user"]!
//                           : messages[index]["bot"]!,
//                       style: TextStyle(
//                         color: isUser ? Colors.white : Colors.black,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // ---------------- INPUT BAR ----------------
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: const InputDecoration(
//                       hintText: "Describe your symptoms...",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: const Icon(Icons.send, color: Colors.redAccent),
//                   onPressed: sendMessage,
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class FirstAidChatBotPage extends StatefulWidget {
  const FirstAidChatBotPage({super.key});

  @override
  State<FirstAidChatBotPage> createState() => _FirstAidChatBotPageState();
}

class _FirstAidChatBotPageState extends State<FirstAidChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final Dio _dio = Dio();
  final _formKey = GlobalKey<FormState>();

  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;
  bool _hasError = false;
  String _errorMessage = '';
  final String _apiUrl = "$baseurl/bot/";

  // Quick symptom suggestions
  final List<String> _quickSymptoms = [
    'Fever and headache',
    'Cough and cold',
    'Stomach pain',
    'Chest pain',
    'Difficulty breathing',
    'Head injury',
    'Burn injury',
    'Allergic reaction',
    'Nausea and vomiting',
    'Joint pain'
  ];

  // First aid categories
  final List<FirstAidCategory> _firstAidCategories = [
    FirstAidCategory(
      title: 'CPR Guide',
      icon: Icons.favorite,
      color: Colors.redAccent,
      description: 'Cardiopulmonary resuscitation steps',
    ),
    FirstAidCategory(
      title: 'Bleeding',
      icon: Icons.bloodtype,
      color: Colors.red,
      description: 'Control severe bleeding',
    ),
    FirstAidCategory(
      title: 'Choking',
      icon: Icons.airline_seat_individual_suite,
      color: Colors.orange,
      description: 'Heimlich maneuver',
    ),
    FirstAidCategory(
      title: 'Burns',
      icon: Icons.fireplace,
      color: Colors.deepOrange,
      description: 'Burn treatment',
    ),
    FirstAidCategory(
      title: 'Fractures',
      icon: Icons.accessible,
      color: Colors.blue,
      description: 'Broken bone care',
    ),
    FirstAidCategory(
      title: 'Poisoning',
      icon: Icons.warning,
      color: Colors.purple,
      description: 'Poison exposure',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchChatHistory();
    _textFieldFocusNode.addListener(() {
      if (_textFieldFocusNode.hasFocus) {
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _textFieldFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchChatHistory() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await _dio.get(
        '$_apiUrl$lid',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final history = response.data["history"] as List;
        setState(() {
          _messages = history.reversed.map<ChatMessage>((chat) {
            return ChatMessage(
              text: chat["symptoms"] ?? '',
              isUser: true,
              timestamp: DateTime.now(),
            );
          }).toList();
          
          // Add bot responses
          for (int i = 0; i < history.length; i++) {
            final chat = history[i];
            if (chat["advice"] != null) {
              _messages.insert(
                i * 2 + 1,
                ChatMessage(
                  text: chat["advice"],
                  isUser: false,
                  timestamp: DateTime.now(),
                ),
              );
            }
          }
          
          _isLoading = false;
        });
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      } else {
        throw Exception('Failed to load chat history');
      }
    } on DioException catch (e) {
      _handleApiError(e);
    } catch (e) {
      _handleGenericError(e.toString());
    }
  }

  void _handleApiError(DioException e) {
    String errorMessage = 'Failed to load chat history';
    
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

  String? _validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please describe your symptoms';
    }
    if (value.trim().length < 3) {
      return 'Please provide more details';
    }
    if (value.trim().length > 500) {
      return 'Message too long (max 500 characters)';
    }
    return null;
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String userMessage = _controller.text.trim();
    
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isSending = true;
      _hasError = false;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      final response = await _dio.post(
        '$_apiUrl$lid',
        data: {"message": userMessage},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final advice = response.data["first_aid_advice"]?.toString() ?? 
                      'I understand your concern. Please provide more details about your symptoms for better assistance.';
        
        setState(() {
          _messages.add(ChatMessage(
            text: advice,
            isUser: false,
            timestamp: DateTime.now(),
            isEmergency: _detectEmergencyKeywords(userMessage),
          ));
          _isSending = false;
        });
        
        _scrollToBottom();
        
        // Check for emergency keywords
        if (_detectEmergencyKeywords(userMessage)) {
          _showEmergencyAlert(context, advice);
        }
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleSendError(e);
    } catch (e) {
      _handleSendErrorGeneric(e.toString());
    }
  }

  bool _detectEmergencyKeywords(String message) {
    final emergencyKeywords = [
      'emergency', 'critical', 'severe', 'unconscious', 'bleeding',
      'chest pain', 'difficulty breathing', 'stroke', 'heart attack',
      'choking', 'burn', 'poison', 'fracture', 'head injury'
    ];
    
    final lowerMessage = message.toLowerCase();
    return emergencyKeywords.any((keyword) => lowerMessage.contains(keyword));
  }

  void _handleSendError(DioException e) {
    String errorMessage = 'Failed to send message';
    
    if (e.response != null) {
      errorMessage = 'Server error: ${e.response!.statusCode}';
    } else if (e.type == DioExceptionType.connectionTimeout) {
      errorMessage = 'Connection timeout. Please check your internet.';
    } else if (e.type == DioExceptionType.connectionError) {
      errorMessage = 'No internet connection.';
    }
    
    setState(() {
      _messages.add(ChatMessage(
        text: 'Sorry, I encountered an error: $errorMessage\n\nPlease try again or describe your symptoms in detail.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _isSending = false;
      _hasError = true;
      _errorMessage = errorMessage;
    });
    
    _scrollToBottom();
  }

  void _handleSendErrorGeneric(String error) {
    setState(() {
      _messages.add(ChatMessage(
        text: 'Sorry, I encountered an error. Please try again.\n\nError: $error',
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _isSending = false;
      _hasError = true;
      _errorMessage = error;
    });
    
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showEmergencyAlert(BuildContext context, String advice) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Text('Emergency Alert'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your symptoms indicate a potential emergency!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(advice),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.phone, color: Colors.red, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'If symptoms are severe, call emergency services immediately at 112',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('I Understand'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement emergency call
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Call 112'),
          ),
        ],
      ),
    );
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Chat History'),
        content: Text('Are you sure you want to clear all chat messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _messages.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Chat cleared'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.medical_services, color: Colors.blue, size: 28),
              SizedBox(width: 10),
              Text(
                'First Aid Assistant',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            'Hello! I\'m your First Aid Assistant. I can help you with:',
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Symptom analysis',
              'First aid guidance',
              'Emergency advice',
              'Health recommendations',
              'Medication reminders',
            ].map((item) => Chip(
              label: Text(item),
              backgroundColor: Colors.blue[100],
            )).toList(),
          ),
          SizedBox(height: 15),
          Text(
            'Please describe your symptoms or health concern below.',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSymptoms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Quick Symptoms',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: _quickSymptoms.map((symptom) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ActionChip(
                  label: Text(symptom),
                  onPressed: () {
                    _controller.text = symptom;
                    _textFieldFocusNode.requestFocus();
                  },
                  backgroundColor: Colors.green[50],
                  labelStyle: TextStyle(color: Colors.green[700]),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFirstAidCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'First Aid Guides',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _firstAidCategories.length,
            itemBuilder: (context, index) {
              final category = _firstAidCategories[index];
              return GestureDetector(
                onTap: () {
                  _controller.text = category.title;
                  _sendMessage();
                },
                child: Container(
                  width: 100,
                  margin: EdgeInsets.only(right: 12),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: category.color.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(category.icon, size: 30, color: category.color),
                      SizedBox(height: 8),
                      Text(
                        category.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: category.color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.medical_services, size: 18, color: Colors.white),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isUser 
                      ? Colors.blueAccent 
                      : message.isEmergency
                        ? Colors.red[50]
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: message.isEmergency
                      ? Border.all(color: Colors.red.withOpacity(0.3))
                      : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.isEmergency && !message.isUser)
                        Row(
                          children: [
                            Icon(Icons.warning, size: 16, color: Colors.red),
                            SizedBox(width: 6),
                            Text(
                              'EMERGENCY ADVICE',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      Text(
                        message.text,
                        style: TextStyle(
                          color: message.isUser ? Colors.white : Colors.grey[800],
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        DateFormat('hh:mm a').format(message.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: message.isUser 
                            ? Colors.white.withOpacity(0.7)
                            : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        _buildWelcomeMessage(),
        _buildQuickSymptoms(),
        _buildFirstAidCategories(),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.redAccent),
          SizedBox(height: 20),
          Text(
            'Unable to Load Chat',
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
            onPressed: _fetchChatHistory,
            icon: Icon(Icons.refresh),
            label: Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
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
          "First Aid Assistant",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.emergency),
            onPressed: () => _showEmergencyAlert(context, 'Emergency assistance needed'),
            tooltip: 'Emergency',
          ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: _clearChat,
            tooltip: 'Clear Chat',
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchChatHistory,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.redAccent),
                        SizedBox(height: 20),
                        Text(
                          'Loading chat history...',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : _hasError && _messages.isEmpty
                    ? _buildErrorState()
                    : _messages.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.only(top: 16),
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              return _buildMessageBubble(_messages[index]);
                            },
                          ),
          ),

          // Quick Symptoms (only when no messages)
          if (_messages.isEmpty && !_isLoading && !_hasError)
            _buildQuickSymptoms(),

          // Input Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      focusNode: _textFieldFocusNode,
                      maxLines: 3,
                      minLines: 1,
                      maxLength: 500,
                      decoration: InputDecoration(
                        hintText: "Describe your symptoms or health concern...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.mic, color: Colors.redAccent),
                          onPressed: () {
                            // Implement voice input
                          },
                        ),
                      ),
                      validator: _validateMessage,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: _isSending
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(Icons.send, color: Colors.white),
                      onPressed: _isSending ? null : _sendMessage,
                      tooltip: 'Send',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _messages.isNotEmpty
          ? FloatingActionButton.small(
              onPressed: _scrollToBottom,
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.arrow_downward, color: Colors.white),
            )
          : null,
    );
  }
}

// Data Models
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isEmergency;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isEmergency = false,
  });
}

class FirstAidCategory {
  final String title;
  final IconData icon;
  final Color color;
  final String description;

  const FirstAidCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });
}