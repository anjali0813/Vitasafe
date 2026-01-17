// // import 'package:flutter/material.dart';

// // class EmergencyReportingPage extends StatefulWidget {
// //   const EmergencyReportingPage({super.key});

// //   @override
// //   State<EmergencyReportingPage> createState() => _EmergencyReportingPageState();
// // }

// // class _EmergencyReportingPageState extends State<EmergencyReportingPage> {
// //   final TextEditingController typeController = TextEditingController();
// //   final TextEditingController locationController = TextEditingController();
// //   final TextEditingController descriptionController = TextEditingController();
// //   bool isSubmitting = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Emergency Reporting"),
// //         backgroundColor: Colors.redAccent,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text(
// //                 "Report an Emergency",
// //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //               ),
// //               const SizedBox(height: 20),

// //               TextField(
// //                 controller: typeController,
// //                 decoration: InputDecoration(
// //                   labelText: "Emergency Type (Fire, Accident, Medical...)",
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //               ),

// //               const SizedBox(height: 16),

// //               TextField(
// //                 controller: locationController,
// //                 decoration: InputDecoration(
// //                   labelText: "Emergency Location",
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //               ),

// //               const SizedBox(height: 16),

// //               TextField(
// //                 controller: descriptionController,
// //                 maxLines: 3,
// //                 decoration: InputDecoration(
// //                   labelText: "Description (Optional)",
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //               ),

// //               const SizedBox(height: 24),

// //               SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton.icon(
// //                   onPressed: isSubmitting ? null : _submitAlert,
// //                   icon: const Icon(Icons.report),
// //                   label: Text(isSubmitting ? "Sending..." : "Send Report"),
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.redAccent,
// //                     padding: const EdgeInsets.symmetric(vertical: 14),
// //                     textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Future<void> _submitAlert() async {
// //     if (typeController.text.isEmpty || locationController.text.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Please fill in the required fields.")),
// //       );
// //       return;
// //     }

// //     setState(() => isSubmitting = true);
// //     await Future.delayed(const Duration(seconds: 2));
// //     setState(() => isSubmitting = false);

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text("Emergency report submitted!")),
// //     );

// //     typeController.clear();
// //     locationController.clear();
// //     descriptionController.clear();
// //   }
// // }


// import 'package:flutter/material.dart';

// class EmergencyReportingPage extends StatefulWidget {
//   const EmergencyReportingPage({super.key});

//   @override
//   State<EmergencyReportingPage> createState() => _EmergencyReportingPageState();
// }

// class _EmergencyReportingPageState extends State<EmergencyReportingPage> {
//   final TextEditingController typeController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController affectedPeopleController = TextEditingController();
  
//   bool isSubmitting = false;
//   String? selectedSeverity;
//   String? selectedEmergencyType;
//   bool isUrgent = false;
  
