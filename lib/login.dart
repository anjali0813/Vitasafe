// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:vitasafe/fcm_service.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/main.dart';
// import 'package:vitasafe/public.dart';
// import 'package:vitasafe/register.dart';
// import 'package:vitasafe/volunteer_registration.dart';

// class LoginScreen extends StatefulWidget {
//    LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {

//   Future<void> requestPermission() async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   await messaging.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
// }

// void initFCMListeners() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       final alert = message.notification?.body ?? 'Emergency Alert';

//       notificationsPlugin.show(
//   DateTime.now().millisecondsSinceEpoch ~/ 1000,
//   '🚨 VitaSafe Alert',
//   alert,
//   const NotificationDetails(
//     android: AndroidNotificationDetails(
//       'alert_channel',
//       'Alerts',
//       importance: Importance.max,
//       priority: Priority.high,
//     ),
//   ),
// );

//     });
//   }

// //   void sendTokenToBackend(String volunteerId) async {
// //   String? token = await FCMService.getToken();

// //   if (token == null) {
// //     print("❌ FCM token null");
// //     return;
// //   }

// //   print("📱 FCM TOKEN: $token");

// //   await saveVolunteerFCMToken(
// //     volunteerId: volunteerId,
// //     fcmToken: token,
// //   );
// // }



//   TextEditingController username = TextEditingController();

//   TextEditingController password = TextEditingController();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     requestPermission();
//     initFCMListeners();       // start listening
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login Screen'),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 175, 156, 148),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                 controller: username,
//                 decoration: InputDecoration(
//                   labelText: 'Username',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20,),
//               TextFormField(
//                 controller: password,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12)
//                   )
//                 ),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(onPressed: (){
//                 loginuser(username: username.text, password: password.text,context: context);
//               }, child: Text('LOGIN')),
//               TextButton(onPressed: (){
//                 Navigator.push(context,MaterialPageRoute(builder: (context) => RegisterScreen(),));
//               }, child: Text('Do not have an account ! REGISTER')),
//               TextButton(onPressed: (){
//                 Navigator.push(context,MaterialPageRoute(builder: (context) => VolunteerRegistrationPage(),));
//               }, child: Text('Register as volunteer')),
//               TextButton(onPressed: (){
//                 Navigator.push(context,MaterialPageRoute(builder: (context) => AccidentAlertPage(),));
//               }, child: Text('Guest login'))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:vitasafe/login_api.dart';
// import 'package:vitasafe/main.dart';
// import 'package:vitasafe/public.dart';
// import 'package:vitasafe/register.dart';
// import 'package:vitasafe/volunteer_registration.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {

//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController username = TextEditingController();
//   final TextEditingController password = TextEditingController();

//   bool isLoading = false;
//   bool hidePassword = true;

//   @override
//   void initState() {
//     super.initState();
//     requestPermission();
//     initFCMListeners();
//   }

//   /// 🔔 Notification permission
//   Future<void> requestPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     await messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }

//   /// 🔔 FCM listener
//   void initFCMListeners() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       final alert = message.notification?.body ?? 'Emergency Alert';

//       notificationsPlugin.show(
//         DateTime.now().millisecondsSinceEpoch ~/ 1000,
//         '🚨 VitaSafe Alert',
//         alert,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'alert_channel',
//             'Alerts',
//             importance: Importance.max,
//             priority: Priority.high,
//           ),
//         ),
//       );
//     });
//   }

//   /// 🔐 Login validation handler
//   void handleLogin() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() => isLoading = true);

//     await loginuser(
//       username: username.text.trim(),
//       password: password.text.trim(),
//       context: context,
//     );

//     setState(() => isLoading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFFfbc2eb),
//               Color(0xFFa6c1ee),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Card(
//               elevation: 10,
//               margin: const EdgeInsets.symmetric(horizontal: 24),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [

//                       // 🔷 Logo
//                       const Icon(
//                         Icons.health_and_safety,
//                         size: 80,
//                         color: Colors.redAccent,
//                       ),

//                       const SizedBox(height: 10),

//                       const Text(
//                         "VitaSafe",
//                         style: TextStyle(
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),

//                       const SizedBox(height: 5),

//                       const Text(
//                         "Emergency Health & Safety App",
//                         style: TextStyle(color: Colors.grey),
//                       ),

//                       const SizedBox(height: 30),

//                       // 👤 Username
//                       TextFormField(
//                         controller: username,
//                         keyboardType: TextInputType.text,
//                         decoration: InputDecoration(
//                           prefixIcon: const Icon(Icons.person),
//                           labelText: 'Username',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             return "Username is required";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 20),

