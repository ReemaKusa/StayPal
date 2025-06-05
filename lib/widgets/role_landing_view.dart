import 'package:flutter/material.dart';
import 'package:staypal/services/role_router_service.dart';

class RoleLandingView extends StatelessWidget {
  const RoleLandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: RoleRouterService().getStartView(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return snapshot.data!;
      },
    );
  }
}