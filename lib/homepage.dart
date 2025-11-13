import 'package:flutter/material.dart';
import 'package:vitasafe/hospitalview.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// Handles navigation based on feature name
  void _onTapFeature(BuildContext context, String feature) {
    Widget? targetPage;

    switch (feature) {
      case 'Book Vehicle':
        targetPage = const HospitalView();
        break;
      case 'Book Doctor':
        targetPage = const HospitalView();
        break;
      case 'View Booking Histories':
        targetPage = const HospitalView();
        break;
      case 'Notifications':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening Notifications...')),
        );
        return;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped: $feature')),
        );
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => targetPage!),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, IconData icon, String title, Color color) {
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
                    fontSize: 16, fontWeight: FontWeight.w600, color: color),
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
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.teal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 28,
                    child: Icon(Icons.person, size: 40, color: Colors.teal),
                  ),
                  SizedBox(height: 10),
                  Text('Welcome, User!',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & Support'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, User 👋',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('What would you like to do today?',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),

            // --- Feature Cards ---
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildFeatureCard(
                    context, Icons.directions_car, 'Book Vehicle', Colors.teal),
                _buildFeatureCard(
                    context, Icons.local_hospital, 'Book Doctor', Colors.indigo),
                _buildFeatureCard(context, Icons.history,
                    'View Booking Histories', Colors.orange),
              ],
            ),
            const SizedBox(height: 24),

            // --- Recent Bookings Section ---
            Text('Recent Bookings',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildRecentBooking(
              'Vehicle: Taxi to Airport',
              'Booked on 8 Nov 2025 • Status: Confirmed',
              Icons.directions_car,
            ),
            _buildRecentBooking(
              'Doctor: Dr. Jane Smith (Cardiologist)',
              'Booked on 6 Nov 2025 • Status: Completed',
              Icons.local_hospital,
            ),
          ],
        ),
      ),
    );
  }
}