//                       // 🔐 Password
//                       TextFormField(
//                         controller: password,
//                         obscureText: hidePassword,
//                         decoration: InputDecoration(
//                           prefixIcon: const Icon(Icons.lock),
//                           labelText: 'Password',
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               hidePassword
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 hidePassword = !hidePassword;
//                               });
//                             },
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Password is required";
//                           }
//                           if (value.length < 6) {
//                             return "Password must be at least 6 characters";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 30),

//                       // 🔴 Login Button
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.redAccent,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                           onPressed: isLoading ? null : handleLogin,
//                           child: isLoading
//                               ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                               : const Text(
//                                   "LOGIN",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       // 🔗 Navigation links
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => RegisterScreen(),
//                             ),
//                           );
//                         },
//                         child: const Text("Don't have an account? Register"),
//                       ),

//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   VolunteerRegistrationPage(),
//                             ),
//                           );
//                         },
//                         child: const Text("Register as Volunteer"),
//                       ),

//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AccidentAlertPage(),
//                             ),
//                           );
//                         },
//                         child: const Text("Continue as Guest"),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/main.dart';
import 'package:vitasafe/public.dart';
import 'package:vitasafe/register.dart';
import 'package:vitasafe/volunteer_registration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Form state
  bool _isLoading = false;
  bool _hidePassword = true;
  bool _rememberMe = false;
  bool _showPasswordStrength = false;
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.grey;
  String? _loginError;

  // Focus nodes
  final List<FocusNode> _focusNodes = List.generate(2, (index) => FocusNode());

  // Demo accounts for testing
  final List<Map<String, String>> _demoAccounts = [
    {'username': 'patient@vitasafe.com', 'password': 'Patient123', 'role': 'Patient'},
    {'username': 'volunteer@vitasafe.com', 'password': 'Volunteer123', 'role': 'Volunteer'},
    {'username': 'admin@vitasafe.com', 'password': 'Admin123', 'role': 'Admin'},
  ];

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_calculatePasswordStrength);
    _initializeLogin();
    _requestPermissions();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _initializeLogin() {
    // Load saved credentials if "Remember Me" was checked previously
    // You can implement SharedPreferences here
    // Example: _usernameController.text = prefs.getString('username') ?? '';
    // _passwordController.text = prefs.getString('password') ?? '';
    // _rememberMe = prefs.getBool('rememberMe') ?? false;
  }

  Future<void> _requestPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _initFCMListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final alert = message.notification?.body ?? 'Emergency Alert';

      notificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        '🚨 VitaSafe Alert',
        alert,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'alert_channel',
            'Alerts',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    });
  }

  void _calculatePasswordStrength() {
    final password = _passwordController.text;
    double strength = 0.0;
    String text = '';
    Color color = Colors.grey;

    if (password.isNotEmpty) {
      // Length check
      if (password.length >= 8) strength += 0.2;
      
      // Upper case check
      if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.2;
      
      // Lower case check
      if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.2;
      
      // Number check
      if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.2;
      
      // Special character check
      if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.2;
    }

    setState(() {
      _passwordStrength = strength;
      _showPasswordStrength = password.isNotEmpty;
      
      if (strength < 0.4) {
        text = 'Weak';
        color = Colors.red;
      } else if (strength < 0.7) {
        text = 'Fair';
        color = Colors.orange;
      } else if (strength < 0.9) {
        text = 'Good';
        color = Colors.blue;
      } else {
        text = 'Strong';
        color = Colors.green;
      }
      
      _passwordStrengthText = text;
      _passwordStrengthColor = color;
    });
  }

  // Validations
  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username or Email is required';
    }
    
    // Check if it's an email
    if (value.contains('@')) {
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        caseSensitive: false,
      );
      if (!emailRegex.hasMatch(value.trim())) {
        return 'Please enter a valid email address';
      }
    } else {
      // Check if it's a valid username
      if (value.trim().length < 3) {
        return 'Username must be at least 3 characters';
      }
      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
        return 'Username can only contain letters, numbers and underscore';
      }
    }
    
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _loginError = null;
    });

    try {
      // Save credentials if "Remember Me" is checked
      if (_rememberMe) {
        // Implement SharedPreferences here
        // await prefs.setString('username', _usernameController.text.trim());
        // await prefs.setString('password', _passwordController.text.trim());
        // await prefs.setBool('rememberMe', true);
      }

      // Call your login API
      await loginuser(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        context: context,
      );
    } catch (e) {
      setState(() {
        _loginError = 'Invalid credentials. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleDemoLogin(int index) {
    final account = _demoAccounts[index];
    setState(() {
      _usernameController.text = account['username']!;
      _passwordController.text = account['password']!;
    });
    
    // Show a snackbar indicating demo mode
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Demo ${account['role']} account loaded'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Password'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter your email address to receive a password reset link.',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Password reset link sent to your email'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: Text('Send Link'),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    if (!_showPasswordStrength) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: _passwordStrength,
          backgroundColor: Colors.grey[200],
          color: _passwordStrengthColor,
          minHeight: 4,
        ),
        SizedBox(height: 4),
        Text(
          'Password Strength: $_passwordStrengthText',
          style: TextStyle(
            fontSize: 12,
            color: _passwordStrengthColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDemoAccounts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Demo Accounts (for testing)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(_demoAccounts.length, (index) {
            final account = _demoAccounts[index];
            return ElevatedButton(
              onPressed: () => _handleDemoLogin(index),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withOpacity(0.1),
                foregroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: Text(account['role']!),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required FocusNode focusNode,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? helperText,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: (_) {
            if (_loginError != null) {
              setState(() => _loginError = null);
            }
          },
          decoration: InputDecoration(
            hintText: helperText,
            prefixIcon: icon != null ? Icon(icon, size: 22) : null,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.redAccent, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade800,
              Colors.red.shade400,
              Colors.red.shade200,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Form Container
              Expanded(
                child: Card(
                  margin: EdgeInsets.all(16),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Logo and Welcome Text
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.health_and_safety,
                                    size: 80,
                                    color: Colors.redAccent,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "VitaSafe",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Emergency Health & Safety App",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            SizedBox(height: 30),
                            
                            // Error Message
                            if (_loginError != null)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline, color: Colors.red, size: 20),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _loginError!,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            SizedBox(height: _loginError != null ? 16 : 0),
                            
                            // Login Form
                            Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            SizedBox(height: 20),
                            
                            // Username/Email Field
                            _buildFormField(
                              label: 'Username or Email',
                              controller: _usernameController,
                              validator: _validateUsername,
                              focusNode: _focusNodes[0],
                              icon: Icons.person_outline,
                              helperText: 'Enter your email',
                            ),
                            
                            // Password Field
                            _buildFormField(
                              label: 'Password',
                              controller: _passwordController,
                              validator: _validatePassword,
                              focusNode: _focusNodes[1],
                              icon: Icons.lock_outline,
                              obscureText: _hidePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _hidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() => _hidePassword = !_hidePassword);
                                },
                              ),
                              helperText: 'At least 6 characters',
                            ),
                            
                            // Password Strength Indicator
                            _buildPasswordStrengthIndicator(),
                            
                            // Remember Me & Forgot Password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() => _rememberMe = value ?? false);
                                      },
                                      activeColor: Colors.redAccent,
                                    ),
                                    Text(
                                      'Remember Me',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: _handleForgotPassword,
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 20),
                            
                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 4,
                                  shadowColor: Colors.redAccent.withOpacity(0.5),
                                ),
                                child: _isLoading
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Text('Signing In...'),
                                        ],
                                      )
                                    : Text(
                                        'SIGN IN',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            
                            SizedBox(height: 20),
                            
                            // // Or Continue With
                            // Row(
                            //   children: [
                            //     Expanded(child: Divider()),
                            //     Padding(
                            //       padding: const EdgeInsets.symmetric(horizontal: 16),
                            //       child: Text(
                            //         'or continue with',
                            //         style: TextStyle(
                            //           color: Colors.grey[600],
                            //           fontSize: 14,
                            //         ),
                            //       ),
                            //     ),
                            //     Expanded(child: Divider()),
                            //   ],
                            // ),
                            
                            // SizedBox(height: 20),
                            
                            // // Demo Accounts
                            // _buildDemoAccounts(),
                            
                            // SizedBox(height: 30),
                            
                            // // Divider
                            // Divider(),
                            
                            // SizedBox(height: 20),
                            
                            // Sign Up Options
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 16),
                            
                            // Regular Registration
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterScreen(),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide(color: Colors.redAccent),
                                ),
                                child: Text(
                                  'Register as User',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 12),
                            
                            // Volunteer Registration
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VolunteerRegistrationPage(),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide(color: Colors.blue),
                                ),
                                child: Text(
                                  'Register as Volunteer',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 12),
                            
                            // Guest Access
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AccidentAlertPage(),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide(color: Colors.green),
                                ),
                                child: Text(
                                  'Continue as Guest',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 30),
                            
                            // Terms and Privacy
                            Center(
                              child: Text(
                                'By signing in, you agree to our Terms of Service and Privacy Policy',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
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