//   final List<String> severityLevels = ['Low', 'Medium', 'High', 'Critical'];
//   final List<String> emergencyTypes = [
//     'Medical Emergency',
//     'Fire',
//     'Accident',
//     'Natural Disaster',
//     'Crime',
//     'Missing Person',
//     'Other'
//   ];

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               // Emergency Header
//               Container(
//                 height: 180,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [Colors.red.shade800, Colors.redAccent.shade700],
//                   ),
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.red.withOpacity(0.3),
//                       blurRadius: 15,
//                       spreadRadius: 3,
//                     ),
//                   ],
//                 ),
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       top: 15,
//                       left: 15,
//                       child: IconButton(
//                         icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 30),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ),
//                     Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 70,
//                             height: 70,
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.2),
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.warning_amber_rounded,
//                               size: 40,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(height: 15),
//                           const Text(
//                             "Emergency Report",
//                             style: TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           const Text(
//                             "Report emergencies immediately for quick response",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.white,
//                               height: 1.4,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Form Section
//               Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Quick Actions
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.red.shade50,
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(color: Colors.red.shade100),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Icon(Icons.phone, size: 18, color: Colors.red.shade700),
//                                       const SizedBox(width: 8),
//                                       const Text(
//                                         "Call Emergency Services",
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 14,
//                                           color: Colors.red,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     "Dial 112 for police, 101 for fire, 108 for ambulance",
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey[700],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             ElevatedButton.icon(
//                               onPressed: () {
//                                 // Call emergency number
//                               },
//                               icon: const Icon(Icons.call, size: 18),
//                               label: const Text("Call"),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.red.shade600,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 30),

//                       // Emergency Type
//                       _buildSectionHeader("Emergency Details"),
//                       const SizedBox(height: 18),

//                       // Emergency Type Dropdown
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Type of Emergency *",
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.grey[700],
//                               height: 1.5,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           DropdownButtonFormField<String>(
//                             value: selectedEmergencyType,
//                             items: emergencyTypes.map((String type) {
//                               return DropdownMenuItem<String>(
//                                 value: type,
//                                 child: Text(
//                                   type,
//                                   style: const TextStyle(fontSize: 15),
//                                 ),
//                               );
//                             }).toList(),
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 selectedEmergencyType = newValue;
//                               });
//                             },
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please select emergency type';
//                               }
//                               return null;
//                             },
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(Icons.warning_amber_outlined, 
//                                   color: Colors.red.shade600, size: 22),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                                 borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                                 borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                                 borderSide: BorderSide(color: Colors.red.shade600, width: 2),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                                 borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
//                               ),
//                               focusedErrorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                                 borderSide: BorderSide(color: Colors.red.shade600, width: 2),
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                               contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                               isDense: true,
//                             ),
//                             style: const TextStyle(color: Colors.black87, fontSize: 15),
//                             icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey.shade600, size: 28),
//                             hint: Text(
//                               "Select emergency type",
//                               style: TextStyle(color: Colors.grey[500], fontSize: 15),
//                             ),
//                             isExpanded: true,
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 18),

//                       // Severity Level
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Severity Level *",
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.grey[700],
//                               height: 1.5,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           DropdownButtonFormField<String>(
//                             value: selectedSeverity,
//                             items: severityLevels.map((String severity) {
//                               Color color;
//                               switch (severity) {
//                                 case 'Low':
//                                   color = Colors.green;
//                                   break;
//                                 case 'Medium':
//                                   color = Colors.orange;
//                                   break;
//                                 case 'High':
//                                   color = Colors.orange.shade800;
//                                   break;
//                                 case 'Critical':
//                                   color = Colors.red;
//                                   break;
//                                 default:
//                                   color = Colors.grey;
//                               }
//                               return DropdownMenuItem<String>(
//                                 value: severity,
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: 12,
//                                       height: 12,
//                                       decoration: BoxDecoration(
//                                         color: color,
//                                         shape: BoxShape.circle,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 10),
//                                     Text(
//                                       severity,
//                                       style: const TextStyle(fontSize: 15),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }).toList(),
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 selectedSeverity = newValue;
//                               });
//                             },
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please select severity level';
//                               }
//                               return null;
//                             },
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(Icons.speed, color: Colors.red.shade600, size: 22),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                                 borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                                 borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                                 borderSide: BorderSide(color: Colors.red.shade600, width: 2),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                                 borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                               contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                               isDense: true,
//                             ),
//                             style: const TextStyle(color: Colors.black87, fontSize: 15),
//                             icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey.shade600, size: 28),
//                             hint: Text(
//                               "Select severity level",
//                               style: TextStyle(color: Colors.grey[500], fontSize: 15),
//                             ),
//                             isExpanded: true,
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 18),

//                       // Urgent Checkbox
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.red.shade50,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.red.shade100),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.flash_on, color: Colors.orange.shade700, size: 20),
//                             const SizedBox(width: 10),
//                             const Expanded(
//                               child: Text(
//                                 "This is an urgent emergency requiring immediate response",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                             ),
//                             Switch(
//                               value: isUrgent,
//                               onChanged: (value) {
//                                 setState(() {
//                                   isUrgent = value;
//                                 });
//                               },
//                               activeColor: Colors.red,
//                               activeTrackColor: Colors.red.shade200,
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 30),

//                       // Location & Contact Info
//                       _buildSectionHeader("Location & Contact"),
//                       const SizedBox(height: 18),

//                       // Location
//                       _buildTextField(
//                         controller: locationController,
//                         label: "Emergency Location *",
//                         icon: Icons.location_on_outlined,
//                         hintText: "Enter exact address, landmark, or coordinates",
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter emergency location';
//                           }
//                           if (value.length < 5) {
//                             return 'Please provide a more specific location';
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 18),

//                       // Phone Number
//                       _buildTextField(
//                         controller: phoneController,
//                         label: "Your Contact Number *",
//                         icon: Icons.phone_android_outlined,
//                         keyboardType: TextInputType.phone,
//                         hintText: "Enter your mobile number",
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter contact number';
//                           }
//                           if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
//                             return 'Enter valid phone number (10-15 digits)';
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 18),

