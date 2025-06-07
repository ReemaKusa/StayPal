import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  bool _showImage = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
    _verifyImage();
  }

  Future<void> _verifyImage() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final exists = manifest.listAssets().contains('assets/icon/flutter_app_logo.png');
      
      if (!exists && mounted) {
        setState(() => _showImage = false);
        debugPrint('Image not found in assets');
      }
    } catch (e) {
      if (mounted) setState(() => _showImage = false);
      debugPrint('Error verifying image: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: _buildLogo(),
              ),
            ),
            const SizedBox(height: 30),
            _buildAppName(),
            const SizedBox(height: 10),
            _buildSubtitle(),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      color: Colors.orange[50], 
      child: _showImage
          ? Image.asset(
              'assets/icon/flutter_app_logo.png',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
              color: Colors.orange[50],
              colorBlendMode: BlendMode.darken, 
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Image load error: $error');
                return _buildFallbackIcon();
              },
            )
          : _buildFallbackIcon(),
    );
  }

  Widget _buildFallbackIcon() {
    return Icon(
      Icons.hotel,
      size: 60,
      color: Colors.deepOrange[700],
    );
  }

  Widget _buildAppName() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFFFF8C00), Color(0xFFFFA500)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: const Text(
        'StayPal',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Your perfect stay starts here',
      style: TextStyle(
        fontSize: 18,
        color: Colors.orange[700],
        fontWeight: FontWeight.w500,
      ),
    );
  }
}