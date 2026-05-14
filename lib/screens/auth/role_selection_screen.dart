import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const roles = [
      _RoleOption(
        title: 'Professional',
        description: 'Build a profile for networking and expertise discovery.',
        icon: Icons.people_outline,
      ),
      _RoleOption(
        title: 'Tradesperson',
        description: 'Share practical services and connect with local demand.',
        icon: Icons.handyman_outlined,
      ),
      _RoleOption(
        title: 'Business Owner',
        description: 'List your business and improve community visibility.',
        icon: Icons.storefront_outlined,
      ),
      _RoleOption(
        title: 'Student',
        description: 'Find education opportunities and scholarship resources.',
        icon: Icons.school_outlined,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Choose Your Role')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: roles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final role = roles[index];
          return Card(
            child: ListTile(
              leading:
                  Icon(role.icon, color: Theme.of(context).colorScheme.primary),
              title: Text(role.title),
              subtitle: Text(role.description),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/register'),
            ),
          );
        },
      ),
    );
  }
}

class _RoleOption {
  final String title;
  final String description;
  final IconData icon;

  const _RoleOption({
    required this.title,
    required this.description,
    required this.icon,
  });
}
