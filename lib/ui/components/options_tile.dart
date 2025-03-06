import 'package:flutter/material.dart';

import '../../constants/app_theme.dart';

class OptionsTile extends StatelessWidget {
  final IconData image;
  final String title;
  final GestureTapCallback? onTap;

  const OptionsTile({
    super.key,
    required this.image,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Row(
          children: [
            Icon(image, size: 40, color: Colors.white),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: appTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
