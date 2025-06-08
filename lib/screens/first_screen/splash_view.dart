// import 'package:flutter/material.dart';
// import 'splash_viewmodel.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late final SplashViewModel _viewModel;

//   @override
//   void initState() {
//     super.initState();
//     _viewModel = SplashViewModel();
//     _viewModel.initAnimations(this);
//     _viewModel.addListener(_onViewModelChange);
//   }

//   void _onViewModelChange() {
//     if (mounted) setState(() {});
//   }

//   @override
//   void dispose() {
//     _viewModel.removeListener(_onViewModelChange);
//     _viewModel.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.orange[50],
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SlideTransition(
//               position: _viewModel.slideAnimation,
//               child: FadeTransition(
//                 opacity: _viewModel.fadeAnimation,
//                 child: ClipOval(
//                   child: Container(
//                     width: 120,
//                     height: 120,
//                     decoration: BoxDecoration(
//                       color: Colors.deepOrange.withOpacity(0.2),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Image.asset(
//                       'assets/images/hotel_icon.jpg',
//                       width: 120,
//                       height: 120,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return const Icon(
//                           Icons.hotel,
//                           size: 60,
//                           color: Colors.deepOrange,
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ScaleTransition(
//               scale: _viewModel.scaleAnimation,
//               child: Column(
//                 children: [
//                   ShaderMask(
//                     shaderCallback: (bounds) => LinearGradient(
//                       colors: [Colors.orange[800]!, Colors.orange[400]!],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ).createShader(bounds),
//                     child: const Text(
//                       'StayPal',
//                       style: TextStyle(
//                         fontSize: 48,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         shadows: [
//                           Shadow(
//                             blurRadius: 10,
//                             color: Colors.deepOrange,
//                             offset: Offset(2, 2),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Finding the best hotels and events for you',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.orange[700],
//                       fontWeight: FontWeight.w600,
//                       shadows: [
//                         Shadow(
//                           blurRadius: 5,
//                           color: Colors.orange[100]!,
//                           offset: const Offset(1, 1),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (_viewModel.model.showLoader)
//               Padding(
//                 padding: const EdgeInsets.only(top: 30),
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     Colors.deepOrange[700]!,
//                   ),
//                   strokeWidth: 3,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }