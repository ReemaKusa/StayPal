class SplashModel {
  final DateTime startTime;
  final bool showLoader;

  SplashModel({
    required this.startTime,
    required this.showLoader,
  });

  SplashModel copyWith({
    DateTime? startTime,
    bool? showLoader,
  }) {
    return SplashModel(
      startTime: startTime ?? this.startTime,
      showLoader: showLoader ?? this.showLoader,
    );
  }
}