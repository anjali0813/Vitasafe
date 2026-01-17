import 'package:flutter/material.dart';
import 'package:vitasafe/emergency_reporting.dart';
import 'package:vitasafe/fire_accident.dart';
import 'package:vitasafe/medical_emergency.dart';
import 'package:vitasafe/natural_disaster_support.dart';
import 'package:vitasafe/public.dart';

// Dummy page placeholders for navigation
class ProfileManagementPage extends StatelessWidget {
  const ProfileManagementPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Profile Management')), body: const Center(child: Text('Profile Management Page')));
}

class TaskAssignmentPage extends StatelessWidget {
  const TaskAssignmentPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Task Assignment')), body: const Center(child: Text('Task Assignment Page')));
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Notifications & Alerts')), body: const Center(child: Text('Notifications Page')));
}

class BloodDonationPage extends StatelessWidget {
  const BloodDonationPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Blood Donation Volunteering')), body: const Center(child: Text('Blood Donation Page')));
}

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Feedback & Ratings')), body: const Center(child: Text('Feedback Page')));
}

class VolunteerEmergencySupportPage extends StatelessWidget {
  const VolunteerEmergencySupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Support"),
        backgroundColor: Colors.redAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.redAccent),
              child: Text('Volunteer Module', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile Management'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileManagementPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Task Assignment'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskAssignmentPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications & Alerts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.bloodtype),
              title: const Text('Blood Donation Volunteering'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const BloodDonationPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback & Ratings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackPage()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Emergency Support",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            const Text(
              "Volunteers can respond quickly to emergencies, report incidents, and assist affected people.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  buildEmergencyCard(
                    context: context,
                    route: AccidentAlertPage(),
                    title: "Accident Alert",
                    description: "Respond to road accidents and help victims immediately.",
                    icon: Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                  ),

                  buildEmergencyCard(
                    context: context,
                    route: MedicalEmergencyPage(),
                    title: "Medical Emergency",
                    description: "Provide first aid and guide patients to nearest hospital.",
                    icon: Icons.local_hospital,
                    color: Colors.green,
                  ),

                  buildEmergencyCard(
                    context: context,
                    route: FireAccidentPage(),
                    title: "Fire Accident",
                    description: "Assist people during fire incidents and alert fire services.",
                    icon: Icons.fire_truck,
                    color: Colors.deepOrange,
                  ),

                  buildEmergencyCard(
                    context: context,
                    route: NaturalDisasterPage(),
                    title: "Natural Disaster Support",
                    description: "Help with rescue, relief distribution, and crowd management.",
                    icon: Icons.flood,
                    color: Colors.blueAccent,
                  ),

                  buildEmergencyCard(
                    context: context,
                    route: EmergencyReportingPage(),
                    title: "Emergency Reporting",
                    description: "Report emergencies with location details instantly.",
                    icon: Icons.location_on,
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmergencyCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Widget route,
    required BuildContext context
  }) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => route,)),
      child: Card(
        
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color,
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey.shade600),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:vitasafe/emergency_reporting.dart';
// import 'package:vitasafe/fire_accident.dart';
// import 'package:vitasafe/medical_emergency.dart';
// import 'package:vitasafe/natural_disaster_support.dart';
// import 'package:vitasafe/public.dart';

