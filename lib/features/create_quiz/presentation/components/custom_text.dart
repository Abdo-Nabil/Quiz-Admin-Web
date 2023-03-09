import 'package:flutter/material.dart';

import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/colors_manager.dart';

class CustomText extends StatelessWidget {
  final String text;
  const CustomText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
      child: Text(
        text,
        style: TextStyle(
          color: ColorsManager.whiteColor,
          fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
        ),
      ),
    );
  }
}
