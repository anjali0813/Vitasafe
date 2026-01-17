// import 'package:flutter/material.dart';

// class NaturalDisasterPage extends StatefulWidget {
//   const NaturalDisasterPage({super.key});

//   @override
//   State<NaturalDisasterPage> createState() => _NaturalDisasterPageState();
// }

// class _NaturalDisasterPageState extends State<NaturalDisasterPage> {
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   bool isSubmitting = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Natural Disaster Support"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Report a Disaster Situation",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),

//             TextField(
//               controller: locationController,
//               decoration: InputDecoration(
//                 labelText: "Affected Location",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             TextField(
//               controller: descriptionController,
//               maxLines: 3,
//               decoration: InputDecoration(
//                 labelText: "Disaster Details (Optional)",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: isSubmitting ? null : _submitAlert,
//                 icon: const Icon(Icons.public),
//                 label: Text(isSubmitting ? "Sending..." : "Send Alert"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.redAccent,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _submitAlert() async {
//     if (locationController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter the affected location.")),
//       );
//       return;
//     }

//     setState(() => isSubmitting = true);
//     await Future.delayed(const Duration(seconds: 2));
//     setState(() => isSubmitting = false);

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Disaster alert sent!")),
//     );

//     locationController.clear();
//     descriptionController.clear();
//   }
// }





import 'package:flutter/material.dart';

class NaturalDisasterPage extends StatefulWidget {
  const NaturalDisasterPage({super.key});

  @override
  State<NaturalDisasterPage> createState() => _NaturalDisasterPageState();
}

