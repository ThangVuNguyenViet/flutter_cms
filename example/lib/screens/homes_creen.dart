import 'package:example/configs/home_screen_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.config});

  final HomeScreenConfig config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Section
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: config.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroSection(context),
            ),
            title: Text(
              config.heroTitle,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(config.contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Promotional Banner
                  if (config.showPromotionalBanner) _buildPromotionalBanner(),

                  const SizedBox(height: 24),

                  // Section Title
                  Text(
                    'Featured Items',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: config.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Featured Items
                  _buildFeaturedItems(),

                  const SizedBox(height: 32),

                  // Action Buttons
                  _buildActionButtons(),

                  const SizedBox(height: 24),

                  // Footer Information
                  _buildFooterInfo(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Image.network(
          config.backgroundImageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: config.primaryColor.withValues(alpha: 0.3),
              child: const Icon(
                Icons.image_not_supported,
                size: 64,
                color: Colors.white54,
              ),
            );
          },
        ),

        // Dark Overlay
        if (config.enableDarkOverlay)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
          ),

        // Hero Content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                config.heroTitle,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    const Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 4,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                config.heroSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.4,
                  shadows: [
                    const Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionalBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            config.primaryColor.withValues(alpha: 0.1),
            config.primaryColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: config.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.campaign,
            color: config.primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Special Announcement',
                  style: TextStyle(
                    color: config.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Last updated ${DateFormat('MMM dd, yyyy').format(config.lastUpdated)}',
                  style: TextStyle(
                    color: config.primaryColor.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedItems() {
    final displayItems = config.featuredItems
        .take(config.maxFeaturedItems)
        .toList();

    switch (config.layoutStyle.toLowerCase()) {
      case 'grid':
        return _buildGridLayout(displayItems);
      case 'list':
        return _buildListLayout(displayItems);
      case 'carousel':
        return _buildCarouselLayout(displayItems);
      default:
        return _buildGridLayout(displayItems);
    }
  }

  Widget _buildGridLayout(List<String> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildFeatureCard(items[index], index);
      },
    );
  }

  Widget _buildListLayout(List<String> items) {
    return Column(
      children: items.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildFeatureListItem(entry.value, entry.key),
        );
      }).toList(),
    );
  }

  Widget _buildCarouselLayout(List<String> items) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 12),
            child: _buildFeatureCard(items[index], index),
          );
        },
      ),
    );
  }

  Widget _buildFeatureCard(String item, int index) {
    final icons = [
      Icons.analytics,
      Icons.group,
      Icons.cloud_sync,
      Icons.notifications_active,
      Icons.devices,
      Icons.security,
      Icons.speed,
      Icons.support,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: config.primaryColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: config.primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icons[index % icons.length],
            color: config.primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureListItem(String item, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: config.primaryColor.withValues(alpha: 0.1),
            radius: 20,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: config.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Primary Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: config.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            icon: const Icon(Icons.play_arrow),
            label: Text(
              config.primaryButtonLabel,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),
        // Secondary Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: config.primaryColor,
              side: BorderSide(
                color: config.primaryColor,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.info_outline),
            label: Text(
              config.secondaryButtonLabel,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: config.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Additional Information',
                style: TextStyle(
                  color: config.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _buildInfoRow(
            'Last Updated',
            DateFormat('EEEE, MMMM dd, yyyy \'at\' h:mm a').format(config.lastUpdated),
            Icons.schedule,
          ),

          if (config.externalLink != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              'Learn More',
              config.externalLink!,
              Icons.link,
              isLink: true,
            ),
          ],

          const SizedBox(height: 8),
          _buildInfoRow(
            'Layout Style',
            config.layoutStyle.toUpperCase(),
            Icons.view_module,
          ),

          const SizedBox(height: 8),
          _buildInfoRow(
            'Content Items',
            '${config.featuredItems.length} total (showing ${config.maxFeaturedItems})',
            Icons.list,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {bool isLink = false}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isLink ? config.primaryColor : Colors.grey[800],
              fontSize: 14,
              fontWeight: isLink ? FontWeight.w500 : FontWeight.normal,
              decoration: isLink ? TextDecoration.underline : null,
            ),
          ),
        ),
      ],
    );
  }

}
