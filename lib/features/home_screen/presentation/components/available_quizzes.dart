import 'package:flutter/material.dart';
import 'package:quiz_admin/core/extensions/string_extension.dart';
import 'package:quiz_admin/core/util/navigator_helper.dart';

import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/app_strings.dart';
import '../../../../resources/colors_manager.dart';
import '../../../create_quiz/presentation/create_quiz_screen.dart';

class AvailableQuizzes extends StatelessWidget {
  final int numOfQuizzes;
  const AvailableQuizzes(this.numOfQuizzes, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${AppStrings.availableQuizzes.tr(context)} ($numOfQuizzes)',
            style: TextStyle(
              color: ColorsManager.whiteColor,
              fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              NavigatorHelper.push(context, const CreateQuizScreen());
            },
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p8),
              child: Text(
                AppStrings.createQuiz.tr(context),
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
