import 'package:flutter/material.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../../widgets/home/hero_banner.dart';
import '../../widgets/home/quick_access_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('Virtual Tigray'),
              background: HeroBanner(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => Navigator.pushNamed(context, '/search'),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => Navigator.pushNamed(context, '/notifications'),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const QuickAccessGrid(),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    title: 'Professional Networking',
                    icon: Icons.people,
                    onTap: () => Navigator.pushNamed(context, '/professionals'),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    context,
                    title: 'Local Tradespeople',
                    icon: Icons.handyman,
                    onTap: () => Navigator.pushNamed(context, '/tradespeople'),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    context,
                    title: 'Education & Scholarships',
                    icon: Icons.school,
                    onTap: () => Navigator.pushNamed(context, '/education'),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    context,
                    title: 'Business Directory',
                    icon: Icons.business,
                    onTap: () => Navigator.pushNamed(context, '/businesses'),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDAA520).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 30, color: const Color(0xFFDAA520)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
