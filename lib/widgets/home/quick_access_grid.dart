import 'package:flutter/material.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      _QuickAccessItem(
        label: 'Network',
        icon: Icons.people_outline,
        route: '/professionals',
      ),
      _QuickAccessItem(
        label: 'Services',
        icon: Icons.handyman_outlined,
        route: '/tradespeople',
      ),
      _QuickAccessItem(
        label: 'Education',
        icon: Icons.school_outlined,
        route: '/education',
      ),
      _QuickAccessItem(
        label: 'Business',
        icon: Icons.business_outlined,
        route: '/businesses',
      ),
    ];

    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.7,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.pushNamed(context, item.route),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _QuickAccessItem {
  final String label;
  final IconData icon;
  final String route;

  const _QuickAccessItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}