//                       // Affected People
//                       _buildTextField(
//                         controller: affectedPeopleController,
//                         label: "Number of People Affected",
//                         icon: Icons.people_outline,
//                         keyboardType: TextInputType.number,
//                         hintText: "Approximate number of people involved",
//                         validator: (value) {
//                           if (value != null && value.isNotEmpty) {
//                             try {
//                               int num = int.parse(value);
//                               if (num < 0) return 'Enter valid number';
//                             } catch (e) {
//                               return 'Enter valid number';
//                             }
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 30),

//                       // Description
//                       _buildSectionHeader("Additional Information"),
//                       const SizedBox(height: 18),

//                       // Description
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Description (Optional)",
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.grey[700],
//                               height: 1.5,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           TextFormField(
//                             controller: descriptionController,
//                             maxLines: 4,
//                             decoration: InputDecoration(
//                               hintText: "Describe the situation, injuries, hazards, etc.",
//                               hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                                 borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                                 borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                                 borderSide: BorderSide(color: Colors.red.shade600, width: 2),
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                               contentPadding: const EdgeInsets.all(16),
//                             ),
//                             style: const TextStyle(fontSize: 15),
//                           ),
//                         ],
//                       ),

//                       // Important Note
//                       const SizedBox(height: 25),
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.amber.shade50,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.amber.shade200),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Icon(Icons.info_outline, size: 20, color: Colors.amber.shade800),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Text(
//                                 "Please provide accurate information. False reports may lead to legal consequences. Emergency services have been notified automatically.",
//                                 style: TextStyle(
//                                   color: Colors.grey[700],
//                                   fontSize: 13,
//                                   height: 1.5,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Submit Button
//                       const SizedBox(height: 35),
//                       _buildSubmitButton(),

//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Row(
//       children: [
//         Container(
//           width: 4,
//           height: 20,
//           decoration: BoxDecoration(
//             color: Colors.red.shade600,
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 19,
//             fontWeight: FontWeight.bold,
//             color: Colors.red.shade800,
//             letterSpacing: 0.3,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     String? hintText,
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey[700],
//             height: 1.5,
//           ),
//         ),
//         const SizedBox(height: 6),
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           decoration: InputDecoration(
//             hintText: hintText,
//             hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
//             prefixIcon: Icon(icon, color: Colors.red.shade600, size: 22),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide(color: Colors.red.shade600, width: 2),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide(color: Colors.red.shade600, width: 2),
//             ),
//             filled: true,
//             fillColor: Colors.white,
//             contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
//             isDense: true,
//           ),
//           validator: validator,
//           style: const TextStyle(fontSize: 15),
//         ),
//       ],
//     );
//   }

//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 58,
//       child: ElevatedButton(
//         onPressed: isSubmitting ? null : _submitAlert,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.red.shade600,
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           elevation: 5,
//           shadowColor: Colors.red.withOpacity(0.4),
//           padding: const EdgeInsets.symmetric(vertical: 16),
//         ),
//         child: isSubmitting
//             ? SizedBox(
//                 height: 26,
//                 width: 26,
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 2.5,
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(isUrgent ? Icons.flash_on : Icons.report_rounded, 
//                       size: 24, color: Colors.white),
//                   const SizedBox(width: 12),
//                   Text(
//                     isUrgent ? "SEND URGENT REPORT" : "SUBMIT EMERGENCY REPORT",
//                     style: const TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w600,
//                       letterSpacing: 0.3,
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   Future<void> _submitAlert() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() => isSubmitting = true);
    
//     // Simulate API call
//     await Future.delayed(const Duration(seconds: 2));
    
//     setState(() => isSubmitting = false);

//     // Show success dialog
//     _showSuccessDialog();
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         title: Column(
//           children: [
//             Container(
//               width: 70,
//               height: 70,
//               decoration: BoxDecoration(
//                 color: Colors.green.shade100,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.check_circle,
//                 size: 50,
//                 color: Colors.green.shade600,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               isUrgent ? "URGENT REPORT SUBMITTED!" : "Report Submitted",
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: isUrgent ? Colors.red.shade700 : Colors.green.shade700,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               isUrgent 
//                 ? "Emergency services have been alerted with highest priority. Help is on the way!"
//                 : "Your emergency report has been submitted successfully. Authorities will respond shortly.",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 15,
//                 color: Colors.grey[700],
//                 height: 1.5,
//               ),
//             ),
//             const SizedBox(height: 5),
//             if (isUrgent) ...[
//               const SizedBox(height: 10),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade50,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.red.shade100),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.warning_amber, color: Colors.red.shade700, size: 20),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Text(
//                         "Please stay in a safe location until help arrives",
//                         style: TextStyle(
//                           color: Colors.red.shade700,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _clearForm();
//             },
//             child: const Text(
//               "OK",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _clearForm() {
//     typeController.clear();
//     locationController.clear();
//     descriptionController.clear();
//     phoneController.clear();
//     affectedPeopleController.clear();
//     setState(() {
//       selectedSeverity = null;
//       selectedEmergencyType = null;
//       isUrgent = false;
//     });
//   }
// }




import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class EmergencyReportingPage extends StatefulWidget {
  const EmergencyReportingPage({super.key});

  @override
  State<EmergencyReportingPage> createState() => _EmergencyReportingPageState();
}

class _EmergencyReportingPageState extends State<EmergencyReportingPage> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController affectedPeopleController = TextEditingController();
  
  bool isSubmitting = false;
  String? selectedSeverity;
  String? selectedEmergencyType;
  bool isUrgent = false;
  
  final List<String> severityLevels = ['Low', 'Medium', 'High', 'Critical'];
  final List<String> emergencyTypes = [
    'Medical Emergency',
    'Fire',
    'Accident',
    'Natural Disaster',
    'Crime',
    'Missing Person',
    'Other'
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _validateLoginId();
  }

  void _validateLoginId() {
    if (lid == null || lid.toString().isEmpty || lid! <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorDialog(
          'Invalid Session',
          'Please login again to report an emergency.',
        );
      });
    }
  }

  @override
  void dispose() {
    locationController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
    affectedPeopleController.dispose();
    super.dispose();
  }

  Color _getSeverityColor(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.orange.shade800;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _submitAlert() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (lid == null || lid! <= 0) {
      _showErrorDialog(
        'Invalid Session',
        'Please login again to report an emergency.',
      );
      return;
    }

    final confirmed = await _showConfirmationDialog();
    if (confirmed != true) return;

    setState(() => isSubmitting = true);

    try {
      final response = await dio.post(
        "$baseurl/emergency_report",
        data: {
          "user_id": lid,
          "emergency_type": selectedEmergencyType,
          "severity": selectedSeverity,
          "location": locationController.text.trim(),
          "phone": phoneController.text.trim(),
          "affected_people": affectedPeopleController.text.isNotEmpty
              ? int.tryParse(affectedPeopleController.text.trim())
              : null,
          "description": descriptionController.text.trim(),
          "is_urgent": isUrgent,
          "timestamp": DateTime.now().toIso8601String(),
        },
        options: Options(
          validateStatus: (status) => status! < 500,
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 20),
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessDialog();
      } else if (response.statusCode == 400) {
        throw Exception('Invalid emergency report data');
      } else if (response.statusCode == 429) {
        throw Exception('Too many reports. Please wait before submitting again.');
      } else {
        throw Exception('Failed to submit report: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (!mounted) return;
      
      String message = 'Failed to submit emergency report';
      
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'Connection timeout. Please check your internet and try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        message = 'No internet connection. Please try again.';
      } else if (e.response?.statusCode == 400) {
        message = 'Invalid report data. Please check your information.';
      } else if (e.response?.statusCode == 401) {
        message = 'Unauthorized. Please login again.';
      } else if (e.response?.statusCode == 429) {
        message = 'Too many reports. Please wait before submitting again.';
      } else if (e.response != null) {
        message = 'Error ${e.response?.statusCode}: ${e.response?.statusMessage ?? "Unknown error"}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[700],
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
      
      debugPrint("Error submitting report: $e");
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred: ${e.toString()}'),
          backgroundColor: Colors.red[700],
          duration: const Duration(seconds: 4),
        ),
      );
      
      debugPrint("Error: $e");
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  Future<bool?> _showConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red[700], size: 28),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Confirm Emergency Report',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('You are about to submit an emergency report with:'),
            const SizedBox(height: 12),
            _buildConfirmItem('Type', selectedEmergencyType ?? 'N/A'),
            _buildConfirmItem('Severity', selectedSeverity ?? 'N/A'),
            _buildConfirmItem('Location', locationController.text.trim()),
            if (isUrgent) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.flash_on, color: Colors.red[700], size: 18),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Marked as URGENT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              'Emergency services will be notified. Are you sure?',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 50,
                color: Colors.green.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isUrgent ? "URGENT REPORT SUBMITTED!" : "Report Submitted",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isUrgent ? Colors.red.shade700 : Colors.green.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isUrgent 
                ? "Emergency services have been alerted with highest priority. Help is on the way!"
                : "Your emergency report has been submitted successfully. Authorities will respond shortly.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            if (isUrgent) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Please stay in a safe location until help arrives",
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                _clearForm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    locationController.clear();
    descriptionController.clear();
    phoneController.clear();
    affectedPeopleController.clear();
    setState(() {
      selectedSeverity = null;
      selectedEmergencyType = null;
      isUrgent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Emergency Header
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.red.shade800, Colors.redAccent.shade700],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 15,
                      left: 15,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.warning_amber_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Emergency Report",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Report emergencies immediately for quick response",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Form Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Actions
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.red.shade100),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.phone, size: 18, color: Colors.red.shade700),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "Call Emergency Services",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Dial 112 for police, 101 for fire, 108 for ambulance",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Implement call functionality
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Emergency call feature - dial 112'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.call, size: 18),
                              label: const Text("Call"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade600,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Emergency Type
                      _buildSectionHeader("Emergency Details"),
                      const SizedBox(height: 18),

                      // Emergency Type Dropdown
                      _buildDropdownField(
                        label: "Type of Emergency *",
                        value: selectedEmergencyType,
                        items: emergencyTypes,
                        icon: Icons.warning_amber_outlined,
                        hint: "Select emergency type",
                        onChanged: (value) {
                          setState(() => selectedEmergencyType = value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select emergency type';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Severity Level
                      _buildDropdownField(
                        label: "Severity Level *",
                        value: selectedSeverity,
                        items: severityLevels,
                        icon: Icons.speed,
                        hint: "Select severity level",
                        showColorIndicator: true,
                        onChanged: (value) {
                          setState(() => selectedSeverity = value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select severity level';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Urgent Checkbox
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade100),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.flash_on, color: Colors.orange.shade700, size: 20),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                "This is an urgent emergency requiring immediate response",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Switch(
                              value: isUrgent,
                              onChanged: (value) {
                                setState(() => isUrgent = value);
                              },
                              activeColor: Colors.red,
                              activeTrackColor: Colors.red.shade200,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Location & Contact Info
                      _buildSectionHeader("Location & Contact"),
                      const SizedBox(height: 18),

                      // Location
                      _buildTextField(
                        controller: locationController,
                        label: "Emergency Location *",
                        icon: Icons.location_on_outlined,
                        hintText: "Enter exact address, landmark, or coordinates",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter emergency location';
                          }
                          if (value.trim().length < 5) {
                            return 'Please provide a more specific location';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Phone Number
                      _buildTextField(
                        controller: phoneController,
                        label: "Your Contact Number *",
                        icon: Icons.phone_android_outlined,
                        keyboardType: TextInputType.phone,
                        hintText: "Enter your mobile number",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter contact number';
                          }
                          final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
                          if (cleaned.length < 10 || cleaned.length > 15) {
                            return 'Enter valid phone number (10-15 digits)';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Affected People
                      _buildTextField(
                        controller: affectedPeopleController,
                        label: "Number of People Affected",
                        icon: Icons.people_outline,
                        keyboardType: TextInputType.number,
                        hintText: "Approximate number of people involved",
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            final num = int.tryParse(value.trim());
                            if (num == null || num < 0) {
                              return 'Enter valid number';
                            }
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      // Description
                      _buildSectionHeader("Additional Information"),
                      const SizedBox(height: 18),

                      // Description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description (Optional)",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 4,
                            maxLength: 500,
                            decoration: InputDecoration(
                              hintText: "Describe the situation, injuries, hazards, etc.",
                              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: Colors.red.shade600, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),

                      // Important Note
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline, size: 20, color: Colors.amber.shade800),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Please provide accurate information. False reports may lead to legal consequences. Emergency services will be notified.",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Submit Button
                      const SizedBox(height: 32),
                      _buildSubmitButton(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.red.shade600,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.red.shade800,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required String hint,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
    bool showColorIndicator = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  if (showColorIndicator) ...[
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getSeverityColor(item),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.red.shade600, size: 22),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red.shade600, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red.shade600, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            isDense: true,
          ),
          style: const TextStyle(color: Colors.black87, fontSize: 15),
          icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey.shade600, size: 28),
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey[500], fontSize: 15),
          ),
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.red.shade600, size: 22),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red.shade600, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red.shade600, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
            isDense: true,
          ),
          validator: validator,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : _submitAlert,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          shadowColor: Colors.red.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: isSubmitting
            ? const SizedBox(
                height: 26,
                width: 26,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(isUrgent ? Icons.flash_on : Icons.report_rounded, 
                      size: 24, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    isUrgent ? "SEND URGENT REPORT" : "SUBMIT EMERGENCY REPORT",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}