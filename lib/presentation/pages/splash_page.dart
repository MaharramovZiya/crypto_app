import 'package:crypto_app/ui/base/base_button.dart';
import 'package:crypto_app/ui/base/base_text_widget.dart';
import 'package:crypto_app/ui/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:crypto_app/ui/base/base_rich_text_widget.dart';
import 'package:crypto_app/core/constants/app_constants.dart';
import 'package:crypto_app/core/constants/app_colors.dart';
import 'package:crypto_app/core/router/app_router.dart';
import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';

// import '../../core/router/app_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Fade Animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // Scale Animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Slide Animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations in sequence
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _scaleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Consider screens smaller than 700px as small screens
    final isSmallScreen = screenHeight < 700;

    Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              // Logo/Title with Fade and Scale animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: BaseRichText(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    first: AppConstants.appName,
                    second: 'X',
                    firstColor: AppColors.textPrimary,
                    secondColor: AppColors.buttonPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 26),

              // Image with Scale animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(AppPngImages.shape.image),
                ),
              ),

              const SizedBox(height: 16),

              // Tagline with Slide animation
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: BaseText(
                    AppConstants.appTagline,
                    style: const TextStyle(
                      fontSize: 32,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Small Tagline with Slide animation
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: BaseText(
                    AppConstants.appSmallTagLine,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Button with Slide animation
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: BaseButton(
                    label: AppConstants.appButtonLabel,
                    width: double.maxFinite,
                    borderRadius: 20,
                    height: 50,
                    onPressed: () => context.go(AppRouter.main),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    // Wrap with SingleChildScrollView only on small screens
    if (isSmallScreen) {
      content = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
          ),
          child: content,
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: content,
    );
  }
}
