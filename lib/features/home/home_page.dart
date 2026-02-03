import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../catalog/presentation/catalog_page.dart';
import 'package:shared/shared.dart';
import '../cart/application/cart_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context);
    final isRTL = locale.languageCode == 'ar';
    final localizations = AppLocalizations.of(context);

    return CustomScrollView(
      slivers: [
        // Sliver App Bar with menu and cart
        SliverAppBar(
          floating: true,
          pinned: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            localizations.tr('app_title'),
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0A1929),
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: isDark ? Colors.white : const Color(0xFF0A1929),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [
            // Cart icon will be added here if needed
            // For now, keep it simple
          ],
        ),

        // Hero Section
        SliverToBoxAdapter(
          child: _HeroSection(
            isDark: isDark,
            isRTL: isRTL,
          ),
        ),

        // Trust Bar Section
        SliverToBoxAdapter(
          child: _TrustBarSection(
            isDark: isDark,
            isRTL: isRTL,
          ),
        ),

        // Categories Section - What are you craving today?
        SliverToBoxAdapter(
          child: _CategoriesSection(
            isDark: isDark,
            isRTL: isRTL,
          ),
        ),

        // Chef's Recommendation / Dish of the Day Section
        SliverToBoxAdapter(
          child: _ChefRecommendationSection(
            isDark: isDark,
            isRTL: isRTL,
          ),
        ),

        // Offers and Special Meals Section with Countdown
        SliverToBoxAdapter(
          child: _OffersSection(
            isDark: isDark,
            isRTL: isRTL,
          ),
        ),

        // Customer Reviews Section
        SliverToBoxAdapter(
          child: _ReviewsSection(
            isDark: isDark,
            isRTL: isRTL,
          ),
        ),

        // Why Us Section
        SliverToBoxAdapter(
          child: _WhyUsSection(
            isDark: isDark,
            isRTL: isRTL,
          ),
        ),

        // Final CTA Section
        SliverToBoxAdapter(
          child: _FinalCTASection(
            isDark: isDark,
            isRTL: isRTL,
          ),
        ),

        // Delivery Truck Animation at the end
        SliverToBoxAdapter(
          child: _DeliveryTruckAnimation(
            isDark: isDark,
            isRTL: isRTL,
          ),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  final bool isDark;
  final bool isRTL;

  const _HeroSection({
    required this.isDark,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final heroHeight = screenHeight * 0.75; // 75% of screen height

    // Sea gradient colors - adapts to theme
    final gradientColors = isDark
        ? [
            const Color(0xFF0A1929), // Deep dark blue
            const Color(0xFF1A2F4A), // Medium dark blue
            const Color(0xFF2A4A6B), // Lighter dark blue
          ]
        : [
            const Color(0xFFE3F2FD), // Light sky blue
            const Color(0xFFBBDEFB), // Light blue
            const Color(0xFF90CAF9), // Medium light blue
            const Color(0xFF64B5F6), // Blue
          ];

    return Container(
      height: heroHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // Animated wave pattern (subtle)
          _WavePattern(isDark: isDark),

          // Content
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Logo (small, elegant)
                  Center(
                    child: Image.asset(
                      'logo.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Main Title
                  Text(
                    localizations.tr('hero_title'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF0A1929),
                          height: 1.2,
                          letterSpacing: isRTL ? 0 : -0.5,
                        ),
                  ),

          const SizedBox(height: 16),

                  // Subtitle
                  Text(
                    localizations.tr('hero_subtitle'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color:
                              isDark ? Colors.white70 : const Color(0xFF546E7A),
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                  ),

                  const Spacer(flex: 2),

                  // CTA Button
          SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to products page
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CatalogPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        backgroundColor: isDark
                            ? const Color(0xFF1976D2)
                            : const Color(0xFF0D47A1),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        localizations.tr('order_now'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Subtle wave pattern decoration
class _WavePattern extends StatelessWidget {
  final bool isDark;

  const _WavePattern({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WavePainter(isDark: isDark),
      child: Container(),
    );
  }
}

class _WavePainter extends CustomPainter {
  final bool isDark;

  _WavePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? const Color(0xFF1A2F4A) : const Color(0xFF90CAF9))
          .withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Create subtle wave pattern
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.65,
      size.width * 0.5,
      size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.75,
      size.width,
      size.height * 0.7,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Second wave (lighter)
    final paint2 = Paint()
      ..color = (isDark ? const Color(0xFF2A4A6B) : const Color(0xFFBBDEFB))
          .withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.85);
    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.8,
      size.width * 0.6,
      size.height * 0.85,
    );
    path2.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.9,
      size.width,
      size.height * 0.85,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Trust Bar Section - Micro Trust Indicators
class _TrustBarSection extends StatelessWidget {
  final bool isDark;
  final bool isRTL;

  const _TrustBarSection({
    required this.isDark,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Primary brand color - unified across the app
    final primaryColor = isDark
        ? const Color(0xFF1976D2) // Blue 700 for dark mode
        : const Color(0xFF0D47A1); // Blue 900 for light mode

    // Trust items data
    final trustItems = [
      _TrustItem(
        icon: Icons.local_shipping_rounded,
        textKey: 'fast_delivery',
        color: primaryColor,
      ),
      _TrustItem(
        icon: Icons.set_meal_rounded,
        textKey: 'daily_catch',
        color: primaryColor,
      ),
      _TrustItem(
        icon: Icons.star_rounded,
        textKey: 'high_ratings',
        color: primaryColor,
      ),
      _TrustItem(
        icon: Icons.local_fire_department_rounded,
        textKey: 'today_offers',
        color: primaryColor,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A1929).withOpacity(0.5) : Colors.white,
      ),
      child: SizedBox(
        height: 80,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: isRTL ? 24.0 : 24.0,
          ),
          itemCount: trustItems.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final item = trustItems[index];
            return _TrustItemCard(
              item: item,
              isDark: isDark,
              localizations: localizations,
            );
          },
        ),
      ),
    );
  }
}

// Trust Item Data Model
class _TrustItem {
  final IconData icon;
  final String textKey;
  final Color color;

  const _TrustItem({
    required this.icon,
    required this.textKey,
    required this.color,
  });
}

// Trust Item Card Widget
class _TrustItemCard extends StatelessWidget {
  final _TrustItem item;
  final bool isDark;
  final AppLocalizations localizations;

  const _TrustItemCard({
    required this.item,
    required this.isDark,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A2F4A).withOpacity(0.6)
            : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? item.color.withOpacity(0.2)
              : item.color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.icon,
              color: item.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          // Text
          Flexible(
            child: Text(
              localizations.tr(item.textKey),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? Colors.white.withOpacity(0.9)
                        : const Color(0xFF0A1929),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Categories Section - What are you craving today?
class _CategoriesSection extends StatelessWidget {
  final bool isDark;
  final bool isRTL;

  const _CategoriesSection({
    required this.isDark,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Primary brand color
    final primaryColor =
        isDark ? const Color(0xFF1976D2) : const Color(0xFF0D47A1);

    // Categories data
    final categories = [
      _CategoryItem(
        icon: Icons.set_meal_rounded,
        textKey: 'category_shrimp',
        gradientColors: [
          const Color(0xFFFF6B6B),
          const Color(0xFFFF8E53),
        ],
      ),
      _CategoryItem(
        icon: Icons.water_drop_rounded,
        textKey: 'category_fish',
        gradientColors: [
          const Color(0xFF4ECDC4),
          const Color(0xFF44A08D),
        ],
      ),
      _CategoryItem(
        icon: Icons.anchor_rounded,
        textKey: 'category_seafood',
        gradientColors: [
          const Color(0xFF667EEA),
          const Color(0xFF764BA2),
        ],
      ),
      _CategoryItem(
        icon: Icons.local_fire_department_rounded,
        textKey: 'category_grilled',
        gradientColors: [
          const Color(0xFFF093FB),
          const Color(0xFFF5576C),
        ],
      ),
      _CategoryItem(
        icon: Icons.restaurant_rounded,
        textKey: 'category_family_meals',
        gradientColors: [
          const Color(0xFF4FACFE),
          const Color(0xFF00F2FE),
        ],
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A1929) : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isRTL ? 24.0 : 24.0,
            ),
            child: Text(
              localizations.tr('what_craving'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0A1929),
                    letterSpacing: isRTL ? 0 : -0.5,
                  ),
            ),
          ),
          const SizedBox(height: 20),

          // Categories List
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: isRTL ? 24.0 : 24.0,
              ),
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final category = categories[index];
                return _CategoryCard(
                  category: category,
                  isDark: isDark,
                  localizations: localizations,
                  primaryColor: primaryColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Category Item Data Model
class _CategoryItem {
  final IconData icon;
  final String textKey;
  final List<Color> gradientColors;

  const _CategoryItem({
    required this.icon,
    required this.textKey,
    required this.gradientColors,
  });
}

// Category Card Widget
class _CategoryCard extends StatefulWidget {
  final _CategoryItem category;
  final bool isDark;
  final AppLocalizations localizations;
  final Color primaryColor;

  const _CategoryCard({
    required this.category,
    required this.isDark,
    required this.localizations,
    required this.primaryColor,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    // Navigate to catalog with category filter
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.category.gradientColors,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.category.gradientColors[0].withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Navigate to products page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CatalogPage(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon with background
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.category.icon,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Category Name
                    Text(
                      widget.localizations.tr(widget.category.textKey),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Chef's Recommendation / Dish of the Day Section
class _ChefRecommendationSection extends ConsumerStatefulWidget {
  final bool isDark;
  final bool isRTL;

  const _ChefRecommendationSection({
    required this.isDark,
    required this.isRTL,
  });

  @override
  ConsumerState<_ChefRecommendationSection> createState() =>
      _ChefRecommendationSectionState();
}

class _ChefRecommendationSectionState
    extends ConsumerState<_ChefRecommendationSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Primary brand color
    final primaryColor =
        widget.isDark ? const Color(0xFF1976D2) : const Color(0xFF0D47A1);

    // Mock dish data
    final dishName = localizations.tr('dish_name_example');
    final dishPrice = localizations.tr('dish_price_example');
    final chefBadge = localizations.tr('chef_choice_badge');

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
          decoration: BoxDecoration(
            color: widget.isDark
                ? const Color(0xFF0A1929)
                : const Color(0xFFF5F5F5),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Background Image with Gradient Overlay
                  Container(
                    height: 320,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: widget.isDark
                          ? const Color(0xFF1A2F4A)
                          : Colors.grey[300],
                    ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                        // Product Image
                        Image.asset(
                          'assets/images/products/lobster.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback gradient if image not found
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    primaryColor.withOpacity(0.3),
                                    primaryColor.withOpacity(0.6),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        // Gradient Overlay for better text readability
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content Overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.85),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Chef's Choice Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  chefBadge,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Dish Name
                          Text(
                            dishName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: widget.isRTL ? 0 : -0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Price and Add to Cart Button Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Price
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    localizations.tr('total'),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dishPrice,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                          left: 4,
                                        ),
                      child: Text(
                                          widget.isRTL ? 'ر.س' : 'SAR',
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
                                ],
                              ),

                              // Add to Cart Button
                              ElevatedButton(
                                onPressed: () {
                                  // Create Product object for chef's recommendation
                                  final product = Product(
                                    id: 'chef_recommendation',
                                    nameAr: dishName,
                                    nameEn: dishName,
                                    imageAssetPath:
                                        'assets/images/products/salmon.jpg',
                                    priceCents:
                                        (double.tryParse(dishPrice) ?? 89.99)
                                                .toInt() *
                                            100,
                                    descriptionAr: 'طبق الشيف المميز',
                                    descriptionEn: 'Chef\'s Special Dish',
                                  );

                                  // Add to cart
                                  ref.read(cartProvider.notifier).add(product);

                                  // Show success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${localizations.tr('add_to_cart')}: $dishName',
                                      ),
                                      backgroundColor: primaryColor,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 6,
                                  backgroundColor: Colors.white,
                                  foregroundColor: primaryColor,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.shopping_cart_rounded,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      localizations.tr('add_to_cart'),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Offers and Special Meals Section with Countdown Timer
class _OffersSection extends StatelessWidget {
  final bool isDark;
  final bool isRTL;

  const _OffersSection({
    required this.isDark,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Primary brand color
    final primaryColor =
        isDark ? const Color(0xFF1976D2) : const Color(0xFF0D47A1);

    // Mock offers data
    final offers = [
      _OfferItem(
        name: localizations.tr('offer_meal_for_two'),
        imagePath: 'assets/images/products/crab.jpg',
        priceBefore: 199.99,
        priceAfter: 149.99,
      ),
      _OfferItem(
        name: localizations.tr('offer_family_meal'),
        imagePath: 'assets/images/products/salmon.jpg',
        priceBefore: 299.99,
        priceAfter: 229.99,
      ),
      _OfferItem(
        name: localizations.tr('offer_daily_discount'),
        imagePath: 'assets/images/products/lobster.jpg',
        priceBefore: 179.99,
        priceAfter: 129.99,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A1929) : const Color(0xFFF5F5F5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header with Countdown
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isRTL ? 24.0 : 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Title
                Row(
                  children: [
                    Text(
                      localizations.tr('offers_special_meals'),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                isDark ? Colors.white : const Color(0xFF0A1929),
                            letterSpacing: isRTL ? 0 : -0.5,
                          ),
                    ),
                  ],
          ),
          const SizedBox(height: 16),

                // Countdown Timer
                _CountdownTimer(
                  isDark: isDark,
                  isRTL: isRTL,
                  primaryColor: primaryColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Offers List
          SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: isRTL ? 24.0 : 24.0,
              ),
              itemCount: offers.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final offer = offers[index];
                return _OfferCard(
                  offer: offer,
                  isDark: isDark,
                  isRTL: isRTL,
                  localizations: localizations,
                  primaryColor: primaryColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Offer Item Data Model
class _OfferItem {
  final String name;
  final String imagePath;
  final double priceBefore;
  final double priceAfter;

  const _OfferItem({
    required this.name,
    required this.imagePath,
    required this.priceBefore,
    required this.priceAfter,
  });
}

// Countdown Timer Widget
class _CountdownTimer extends StatefulWidget {
  final bool isDark;
  final bool isRTL;
  final Color primaryColor;

  const _CountdownTimer({
    required this.isDark,
    required this.isRTL,
    required this.primaryColor,
  });

  @override
  State<_CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<_CountdownTimer> {
  late Duration _remainingTime;
  late Timer _timer;
  bool _isExpired = false;
  DateTime? _expiredAt;

  @override
  void initState() {
    super.initState();
    // Start with 1 week, 2 days, 2 hours, 30 minutes, 45 seconds (mock data)
    _remainingTime = const Duration(
      days: 9, // 1 week + 2 days = 9 days
      hours: 2,
      minutes: 30,
      seconds: 45,
    );

    // Update timer every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_isExpired) {
            // Check if 3 seconds have passed since expiration
            if (_expiredAt != null &&
                DateTime.now().difference(_expiredAt!).inSeconds >= 3) {
              // Reset the timer after 3 seconds
              _isExpired = false;
              _expiredAt = null;
              _remainingTime = const Duration(
                days: 9, // 1 week + 2 days = 9 days
                hours: 2,
                minutes: 30,
                seconds: 45,
              );
            }
          } else if (_remainingTime.inSeconds > 0) {
            _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
          } else {
            // When timer reaches zero, show "Offer Expired" message
            _isExpired = true;
            _expiredAt = DateTime.now();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // If expired, show "Offer Expired" message
    if (_isExpired) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFF4444).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFFF4444).withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: const Color(0xFFFF4444),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              localizations.tr('offer_expired'),
              style: TextStyle(
                color: widget.isDark
                    ? Colors.white.withOpacity(0.9)
                    : const Color(0xFF0A1929),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    // Normal countdown display
    final totalDays = _remainingTime.inDays;
    final weeks = totalDays ~/ 7;
    final days = totalDays % 7;
    final hours = _remainingTime.inHours.remainder(24);
    final minutes = _remainingTime.inMinutes.remainder(60);
    final seconds = _remainingTime.inSeconds.remainder(60);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            color: widget.primaryColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            '${localizations.tr('time_remaining')}: ',
            style: TextStyle(
              color: widget.isDark
                  ? Colors.white.withOpacity(0.9)
                  : const Color(0xFF0A1929),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          // Weeks (only show if > 0)
          if (weeks > 0) ...[
            _TimeUnit(
              value: weeks.toString(),
              label: localizations.tr('weeks'),
              isDark: widget.isDark,
              primaryColor: widget.primaryColor,
            ),
            Text(
              ' : ',
              style: TextStyle(
                color: widget.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
          // Days (only show if weeks > 0 or days > 0)
          if (weeks > 0 || days > 0) ...[
            _TimeUnit(
              value: days.toString(),
              label: localizations.tr('days'),
              isDark: widget.isDark,
              primaryColor: widget.primaryColor,
            ),
            Text(
              ' : ',
              style: TextStyle(
                color: widget.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
          // Hours
          _TimeUnit(
            value: _formatTime(hours),
            label: localizations.tr('hours'),
            isDark: widget.isDark,
            primaryColor: widget.primaryColor,
          ),
          Text(
            ' : ',
            style: TextStyle(
              color: widget.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          // Minutes
          _TimeUnit(
            value: _formatTime(minutes),
            label: localizations.tr('minutes'),
            isDark: widget.isDark,
            primaryColor: widget.primaryColor,
          ),
          Text(
            ' : ',
            style: TextStyle(
              color: widget.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          // Seconds
          _TimeUnit(
            value: _formatTime(seconds),
            label: localizations.tr('seconds'),
            isDark: widget.isDark,
            primaryColor: widget.primaryColor,
          ),
        ],
      ),
    );
  }
}

// Time Unit Widget (for hours, minutes, seconds)
class _TimeUnit extends StatelessWidget {
  final String value;
  final String label;
  final bool isDark;
  final Color primaryColor;

  const _TimeUnit({
    required this.value,
    required this.label,
    required this.isDark,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Offer Card Widget
class _OfferCard extends ConsumerWidget {
  final _OfferItem offer;
  final bool isDark;
  final bool isRTL;
  final AppLocalizations localizations;
  final Color primaryColor;

  const _OfferCard({
    required this.offer,
    required this.isDark,
    required this.isRTL,
    required this.localizations,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discountPercent =
        ((offer.priceBefore - offer.priceAfter) / offer.priceBefore * 100)
            .round();

    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2F4A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Discount Badge
          Stack(
                    children: [
                      ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  color: isDark ? const Color(0xFF2A4A6B) : Colors.grey[300],
                  child: Image.asset(
                    offer.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              primaryColor.withOpacity(0.3),
                              primaryColor.withOpacity(0.6),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Discount Badge
                      Positioned(
                top: 8,
                right: isRTL ? null : 8,
                left: isRTL ? 8 : null,
                child: Container(
                          padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4444),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                          child: Text(
                    '-$discountPercent%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Offer Name
                  Text(
                    offer.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF0A1929),
                          fontSize: 15,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Prices
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Price Before (crossed out)
                      Text(
                        '${offer.priceBefore.toStringAsFixed(2)} ${isRTL ? 'ر.س' : 'SAR'}',
                        style: TextStyle(
                          color: isDark
                              ? Colors.white.withOpacity(0.5)
                              : Colors.grey[600],
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Price After
                      Text(
                        '${offer.priceAfter.toStringAsFixed(2)} ${isRTL ? 'ر.س' : 'SAR'}',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: ElevatedButton(
                      onPressed: () {
                        // Create Product object for the offer
                        final product = Product(
                          id: 'offer_${offer.name.toLowerCase().replaceAll(' ', '_')}',
                          nameAr: offer.name,
                          nameEn: offer.name,
                          imageAssetPath: offer.imagePath,
                          priceCents: (offer.priceAfter * 100).toInt(),
                          descriptionAr: 'عرض خاص',
                          descriptionEn: 'Special Offer',
                        );

                        // Add to cart
                        ref.read(cartProvider.notifier).add(product);

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${localizations.tr('add_to_cart')}: ${offer.name}',
                            ),
                            backgroundColor: primaryColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.shopping_cart_rounded, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            localizations.tr('add_to_cart'),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                          ),
                        ),
                      ),
                    ],
                  ),
    );
  }
}

// Customer Reviews Section
class _ReviewsSection extends StatelessWidget {
  final bool isDark;
  final bool isRTL;

  const _ReviewsSection({
    required this.isDark,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Primary brand color
    final primaryColor =
        isDark ? const Color(0xFF1976D2) : const Color(0xFF0D47A1);

    // Mock reviews data
    final reviews = [
      _ReviewItem(
        name: localizations.tr('review_1_name'),
        text: localizations.tr('review_1_text'),
        rating: 5,
      ),
      _ReviewItem(
        name: localizations.tr('review_2_name'),
        text: localizations.tr('review_2_text'),
        rating: 5,
      ),
      _ReviewItem(
        name: localizations.tr('review_3_name'),
        text: localizations.tr('review_3_text'),
        rating: 5,
      ),
      _ReviewItem(
        name: localizations.tr('review_4_name'),
        text: localizations.tr('review_4_text'),
        rating: 5,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A1929) : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isRTL ? 24.0 : 24.0,
            ),
            child: Text(
              localizations.tr('customer_reviews'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0A1929),
                    letterSpacing: isRTL ? 0 : -0.5,
                  ),
            ),
          ),

          const SizedBox(height: 24),

          // Reviews List
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: isRTL ? 24.0 : 24.0,
              ),
              itemCount: reviews.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final review = reviews[index];
                return _ReviewCard(
                  review: review,
                  isDark: isDark,
                  isRTL: isRTL,
                  primaryColor: primaryColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Review Item Data Model
class _ReviewItem {
  final String name;
  final String text;
  final int rating;

  const _ReviewItem({
    required this.name,
    required this.text,
    required this.rating,
  });
}

// Review Card Widget
class _ReviewCard extends StatelessWidget {
  final _ReviewItem review;
  final bool isDark;
  final bool isRTL;
  final Color primaryColor;

  const _ReviewCard({
    required this.review,
    required this.isDark,
    required this.isRTL,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A2F4A).withOpacity(0.6)
            : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? primaryColor.withOpacity(0.2)
              : primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer Info with Avatar
          Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryColor,
                      primaryColor.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              // Name and Rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                isDark ? Colors.white : const Color(0xFF0A1929),
                            fontSize: 16,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Star Rating
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < review.rating
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: const Color(0xFFFFB300),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Review Text
          Expanded(
            child: Text(
              review.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? Colors.white.withOpacity(0.8)
                        : const Color(0xFF546E7A),
                    height: 1.5,
                    fontSize: 14,
                  ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Why Us Section with Animation
class _WhyUsSection extends StatefulWidget {
  final bool isDark;
  final bool isRTL;

  const _WhyUsSection({
    required this.isDark,
    required this.isRTL,
  });

  @override
  State<_WhyUsSection> createState() => _WhyUsSectionState();
}

class _WhyUsSectionState extends State<_WhyUsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Create staggered animations for each feature
    _fadeAnimations = List.generate(
      3,
      (index) => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.2,
            0.6 + (index * 0.2),
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _scaleAnimations = List.generate(
      3,
      (index) => Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.2,
            0.6 + (index * 0.2),
            curve: Curves.easeOutBack,
          ),
        ),
      ),
    );

    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Primary brand color
    final primaryColor =
        widget.isDark ? const Color(0xFF1976D2) : const Color(0xFF0D47A1);

    // Features data
    final features = [
      _WhyUsFeature(
        icon: Icons.water_drop_rounded,
        title: localizations.tr('why_us_freshness_title'),
        description: localizations.tr('why_us_freshness_desc'),
        color: const Color(0xFF00BCD4), // Cyan for freshness
      ),
      _WhyUsFeature(
        icon: Icons.local_shipping_rounded,
        title: localizations.tr('why_us_speed_title'),
        description: localizations.tr('why_us_speed_desc'),
        color: const Color(0xFF4CAF50), // Green for speed
      ),
      _WhyUsFeature(
        icon: Icons.verified_rounded,
        title: localizations.tr('why_us_quality_title'),
        description: localizations.tr('why_us_quality_desc'),
        color: const Color(0xFFFF9800), // Orange for quality
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      decoration: BoxDecoration(
        gradient: widget.isDark
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF0A1929),
                  const Color(0xFF0F1E2E),
                ],
              )
            : LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  const Color(0xFFF5F7FA),
                ],
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isRTL ? 24.0 : 24.0,
            ),
            child: Text(
              localizations.tr('why_us_title'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        widget.isDark ? Colors.white : const Color(0xFF0A1929),
                    letterSpacing: widget.isRTL ? 0 : -0.5,
                  ),
            ),
          ),

          const SizedBox(height: 32),

          // Features Grid
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isRTL ? 24.0 : 24.0,
            ),
            child: Row(
              children: List.generate(
                features.length,
                (index) {
                  final feature = features[index];
                  return Expanded(
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimations[index],
                          child: ScaleTransition(
                            scale: _scaleAnimations[index],
                            child: _WhyUsFeatureCard(
                              feature: feature,
                              isDark: widget.isDark,
                              isRTL: widget.isRTL,
                              primaryColor: primaryColor,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Why Us Feature Data Model
class _WhyUsFeature {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _WhyUsFeature({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

// Why Us Feature Card Widget
class _WhyUsFeatureCard extends StatelessWidget {
  final _WhyUsFeature feature;
  final bool isDark;
  final bool isRTL;
  final Color primaryColor;

  const _WhyUsFeatureCard({
    required this.feature,
    required this.isDark,
    required this.isRTL,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: isRTL ? 12.0 : 0,
        left: isRTL ? 0 : 12.0,
      ),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2F4A).withOpacity(0.6) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? feature.color.withOpacity(0.2)
              : feature.color.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: feature.color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated Icon Container
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  feature.color,
                  feature.color.withOpacity(0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: feature.color.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              feature.icon,
              color: Colors.white,
              size: 40,
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            feature.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0A1929),
                  fontSize: 18,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            feature.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? Colors.white.withOpacity(0.7)
                      : const Color(0xFF546E7A),
                  height: 1.6,
                  fontSize: 14,
                ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Final CTA Section
class _FinalCTASection extends StatelessWidget {
  final bool isDark;
  final bool isRTL;

  const _FinalCTASection({
    required this.isDark,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Primary brand color
    final primaryColor =
        isDark ? const Color(0xFF1976D2) : const Color(0xFF0D47A1);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  primaryColor.withOpacity(0.2),
                  primaryColor.withOpacity(0.1),
                ]
              : [
                  primaryColor.withOpacity(0.1),
                  primaryColor.withOpacity(0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Product Image Placeholder
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor,
                  primaryColor.withOpacity(0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.restaurant_menu_rounded,
              color: Colors.white,
              size: 60,
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            localizations.tr('final_cta_title'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0A1929),
                  letterSpacing: isRTL ? 0 : -0.5,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Subtitle
          Text(
            localizations.tr('final_cta_subtitle'),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? Colors.white.withOpacity(0.8)
                      : const Color(0xFF546E7A),
                  height: 1.6,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 28),

          // CTA Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to products page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CatalogPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.tr('final_cta_button'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isRTL ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Delivery Truck Animation
class _DeliveryTruckAnimation extends StatefulWidget {
  final bool isDark;
  final bool isRTL;

  const _DeliveryTruckAnimation({
    required this.isDark,
    required this.isRTL,
  });

  @override
  State<_DeliveryTruckAnimation> createState() =>
      _DeliveryTruckAnimationState();
}

class _DeliveryTruckAnimationState extends State<_DeliveryTruckAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Slower animation
    );

    // Animation from right to left (or left to right for RTL)
    _animation = Tween<double>(
      begin: widget.isRTL ? -1.0 : 1.0,
      end: widget.isRTL ? 1.0 : -1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Repeat animation
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final primaryColor =
        widget.isDark ? const Color(0xFF1976D2) : const Color(0xFF0D47A1);

    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 24.0),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              MediaQuery.of(context).size.width * _animation.value * 0.8,
              0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text "اتصل نصل" - transparent background
                Padding(
                  padding: EdgeInsets.only(
                    right: widget.isRTL ? 0 : 12,
                    left: widget.isRTL ? 12 : 0,
                  ),
                  child: Text(
                    localizations.tr('call_we_deliver'),
                    style: TextStyle(
                      color: widget.isDark
                          ? Colors.white.withOpacity(0.9)
                          : const Color(0xFF0A1929),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                // Truck without background
                Opacity(
                  opacity: 0.9,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Stack(
                      children: [
                        // Truck Body
                        Positioned(
                          left: 8,
                          top: 15,
                          child: Container(
                            width: 38,
                            height: 22,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        // Truck Cabin
                        Positioned(
                          left: 4,
                          top: 12,
                          child: Container(
                            width: 15,
                            height: 18,
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.8),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        // Wheels
                        Positioned(
                          left: 9,
                          top: 34,
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: const Color(0xFF333333),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 9,
                          top: 34,
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: const Color(0xFF333333),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        // Delivery Icon
                        Positioned(
                          left: 15,
                          top: 19,
                          child: Icon(
                            Icons.local_shipping_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
