import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PresensiDialog extends StatelessWidget {
  const PresensiDialog({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: AppColors.surface,
    surfaceTintColor: Colors.transparent,
    insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 358),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    ),
  );
}
