import 'package:flutter/material.dart';

import '../../resources/app_margins_paddings.dart';
import '../../../../resources/colors_manager.dart';

class AppTheme {
  static ThemeData lightTheme(Locale locale, BuildContext context) {
    return ThemeData(
      // textTheme: Theme.of(context)
      //     .textTheme
      //     .apply(bodyColor: ColorsManager.whiteColor, displayColor: ColorsManager.whiteColor),
      iconTheme: const IconThemeData(
        color: ColorsManager.whiteColor,
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppPadding.p16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppPadding.p16),
            ),
          ),
          padding:
              MaterialStateProperty.all(const EdgeInsets.all(AppPadding.p8)),
        ),
      ),
    );
  }

  static ThemeData darkTheme(Locale locale, BuildContext context) {
    return ThemeData();
  }
}
