import 'package:flutter/material.dart';
import 'package:vitasafe/bedbookinghistory.dart';
import 'package:vitasafe/bloodrequest.dart';
import 'package:vitasafe/complaint.dart';
import 'package:vitasafe/doctorbookinghistory.dart';
import 'package:vitasafe/hospitalview.dart';
import 'package:vitasafe/login.dart';
import 'package:vitasafe/prediction.dart';
import 'package:vitasafe/userviewvolunteers.dart';
import 'package:vitasafe/vehiclebookinghistory.dart';
import 'package:vitasafe/viewhospitalbed.dart';
import 'package:vitasafe/viewhospitalsambulance.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});



  void _onTapFeature(BuildContext context, String feature) {
  Widget? targetPage;

  switch (feature) {
    case 'Book Vehicle':
      targetPage = const NearbyhospitalAmbulance();
      break;

    case 'Book Doctor':
      targetPage = const HospitalView();
      break;

    case 'Book Bed':
      targetPage = const HospitalView();
      break;

    case 'View doctor booking history':
      targetPage = const DoctorBookingHistoryPage();
      break;

    case 'View vehicle booking history':
      targetPage = const VehicleBookingHistoryPage();
      break;

    case 'View bed booking history':
      targetPage = const BedBookingHistoryPage();
      break;

    case 'Complaints':
      targetPage = ComplaintPage();
      break;

    case 'Notifications':
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opening Notifications...')),
      );
      return;

    case 'Nearby Volunteers':
    targetPage = const NearbyVolunteersPage();
    break;

    case 'Blood request':
    targetPage =  BloodRequestForm();
    break;
    case 'Predict Disease':
      targetPage =  FirstAidChatBotPage();
      break;

    default:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tapped: $feature')),
      );
      return;
  }

 Navigator.push(context, MaterialPageRoute(builder: (_) => targetPage!));
}


  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
  ) {
    return GestureDetector(
      onTap: () => _onTapFeature(context, title),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: color.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentBooking(String title, String subtitle, IconData icon) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyBook Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _onTapFeature(context, 'Notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            ),
          ),
        ],
      ),
  
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, User 👋',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'What would you like to do today?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // --- Feature Cards ---
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 16,
              children: [
                _buildFeatureCard(
                  context,
                  Icons.directions_car,
                  'Book Vehicle',
                  Colors.teal,
                ),
                _buildFeatureCard(
                  context,
                  Icons.local_hospital,
                  'Book Doctor',
                  Colors.indigo,
                ),
                _buildFeatureCard(
                  context,
                  Icons.history,
                  'Book Bed',
                  Colors.orange,
                ),

                _buildFeatureCard(
                  context,
                  Icons.history,
                  'View doctor booking history',
                  Colors.yellow,
                ),
                _buildFeatureCard(
                  context,
                  Icons.history,
                  'View vehicle booking history',
                  Colors.orange,
                ),
                _buildFeatureCard(
                  context,
                  Icons.history,
                  'View bed booking history',
                  Colors.orange,
                ),
                _buildFeatureCard(
                  context,
                  Icons.history,
                  'Complaints',
                  Colors.orange,
                ),
                // _buildFeatureCard(
                //   context,
                //   Icons.warning,
                //   'View Alert',
                //   Colors.black,
                // ),
                _buildFeatureCard(context, Icons.bloodtype, 'Blood request', Colors.red),
                _buildFeatureCard(
                  context,
                  Icons.chat,
                  'Predict Disease',
                  Colors.blue,
                ),
                _buildFeatureCard(
                  context,
                  Icons.volunteer_activism,
                  'Nearby Volunteers',
                  Colors.green,
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:vitasafe/bedbookinghistory.dart';
// import 'package:vitasafe/bloodrequest.dart';
// import 'package:vitasafe/complaint.dart';
// import 'package:vitasafe/doctorbookinghistory.dart';
// import 'package:vitasafe/hospitalview.dart';
// import 'package:vitasafe/login.dart';
// import 'package:vitasafe/prediction.dart';
// import 'package:vitasafe/userviewvolunteers.dart';
// import 'package:vitasafe/vehiclebookinghistory.dart';
// import 'package:vitasafe/viewhospitalbed.dart';
// import 'package:vitasafe/viewhospitalsambulance.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   final List<RecentBooking> _recentBookings = const [
//     RecentBooking(
//       title: 'Doctor Appointment',
//       subtitle: 'Dr. Smith - Cardiology',
//       date: '2024-01-15',
//       icon: Icons.medical_services,
//       status: 'Confirmed',
//       color: Colors.blue,
//     ),
//     RecentBooking(
//       title: 'Ambulance Booking',
//       subtitle: 'Emergency Transfer',
//       date: '2024-01-14',
//       icon: Icons.local_hospital,
//       status: 'Completed',
//       color: Colors.green,
//     ),
//     RecentBooking(
//       title: 'Hospital Bed',
//       subtitle: 'ICU Bed - City Hospital',
//       date: '2024-01-13',
//       icon: Icons.bed,
//       status: 'Pending',
//       color: Colors.orange,
//     ),
//   ];

//   final List<QuickAction> _quickActions = const [
//     QuickAction(
//       title: 'Emergency\nCall',
//       icon: Icons.emergency,
//       color: Colors.red,
//       feature: 'Emergency Call',
//     ),
//     QuickAction(
//       title: 'First Aid\nGuide',
//       icon: Icons.medical_services,
//       color: Colors.green,
//       feature: 'First Aid',
//     ),
//     QuickAction(
//       title: 'Nearest\nHospital',
//       icon: Icons.local_hospital,
//       color: Colors.blue,
//       feature: 'Nearest Hospital',
//     ),
//     QuickAction(
//       title: 'Health\nTips',
//       icon: Icons.health_and_safety,
//       color: Colors.purple,
//       feature: 'Health Tips',
//     ),
//   ];

//   final List<DashboardFeature> _dashboardFeatures = const [
//     DashboardFeature(
//       title: 'Book Vehicle',
//       subtitle: 'Ambulance booking',
//       icon: Icons.airport_shuttle,
//       color: Colors.teal,
//       route: NearbyhospitalAmbulance(),
//     ),
//     DashboardFeature(
//       title: 'Book Doctor',
//       subtitle: 'Doctor appointments',
//       icon: Icons.medical_services,
//       color: Colors.indigo,
//       route: HospitalView(),
//     ),
//     DashboardFeature(
//       title: 'Book Bed',
//       subtitle: 'Hospital bed booking',
//       icon: Icons.bed,
//       color: Colors.orange,
//       route: NearbyhospitalBed(),
//     ),
//     DashboardFeature(
//       title: 'Doctor History',
//       subtitle: 'Appointment records',
//       icon: Icons.history,
//       color: Colors.blue,
//       route: DoctorBookingHistoryPage(),
//     ),
//     DashboardFeature(
//       title: 'Vehicle History',
//       subtitle: 'Ambulance bookings',
//       icon: Icons.history,
//       color: Colors.teal,
//       route: VehicleBookingHistoryPage(),
//     ),
//     DashboardFeature(
//       title: 'Bed History',
//       subtitle: 'Bed booking records',
//       icon: Icons.history,
//       color: Colors.orange,
//       route: BedBookingHistoryPage(),
//     ),
//     DashboardFeature(
//       title: 'Complaints',
//       subtitle: 'Submit complaints',
//       icon: Icons.report_problem,
//       color: Colors.red,
//       route: ComplaintPage(),
//     ),
//     DashboardFeature(
//       title: 'Blood Request',
//       subtitle: 'Request blood',
//       icon: Icons.bloodtype,
//       color: Colors.redAccent,
//       route: BloodRequestForm(),
//     ),
//     DashboardFeature(
//       title: 'Predict Disease',
//       subtitle: 'AI health assistant',
//       icon: Icons.chat,
//       color: Colors.blueAccent,
//       route: FirstAidChatBotPage(),
//     ),
//     DashboardFeature(
//       title: 'Nearby Volunteers',
//       subtitle: 'Find volunteers',
//       icon: Icons.volunteer_activism,
//       color: Colors.green,
//       route: NearbyVolunteersPage(),
//     ),
//   ];

//   void _onTapFeature(BuildContext context, DashboardFeature feature) {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) => feature.route,
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           const begin = Offset(0.0, 0.0);
//           const end = Offset.zero;
//           const curve = Curves.easeInOut;
//           var tween = Tween(begin: begin, end: end)
//               .chain(CurveTween(curve: curve));
//           return SlideTransition(
//             position: animation.drive(tween),
//             child: child,
//           );
//         },
//       ),
//     );
//   }

//   void _onQuickAction(BuildContext context, QuickAction action) {
//     switch (action.feature) {
//       case 'Emergency Call':
//         _makeEmergencyCall(context);
//         break;
//       case 'First Aid':
//         _showFirstAidGuide(context);
//         break;
//       case 'Nearest Hospital':
//         _findNearestHospital(context);
//         break;
//       case 'Health Tips':
//         _showHealthTips(context);
//         break;
//     }
//   }

//   void _makeEmergencyCall(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(Icons.emergency, color: Colors.red),
//             SizedBox(width: 10),
//             Text('Emergency Call'),
//           ],
//         ),
//         content: Text('Call emergency services at 112?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Connecting to emergency services...'),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//               // Implement actual call here
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//             ),
//             child: Text('Call Now'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showFirstAidGuide(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(title: Text('First Aid Guide')),
//           body: ListView(
//             padding: EdgeInsets.all(16),
//             children: [
//               _buildFirstAidStep('1. Check Scene Safety', Icons.security),
//               _buildFirstAidStep('2. Call for Help', Icons.phone),
//               _buildFirstAidStep('3. Check Responsiveness', Icons.person),
//               _buildFirstAidStep('4. Open Airway', Icons.airline_seat_recline_extra),
//               _buildFirstAidStep('5. Check Breathing', Icons.air),
//               _buildFirstAidStep('6. Perform CPR if Needed', Icons.favorite),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFirstAidStep(String text, IconData icon) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 10),
//       child: ListTile(
//         leading: Icon(icon, color: Colors.teal),
//         title: Text(text),
//       ),
//     );
//   }

//   void _findNearestHospital(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Finding nearest hospitals...'),
//         backgroundColor: Colors.blue,
//       ),
//     );
//     // Implement hospital finding logic
//   }

//   void _showHealthTips(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       builder: (context) => Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Daily Health Tips',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             _buildHealthTip('Drink 8 glasses of water daily', Icons.water_drop),
//             _buildHealthTip('Get 7-8 hours of sleep', Icons.bedtime),
//             _buildHealthTip('30 minutes exercise daily', Icons.directions_run),
//             _buildHealthTip('Eat balanced meals', Icons.restaurant),
//             SizedBox(height: 20),
//             OutlinedButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Close'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHealthTip(String text, IconData icon) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.green),
//       title: Text(text),
//     );
//   }

//   Widget _buildQuickActionCard(QuickAction action, BuildContext context) {
//     return GestureDetector(
//       onTap: () => _onQuickAction(context, action),
//       child: Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Container(
//           width: 80,
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: action.color.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   action.icon,
//                   color: action.color,
//                   size: 28,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 action.title,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey[700],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFeatureCard(DashboardFeature feature, BuildContext context) {
//     return GestureDetector(
//       onTap: () => _onTapFeature(context, feature),
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: feature.color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   feature.icon,
//                   color: feature.color,
//                   size: 30,
//                 ),
//               ),
//               SizedBox(height: 12),
//               Text(
//                 feature.title,
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               SizedBox(height: 4),
//               Text(
//                 feature.subtitle,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRecentBookingCard(RecentBooking booking) {
//     return Card(
//       elevation: 2,
//       margin: EdgeInsets.only(bottom: 10),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         leading: Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: booking.color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(
//             booking.icon,
//             color: booking.color,
//             size: 24,
//           ),
//         ),
//         title: Text(
//           booking.title,
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 15,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(booking.subtitle),
//             SizedBox(height: 4),
//             Row(
//               children: [
//                 Icon(Icons.calendar_today, size: 12, color: Colors.grey),
//                 SizedBox(width: 4),
//                 Text(
//                   booking.date,
//                   style: TextStyle(fontSize: 11, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         trailing: Container(
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           decoration: BoxDecoration(
//             color: _getStatusColor(booking.status),
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Text(
//             booking.status,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 10,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'confirmed':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'completed':
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentDate = DateFormat('EEEE, MMMM d').format(DateTime.now());
    
//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'VitaSafe Health',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             Text(
//               currentDate,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.white.withOpacity(0.8),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.teal,
//         foregroundColor: Colors.white,
//         elevation: 4,
//         centerTitle: false,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications_active),
//             onPressed: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('You have 3 new notifications'),
//                   backgroundColor: Colors.teal,
//                 ),
//               );
//             },
//             tooltip: 'Notifications',
//           ),
//           PopupMenuButton<String>(
//             icon: Icon(Icons.more_vert),
//             onSelected: (value) {
//               switch (value) {
//                 case 'logout':
//                   _confirmLogout(context);
//                   break;
//                 case 'profile':
//                   _showProfile(context);
//                   break;
//                 case 'settings':
//                   _showSettings(context);
//                   break;
//                 case 'help':
//                   _showHelp(context);
//                   break;
//               }
//             },
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 value: 'profile',
//                 child: Row(
//                   children: [
//                     Icon(Icons.person, size: 20),
//                     SizedBox(width: 10),
//                     Text('My Profile'),
//                   ],
//                 ),
//               ),
//               PopupMenuItem(
//                 value: 'settings',
//                 child: Row(
//                   children: [
//                     Icon(Icons.settings, size: 20),
//                     SizedBox(width: 10),
//                     Text('Settings'),
//                   ],
//                 ),
//               ),
//               PopupMenuItem(
//                 value: 'help',
//                 child: Row(
//                   children: [
//                     Icon(Icons.help_outline, size: 20),
//                     SizedBox(width: 10),
//                     Text('Help & Support'),
//                   ],
//                 ),
//               ),
//               PopupMenuDivider(),
//               PopupMenuItem(
//                 value: 'logout',
//                 child: Row(
//                   children: [
//                     Icon(Icons.logout, size: 20, color: Colors.red),
//                     SizedBox(width: 10),
//                     Text(
//                       'Logout',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       drawer: _buildDrawer(context),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.teal.withOpacity(0.05),
//               Colors.white,
//             ],
//           ),
//         ),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Welcome Card
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 30,
//                         backgroundColor: Colors.teal.withOpacity(0.1),
//                         child: Icon(
//                           Icons.person,
//                           size: 35,
//                           color: Colors.teal,
//                         ),
//                       ),
//                       SizedBox(width: 15),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Welcome back, User! 👋',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.grey[800],
//                               ),
//                             ),
//                             SizedBox(height: 5),
//                             Text(
//                               'How can we assist you today?',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               SizedBox(height: 20),

//               // Quick Actions
//               Text(
//                 'Quick Actions',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               SizedBox(height: 10),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: _quickActions
//                       .map((action) => Padding(
//                             padding: const EdgeInsets.only(right: 10),
//                             child: _buildQuickActionCard(action, context),
//                           ))
//                       .toList(),
//                 ),
//               ),

//               SizedBox(height: 25),

//               // Recent Bookings
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Recent Bookings',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[800],
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       // View all bookings
//                     },
//                     child: Text(
//                       'View All',
//                       style: TextStyle(color: Colors.teal),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               ..._recentBookings
//                   .map((booking) => _buildRecentBookingCard(booking))
//                   .toList(),

//               SizedBox(height: 25),

//               // All Features
//               Text(
//                 'All Features',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               SizedBox(height: 10),
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 1.1,
//                 ),
//                 itemCount: _dashboardFeatures.length,
//                 itemBuilder: (context, index) {
//                   final feature = _dashboardFeatures[index];
//                   return _buildFeatureCard(feature, context);
//                 },
//               ),

//               SizedBox(height: 20),

//               // Emergency Section
//               Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.red.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: Colors.red.withOpacity(0.2)),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.emergency, size: 30, color: Colors.red),
//                     SizedBox(width: 15),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Emergency Assistance',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.red,
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             'Need immediate help? Use emergency features',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: () => _makeEmergencyCall(context),
//                       icon: Icon(Icons.phone, size: 18),
//                       label: Text('Call 112'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNavigationBar(context),
//     );
//   }

//   Widget _buildDrawer(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           UserAccountsDrawerHeader(
//             accountName: Text('John Doe'),
//             accountEmail: Text('john.doe@example.com'),
//             currentAccountPicture: CircleAvatar(
//               backgroundColor: Colors.teal,
//               child: Text(
//                 'JD',
//                 style: TextStyle(fontSize: 20, color: Colors.white),
//               ),
//             ),
//             decoration: BoxDecoration(
//               color: Colors.teal,
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.person, color: Colors.teal),
//             title: Text('My Profile'),
//             onTap: () => _showProfile(context),
//           ),
//           ListTile(
//             leading: Icon(Icons.history, color: Colors.teal),
//             title: Text('Booking History'),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: Icon(Icons.health_and_safety, color: Colors.teal),
//             title: Text('Health Records'),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: Icon(Icons.family_restroom, color: Colors.teal),
//             title: Text('Family Members'),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: Icon(Icons.payments, color: Colors.teal),
//             title: Text('Payments'),
//             onTap: () {},
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.settings, color: Colors.grey),
//             title: Text('Settings'),
//             onTap: () => _showSettings(context),
//           ),
//           ListTile(
//             leading: Icon(Icons.help_outline, color: Colors.grey),
//             title: Text('Help & Support'),
//             onTap: () => _showHelp(context),
//           ),
//           ListTile(
//             leading: Icon(Icons.info_outline, color: Colors.grey),
//             title: Text('About'),
//             onTap: () {},
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.logout, color: Colors.red),
//             title: Text('Logout', style: TextStyle(color: Colors.red)),
//             onTap: () => _confirmLogout(context),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomNavigationBar(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: 0,
//       type: BottomNavigationBarType.fixed,
//       selectedItemColor: Colors.teal,
//       unselectedItemColor: Colors.grey,
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.medical_services),
//           label: 'Services',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.history),
//           label: 'History',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person),
//           label: 'Profile',
//         ),
//       ],
//       onTap: (index) {
//         // Handle navigation
//       },
//     );
//   }

//   void _confirmLogout(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Logout'),
//         content: Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (context) => LoginScreen()),
//                 (route) => false,
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//             ),
//             child: Text('Logout'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showProfile(BuildContext context) {
//     // Implement profile view
//   }

//   void _showSettings(BuildContext context) {
//     // Implement settings view
//   }

//   void _showHelp(BuildContext context) {
//     // Implement help view
//   }
// }

// // Data Models
// class DashboardFeature {
//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final Color color;
//   final Widget route;

//   const DashboardFeature({
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.color,
//     required this.route,
//   });
// }

// class RecentBooking {
//   final String title;
//   final String subtitle;
//   final String date;
//   final IconData icon;
//   final String status;
//   final Color color;

//   const RecentBooking({
//     required this.title,
//     required this.subtitle,
//     required this.date,
//     required this.icon,
//     required this.status,
//     required this.color,
//   });
// }

// class QuickAction {
//   final String title;
//   final IconData icon;
//   final Color color;
//   final String feature;

//   const QuickAction({
//     required this.title,
//     required this.icon,
//     required this.color,
//     required this.feature,
//   });
// }