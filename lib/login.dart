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

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool isLoading = false;
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
    requestPermission();
    initFCMListeners();
  }

  /// 🔔 Notification permission
  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// 🔔 FCM listener
  void initFCMListeners() {
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

  /// 🔐 Login validation handler
  void handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => isLoading = true);

    await loginuser(
      username: username.text.trim(),
      password: password.text.trim(),
      context: context,
    );

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFfbc2eb),
              Color(0xFFa6c1ee),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 10,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // 🔷 Logo
                      const Icon(
                        Icons.health_and_safety,
                        size: 80,
                        color: Colors.redAccent,
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "VitaSafe",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "Emergency Health & Safety App",
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 30),

                      // 👤 Username
                      TextFormField(
                        controller: username,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Username is required";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // 🔐 Password
                      TextFormField(
                        controller: password,
                        obscureText: hidePassword,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      // 🔴 Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: isLoading ? null : handleLogin,
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔗 Navigation links
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text("Don't have an account? Register"),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VolunteerRegistrationPage(),
                            ),
                          );
                        },
                        child: const Text("Register as Volunteer"),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccidentAlertPage(),
                            ),
                          );
                        },
                        child: const Text("Continue as Guest"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