// class VolunteerEmergencySupportPage extends StatelessWidget {
//   const VolunteerEmergencySupportPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Emergency Support",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//         backgroundColor: Colors.redAccent,
//         foregroundColor: Colors.white,
//         elevation: 4,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications_active),
//             onPressed: () => _showNotifications(context),
//             tooltip: 'Emergency Alerts',
//           ),
//           IconButton(
//             icon: Icon(Icons.help_outline),
//             onPressed: () => _showHelpDialog(context),
//             tooltip: 'Help & Guide',
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
//               Colors.redAccent.withOpacity(0.05),
//               Colors.white,
//             ],
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Section
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//               decoration: BoxDecoration(
//                 color: Colors.redAccent,
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(25),
//                   bottomRight: Radius.circular(25),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.redAccent.withOpacity(0.3),
//                     blurRadius: 10,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 30,
//                         backgroundColor: Colors.white.withOpacity(0.2),
//                         child: Icon(
//                           Icons.volunteer_activism,
//                           size: 35,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(width: 15),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Volunteer Emergency Support",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               "Active Status: Online",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.white.withOpacity(0.9),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.green.withOpacity(0.3),
//                               blurRadius: 5,
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.circle, size: 8, color: Colors.white),
//                             const SizedBox(width: 6),
//                             Text(
//                               'READY',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       "Quick Response: Volunteers can respond immediately to emergencies, "
//                       "report incidents, and assist affected people in real-time.",
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.white.withOpacity(0.95),
//                         height: 1.4,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Quick Stats
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildStatItem(
//                     context,
//                     count: '12',
//                     label: 'Today\'s Responses',
//                     icon: Icons.emergency,
//                     color: Colors.redAccent,
//                   ),
//                   _buildStatItem(
//                     context,
//                     count: '45',
//                     label: 'Total Responses',
//                     icon: Icons.check_circle,
//                     color: Colors.green,
//                   ),
//                   _buildStatItem(
//                     context,
//                     count: '3',
//                     label: 'Active Emergencies',
//                     icon: Icons.warning,
//                     color: Colors.orange,
//                   ),
//                 ],
//               ),
//             ),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 "Emergency Response Modules",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 10),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 "Select an emergency type to provide immediate assistance",
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Emergency Modules Grid
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   childAspectRatio: 1.0,
//                   crossAxisSpacing: 15,
//                   mainAxisSpacing: 15,
//                   padding: const EdgeInsets.only(bottom: 20),
//                   children: [
//                     _buildEmergencyModuleCard(
//                       context: context,
//                       title: "Accident Alert",
//                       description: "Road accidents & vehicle collisions",
//                       icon: Icons.car_crash_rounded,
//                       color: Colors.redAccent,
//                       route: AccidentAlertPage(),
//                       urgency: 'HIGH',
//                       responseTime: '5-10 min',
//                     ),
//                     _buildEmergencyModuleCard(
//                       context: context,
//                       title: "Medical Emergency",
//                       description: "First aid & hospital guidance",
//                       icon: Icons.local_hospital_rounded,
//                       color: Colors.green,
//                       route: MedicalEmergencyPage(),
//                       urgency: 'CRITICAL',
//                       responseTime: '2-5 min',
//                     ),
//                     _buildEmergencyModuleCard(
//                       context: context,
//                       title: "Fire Accident",
//                       description: "Fire incidents & evacuation",
//                       icon: Icons.fire_truck_rounded,
//                       color: Colors.deepOrange,
//                       route: FireAccidentPage(),
//                       urgency: 'HIGH',
//                       responseTime: '10-15 min',
//                     ),
//                     _buildEmergencyModuleCard(
//                       context: context,
//                       title: "Natural Disaster",
//                       description: "Rescue & relief operations",
//                       icon: Icons.flood_rounded,
//                       color: Colors.blueAccent,
//                       route: NaturalDisasterPage(),
//                       urgency: 'MEDIUM',
//                       responseTime: '15-30 min',
//                     ),
//                     _buildEmergencyModuleCard(
//                       context: context,
//                       title: "Emergency Reporting",
//                       description: "Instant reporting with GPS",
//                       icon: Icons.report_problem_rounded,
//                       color: Colors.purple,
//                       route: EmergencyReportingPage(),
//                       urgency: 'LOW',
//                       responseTime: 'Immediate',
//                     ),
//                     _buildEmergencyModuleCard(
//                       context: context,
//                       title: "Public Safety",
//                       description: "Crowd management & assistance",
//                       icon: Icons.security_rounded,
//                       color: Colors.amber[700]!,
//                       route: PublicPage(),
//                       urgency: 'MEDIUM',
//                       responseTime: '10-20 min',
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Emergency Call Button
//             Container(
//               padding: const EdgeInsets.all(20),
//               color: Colors.redAccent.withOpacity(0.05),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () => _handleEmergencyCall(context),
//                       icon: Icon(Icons.emergency, size: 24),
//                       label: Text(
//                         'EMERGENCY CALL',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.redAccent,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 18),
//                         elevation: 5,
//                         shadowColor: Colors.redAccent.withOpacity(0.5),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => _showQuickActions(context),
//         icon: Icon(Icons.quickreply),
//         label: Text('Quick Actions'),
//         backgroundColor: Colors.redAccent,
//         foregroundColor: Colors.white,
//         elevation: 5,
//       ),
//     );
//   }

//   Widget _buildDrawer(BuildContext context) {
//     return Drawer(
//       width: 280,
//       child: Container(
//         color: Colors.grey[50],
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.redAccent,
//                     Colors.red[800]!,
//                   ],
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundColor: Colors.white.withOpacity(0.2),
//                     child: Icon(
//                       Icons.volunteer_activism,
//                       size: 60,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   Text(
//                     'Volunteer Module',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     'Emergency Response Team',
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.9),
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             _buildDrawerItem(
//               context,
//               icon: Icons.person_rounded,
//               title: 'Profile Management',
//               subtitle: 'Update your volunteer profile',
//               onTap: () => _navigateTo(context, ProfileManagementPage()),
//             ),
//             _buildDrawerItem(
//               context,
//               icon: Icons.task_alt_rounded,
//               title: 'Task Assignment',
//               subtitle: 'View assigned emergency tasks',
//               badge: '3',
//               onTap: () => _navigateTo(context, TaskAssignmentPage()),
//             ),
//             _buildDrawerItem(
//               context,
//               icon: Icons.notifications_active_rounded,
//               title: 'Notifications & Alerts',
//               subtitle: 'Emergency alerts and updates',
//               badge: '12',
//               onTap: () => _navigateTo(context, NotificationsPage()),
//             ),
//             _buildDrawerItem(
//               context,
//               icon: Icons.bloodtype_rounded,
//               title: 'Blood Donation',
//               subtitle: 'Volunteer for blood donation',
//               onTap: () => _navigateTo(context, BloodDonationPage()),
//             ),
//             _buildDrawerItem(
//               context,
//               icon: Icons.feedback_rounded,
//               title: 'Feedback & Ratings',
//               subtitle: 'Share your experience',
//               onTap: () => _navigateTo(context, FeedbackPage()),
//             ),
//             _buildDrawerItem(
//               context,
//               icon: Icons.history_rounded,
//               title: 'Response History',
//               subtitle: 'View your past responses',
//               onTap: () => _showResponseHistory(context),
//             ),
//             _buildDrawerItem(
//               context,
//               icon: Icons.settings_rounded,
//               title: 'Settings',
//               subtitle: 'Configure emergency settings',
//               onTap: () => _showSettings(context),
//             ),
//             const Divider(height: 20),
//             _buildDrawerItem(
//               context,
//               icon: Icons.logout_rounded,
//               title: 'Logout',
//               subtitle: 'Sign out from volunteer module',
//               color: Colors.red,
//               onTap: () => _confirmLogout(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawerItem(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     String? badge,
//     Color? color,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Container(
//         width: 45,
//         height: 45,
//         decoration: BoxDecoration(
//           color: color ?? Colors.redAccent.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Icon(
//           icon,
//           color: color ?? Colors.redAccent,
//           size: 22,
//         ),
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontWeight: FontWeight.w600,
//           color: color ?? Colors.grey[800],
//         ),
//       ),
//       subtitle: Text(
//         subtitle,
//         style: TextStyle(
//           fontSize: 12,
//           color: Colors.grey[600],
//         ),
//       ),
//       trailing: badge != null
//           ? Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 color: Colors.redAccent,
//                 shape: BoxShape.circle,
//               ),
//               child: Text(
//                 badge,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             )
//           : null,
//       onTap: onTap,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     );
//   }

//   Widget _buildStatItem(
//     BuildContext context, {
//     required String count,
//     required String label,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Column(
//       children: [
//         Container(
//           width: 60,
//           height: 60,
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(15),
//             border: Border.all(color: color.withOpacity(0.3)),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 24, color: color),
//               const SizedBox(height: 4),
//               Text(
//                 count,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey[600],
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   Widget _buildEmergencyModuleCard({
//     required BuildContext context,
//     required String title,
//     required String description,
//     required IconData icon,
//     required Color color,
//     required Widget route,
//     required String urgency,
//     required String responseTime,
//   }) {
//     final urgencyColor = _getUrgencyColor(urgency);
    
//     return InkWell(
//       onTap: () => _navigateToEmergency(context, route, title),
//       onLongPress: () => _showEmergencyInfo(context, title, description),
//       borderRadius: BorderRadius.circular(20),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//           border: Border.all(color: color.withOpacity(0.2)),
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//               top: 0,
//               right: 0,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: urgencyColor.withOpacity(0.1),
//                   borderRadius: const BorderRadius.only(
//                     topRight: Radius.circular(20),
//                     bottomLeft: Radius.circular(10),
//                   ),
//                 ),
//                 child: Text(
//                   urgency,
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     color: urgencyColor,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: color.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       icon,
//                       size: 28,
//                       color: color,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[800],
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     description,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey[600],
//                       height: 1.4,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const Spacer(),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.access_time,
//                         size: 12,
//                         color: Colors.grey[500],
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         'Response: $responseTime',
//                         style: TextStyle(
//                           fontSize: 11,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Container(
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: color.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getUrgencyColor(String urgency) {
//     switch (urgency.toLowerCase()) {
//       case 'critical':
//         return Colors.red;
//       case 'high':
//         return Colors.orange;
//       case 'medium':
//         return Colors.blue;
//       case 'low':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }

//   void _navigateToEmergency(BuildContext context, Widget route, String title) {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) => route,
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           const begin = Offset(0.0, 1.0);
//           const end = Offset.zero;
//           const curve = Curves.easeInOut;
//           var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//           return SlideTransition(
//             position: animation.drive(tween),
//             child: child,
//           );
//         },
//       ),
//     );
//   }

//   void _navigateTo(BuildContext context, Widget page) {
//     Navigator.pop(context); // Close drawer
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => page),
//     );
//   }

//   void _handleEmergencyCall(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(25),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 Icons.emergency,
//                 size: 60,
//                 color: Colors.redAccent,
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Emergency Call',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Are you sure you want to make an emergency call?\n'
//                 'This will alert nearby volunteers and emergency services.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.grey[700],
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text('CANCEL'),
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         _makeEmergencyCall(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.redAccent,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text('CALL NOW'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _makeEmergencyCall(BuildContext context) {
//     // Implement emergency call functionality
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.white),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text('Emergency call initiated. Help is on the way!'),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.green,
//         duration: const Duration(seconds: 3),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }

//   void _showQuickActions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Quick Actions',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               GridView.count(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisCount: 3,
//                 childAspectRatio: 0.9,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 children: [
//                   _buildQuickAction(
//                     icon: Icons.location_on,
//                     label: 'Share\nLocation',
//                     color: Colors.blue,
//                     onTap: () => _shareLocation(context),
//                   ),
//                   _buildQuickAction(
//                     icon: Icons.medical_services,
//                     label: 'First Aid\nGuide',
//                     color: Colors.green,
//                     onTap: () => _showFirstAidGuide(context),
//                   ),
//                   _buildQuickAction(
//                     icon: Icons.phone,
//                     label: 'Emergency\nContacts',
//                     color: Colors.red,
//                     onTap: () => _showEmergencyContacts(context),
//                   ),
//                   _buildQuickAction(
//                     icon: Icons.map,
//                     label: 'Nearest\nHospitals',
//                     color: Colors.purple,
//                     onTap: () => _showNearestHospitals(context),
//                   ),
//                   _buildQuickAction(
//                     icon: Icons.warning,
//                     label: 'SOS\nAlert',
//                     color: Colors.orange,
//                     onTap: () => _sendSOSAlert(context),
//                   ),
//                   _buildQuickAction(
//                     icon: Icons.history,
//                     label: 'Response\nHistory',
//                     color: Colors.teal,
//                     onTap: () => _showResponseHistory(context),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               OutlinedButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Close'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildQuickAction({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(15),
//       child: Container(
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(color: color.withOpacity(0.3)),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 30, color: color),
//             const SizedBox(height: 8),
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 11,
//                 fontWeight: FontWeight.w500,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showNotifications(BuildContext context) {
//     // Implement notifications dialog
//   }

//   void _showHelpDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(Icons.help_outline, color: Colors.redAccent),
//             const SizedBox(width: 10),
//             const Text('Emergency Response Guide'),
//           ],
//         ),
//         content: const SingleChildScrollView(
//           child: Text(
//             '1. Stay calm and assess the situation\n'
//             '2. Ensure your own safety first\n'
//             '3. Call emergency services if needed\n'
//             '4. Provide first aid within your training\n'
//             '5. Guide others to safety\n'
//             '6. Report the incident accurately\n'
//             '7. Stay until help arrives\n\n'
//             'Remember: Your safety is the top priority.',
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('GOT IT'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showEmergencyInfo(BuildContext context, String title, String description) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(description),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showResponseHistory(BuildContext context) {
//     // Implement response history
//   }

//   void _showSettings(BuildContext context) {
//     // Implement settings
//   }

//   void _confirmLogout(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to logout from the volunteer module?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('CANCEL'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Close dialog
//               Navigator.pop(context); // Close drawer
//               // Implement logout logic
//             },
//             child: const Text('LOGOUT'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _shareLocation(BuildContext context) {
//     // Implement location sharing
//   }

//   void _showFirstAidGuide(BuildContext context) {
//     // Implement first aid guide
//   }

//   void _showEmergencyContacts(BuildContext context) {
//     // Implement emergency contacts
//   }

//   void _showNearestHospitals(BuildContext context) {
//     // Implement nearest hospitals
//   }

//   void _sendSOSAlert(BuildContext context) {
//     // Implement SOS alert
//   }
// }

// // Dummy page classes (same as before but with enhanced UI)
// class ProfileManagementPage extends StatelessWidget {
//   const ProfileManagementPage({super.key});
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(title: const Text('Profile Management')),
//     body: const Center(child: Text('Profile Management Page')),
//   );
// }

// class TaskAssignmentPage extends StatelessWidget {
//   const TaskAssignmentPage({super.key});
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(title: const Text('Task Assignment')),
//     body: const Center(child: Text('Task Assignment Page')),
//   );
// }

// class NotificationsPage extends StatelessWidget {
//   const NotificationsPage({super.key});
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(title: const Text('Notifications & Alerts')),
//     body: const Center(child: Text('Notifications Page')),
//   );
// }

// class BloodDonationPage extends StatelessWidget {
//   const BloodDonationPage({super.key});
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(title: const Text('Blood Donation Volunteering')),
//     body: const Center(child: Text('Blood Donation Page')),
//   );
// }

// class FeedbackPage extends StatelessWidget {
//   const FeedbackPage({super.key});
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(title: const Text('Feedback & Ratings')),
//     body: const Center(child: Text('Feedback Page')),
//   );
// }