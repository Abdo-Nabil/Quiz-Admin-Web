import 'package:flutter/material.dart';
import 'package:quiz_admin/resources/constants_manager.dart';

import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/colors_manager.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  const CustomContainer({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          const BoxConstraints(maxWidth: ConstantsManager.containerMaxWidth),
      padding: const EdgeInsets.all(AppPadding.p32),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppPadding.p16),
          color: ColorsManager.cardColor),
      child: child,
    );
  }
}