class _NaturalDisasterPageState extends State<NaturalDisasterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController peopleAffectedController = TextEditingController();
  
  bool isSubmitting = false;
  String selectedDisasterType = 'Flood';
  String selectedUrgency = 'High';
  bool needsEvacuation = false;
  bool needsMedicalAid = false;
  bool needsShelter = false;
  bool needsFood = false;

  final List<String> disasterTypes = [
    'Flood',
    'Earthquake',
    'Cyclone',
    'Landslide',
    'Fire',
    'Drought',
    'Tsunami',
    'Storm',
    'Other'
  ];

  final List<String> urgencyLevels = ['Low', 'Medium', 'High', 'Critical'];

  @override
  void dispose() {
    locationController.dispose();
    descriptionController.dispose();
    contactController.dispose();
    peopleAffectedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Disaster Emergency Report",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.orange[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Emergency Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[800]!, Colors.orange[600]!],
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
                      Icons.warning_amber_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Natural Disaster Alert",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Report disaster situations for immediate emergency response",
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
                    // Disaster Type Selection
                    _buildSectionTitle("Disaster Type *"),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedDisasterType,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.orange[800]),
                          items: disasterTypes.map((String type) {
                            IconData icon;
                            switch (type) {
                              case 'Flood':
                                icon = Icons.water;
                                break;
                              case 'Earthquake':
                                icon = Icons.terrain;
                                break;
                              case 'Cyclone':
                                icon = Icons.air;
                                break;
                              case 'Landslide':
                                icon = Icons.landscape;
                                break;
                              case 'Fire':
                                icon = Icons.local_fire_department;
                                break;
                              case 'Drought':
                                icon = Icons.wb_sunny;
                                break;
                              case 'Tsunami':
                                icon = Icons.waves;
                                break;
                              case 'Storm':
                                icon = Icons.thunderstorm;
                                break;
                              default:
                                icon = Icons.emergency;
                            }
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Row(
                                children: [
                                  Icon(icon, size: 20, color: Colors.orange[700]),
                                  const SizedBox(width: 12),
                                  Text(type),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() => selectedDisasterType = newValue!);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Location Field
                    _buildSectionTitle("Affected Location *"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: locationController,
                      decoration: _buildInputDecoration(
                        labelText: "Enter specific location",
                        hintText: "e.g., Village/Town name, District",
                        prefixIcon: Icons.location_on,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Location is required';
                        }
                        if (value.trim().length < 3) {
                          return 'Please provide a more specific location';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Contact Number
                    _buildSectionTitle("Contact Number *"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: contactController,
                      keyboardType: TextInputType.phone,
                      decoration: _buildInputDecoration(
                        labelText: "Emergency contact number",
                        hintText: "e.g., +91 9876543210",
                        prefixIcon: Icons.phone,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Contact number is required';
                        }
                        if (value.trim().length < 10) {
                          return 'Please enter a valid contact number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // People Affected
                    _buildSectionTitle("Estimated People Affected"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: peopleAffectedController,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration(
                        labelText: "Approximate number (optional)",
                        hintText: "e.g., 50",
                        prefixIcon: Icons.people,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Urgency Level
                    _buildSectionTitle("Urgency Level *"),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          _buildUrgencyOption('Low', 'Situation is manageable'),
                          Divider(height: 1, color: Colors.grey[300]),
                          _buildUrgencyOption('Medium', 'Requires attention'),
                          Divider(height: 1, color: Colors.grey[300]),
                          _buildUrgencyOption('High', 'Immediate help needed'),
                          Divider(height: 1, color: Colors.grey[300]),
                          _buildUrgencyOption('Critical', 'Life-threatening emergency'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Immediate Needs
                    _buildSectionTitle("Immediate Needs"),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildCheckboxTile(
                            'Evacuation Required',
                            needsEvacuation,
                            Icons.directions_run,
                            (value) => setState(() => needsEvacuation = value!),
                          ),
                          _buildCheckboxTile(
                            'Medical Aid Needed',
                            needsMedicalAid,
                            Icons.medical_services,
                            (value) => setState(() => needsMedicalAid = value!),
                          ),
                          _buildCheckboxTile(
                            'Shelter Required',
                            needsShelter,
                            Icons.home,
                            (value) => setState(() => needsShelter = value!),
                          ),
                          _buildCheckboxTile(
                            'Food & Water Needed',
                            needsFood,
                            Icons.restaurant,
                            (value) => setState(() => needsFood = value!),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Description
                    _buildSectionTitle("Situation Details"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      maxLength: 500,
                      decoration: _buildInputDecoration(
                        labelText: "Describe the situation (optional)",
                        hintText: "Extent of damage, areas affected, specific hazards, etc.",
                        prefixIcon: Icons.description,
                        alignLabelWithHint: true,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Emergency Contact Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.emergency, color: Colors.red[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Emergency Helplines",
                                  style: TextStyle(
                                    color: Colors.red[900],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "NDRF: 011-24363260 | Disaster: 1078",
                                  style: TextStyle(
                                    color: Colors.red[800],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isSubmitting ? null : _submitAlert,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[800],
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[400],
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isSubmitting
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
                                    "Sending Alert...",
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
                                    "Send Emergency Alert".toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),
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
      prefixIcon: Icon(prefixIcon, color: Colors.orange[800]),
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
        borderSide: BorderSide(color: Colors.orange[800]!, width: 2),
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

  Widget _buildUrgencyOption(String level, String description) {
    final isSelected = selectedUrgency == level;
    Color getColor() {
      switch (level) {
        case 'Low':
          return Colors.blue;
        case 'Medium':
          return Colors.orange;
        case 'High':
          return Colors.deepOrange;
        case 'Critical':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return InkWell(
      onTap: () => setState(() => selectedUrgency = level),
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
                  color: isSelected ? getColor() : Colors.grey[400]!,
                  width: 2,
                ),
                color: isSelected ? getColor() : Colors.transparent,
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
                      color: isSelected ? getColor() : Colors.grey[800],
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

  Widget _buildCheckboxTile(
    String title,
    bool value,
    IconData icon,
    Function(bool?) onChanged,
  ) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Row(
        children: [
          Icon(icon, size: 20, color: Colors.orange[700]),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      activeColor: Colors.orange[800],
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Future<void> _submitAlert() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => isSubmitting = false);

    if (!mounted) return;

    // Get selected needs
    List<String> needs = [];
    if (needsEvacuation) needs.add('Evacuation');
    if (needsMedicalAid) needs.add('Medical Aid');
    if (needsShelter) needs.add('Shelter');
    if (needsFood) needs.add('Food & Water');

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[600], size: 28),
            const SizedBox(width: 12),
            const Text("Alert Sent!"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your disaster emergency report has been submitted:"),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.category, "$selectedDisasterType disaster"),
            _buildInfoRow(Icons.location_on, locationController.text),
            _buildInfoRow(Icons.phone, contactController.text),
            _buildInfoRow(Icons.priority_high, "Urgency: $selectedUrgency"),
            if (peopleAffectedController.text.isNotEmpty)
              _buildInfoRow(Icons.people, "${peopleAffectedController.text} people affected"),
            if (needs.isNotEmpty)
              _buildInfoRow(Icons.help, "Needs: ${needs.join(', ')}"),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Emergency services have been notified and will respond shortly.",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.orange[900],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearForm();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    locationController.clear();
    descriptionController.clear();
    contactController.clear();
    peopleAffectedController.clear();
    setState(() {
      selectedDisasterType = 'Flood';
      selectedUrgency = 'High';
      needsEvacuation = false;
      needsMedicalAid = false;
      needsShelter = false;
      needsFood = false;
    });
  }
}