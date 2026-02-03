import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../splash/splash_page.dart';
import '../shell/shell_scaffold.dart';
import '../../l10n/app_localizations.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    ref.read(firstRunProvider.notifier).state = false;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ShellScaffold()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context);
    final isRTL = locale.languageCode == 'ar';
    final primaryColor =
        isDark ? const Color(0xFF1976D2) : const Color(0xFF0D47A1);

    final pages = [
      _OnboardingSlide(
        title: t.tr('onboard1_title'),
        description: t.tr('onboard1_desc'),
        icon: Icons.restaurant_menu_rounded,
        primaryColor: primaryColor,
        isDark: isDark,
        isRTL: isRTL,
      ),
      _OnboardingSlide(
        title: t.tr('onboard2_title'),
        description: t.tr('onboard2_desc'),
        icon: Icons.set_meal_rounded,
        primaryColor: primaryColor,
        isDark: isDark,
        isRTL: isRTL,
      ),
      _OnboardingSlide(
        title: t.tr('onboard3_title'),
        description: t.tr('onboard3_desc'),
        icon: Icons.local_offer_rounded,
        primaryColor: primaryColor,
        isDark: isDark,
        isRTL: isRTL,
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0A1929),
                    const Color(0xFF1A2F4A),
                    const Color(0xFF0F1E2E),
                  ]
                : [
                    const Color(0xFFE3F2FD),
                    const Color(0xFFBBDEFB),
                    const Color(0xFF90CAF9),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button (Top Right)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment:
                      isRTL ? Alignment.centerLeft : Alignment.centerRight,
                  child: TextButton(
                    onPressed: _navigateToHome,
                    child: Text(
                      t.tr('skip'),
                      style: TextStyle(
                        color: isDark
                            ? Colors.white.withOpacity(0.8)
                            : primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              // PageView with slides
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) => pages[index],
                ),
              ),

              // Page Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => _PageIndicator(
                    isActive: index == _currentPage,
                    primaryColor: primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Navigation Buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: Row(
                  children: [
                    // Previous Button (only show if not first page)
                    if (_currentPage > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: BorderSide(color: primaryColor, width: 2),
                          ),
                          child: Text(
                            isRTL ? 'السابق' : 'Previous',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    if (_currentPage > 0) const SizedBox(width: 16),

                    // Next / Start Shopping Button
                    Expanded(
                      flex: _currentPage == 0 ? 1 : 1,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage < pages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _navigateToHome();
                          }
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
                              _currentPage < pages.length - 1
                                  ? t.tr('next')
                                  : t.tr('start_shopping'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              isRTL
                                  ? Icons.arrow_back_ios
                                  : Icons.arrow_forward_ios,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// Onboarding Slide Widget
class _OnboardingSlide extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final bool isDark;
  final bool isRTL;

  const _OnboardingSlide({
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.isDark,
    required this.isRTL,
  });

  @override
  State<_OnboardingSlide> createState() => _OnboardingSlideState();
}

class _OnboardingSlideState extends State<_OnboardingSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with Animation
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.primaryColor,
                      widget.primaryColor.withOpacity(0.7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.primaryColor.withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: Image.asset(
                    'logo.png',
                    width: 140,
                    height: 140,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 70,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Title
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: widget.isDark
                          ? Colors.white
                          : const Color(0xFF0A1929),
                      letterSpacing: widget.isRTL ? 0 : -0.5,
                      height: 1.3,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Description
              Text(
                widget.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: widget.isDark
                          ? Colors.white.withOpacity(0.8)
                          : const Color(0xFF546E7A),
                      height: 1.6,
                      fontSize: 16,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Decorative Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: widget.primaryColor,
                  size: 48,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Page Indicator Widget
class _PageIndicator extends StatelessWidget {
  final bool isActive;
  final Color primaryColor;

  const _PageIndicator({
    required this.isActive,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? primaryColor : primaryColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
