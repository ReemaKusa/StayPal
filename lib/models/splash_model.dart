
class SplashModel {
  final DateTime startTime;
  final bool showLoader;
  final bool animationComplete;

  SplashModel({
    required this.startTime,
    required this.showLoader,
    required this.animationComplete,
  });

  SplashModel copyWith({
    DateTime? startTime,
    bool? showLoader,
    bool? animationComplete,
  }) {
    return SplashModel(
      startTime: startTime ?? this.startTime,
      showLoader: showLoader ?? this.showLoader,
      animationComplete: animationComplete ?? this.animationComplete,
    );
  }
}