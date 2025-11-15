import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile avatar placeholder
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade300,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            
            // User name placeholder
            const Text(
              'User Name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // User email placeholder
            Text(
              'user@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            
            // Placeholder text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Profile page - Design will be implemented here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
