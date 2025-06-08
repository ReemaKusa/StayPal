import 'package:flutter/material.dart';
import 'package:staypal/constants/color_constants.dart';

class AddButton extends StatelessWidget {
  final Widget targetView;
  final VoidCallback? onReturn;

  const AddButton({super.key, required this.targetView, this.onReturn});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add, color: AppColors.white),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => targetView),
        );
        if (context.mounted && onReturn != null) {
          onReturn!();
        }
      },
    );
  }
}
