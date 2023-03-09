import 'package:flutter/material.dart';
import 'package:quiz_admin/core/extensions/string_extension.dart';
import 'package:quiz_admin/features/create_quiz/cubits/create_quiz_cubit.dart';

import '../../../../core/shared/components/add_horizontal_space.dart';
import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/app_strings.dart';
import '../../../../resources/colors_manager.dart';

buildAppBar({
  required BuildContext context,
  bool centerTitle = false,
  required bool showAddMinus,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(85),
    child: AppBar(
      centerTitle: centerTitle,
      title: showAddMinus
          ? Padding(
              padding: const EdgeInsets.fromLTRB(
                AppPadding.p24,
                AppPadding.p24,
                AppPadding.p8,
                AppPadding.p8,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.quizAdmin.tr(context),
                        style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .fontSize!,
                          color: ColorsManager.whiteColor,
                        ),
                      ),
                      constraints.maxWidth > 350
                          ? Row(
                              children: [
                                CircleAvatar(
                                  child: IconButton(
                                      onPressed: () {
                                        CreateQuizCubit.getInst(context)
                                            .removeLastQuestion();
                                      },
                                      icon: const Icon(Icons.remove)),
                                ),
                                const AddHorizontalSpace(AppPadding.p8),
                                CircleAvatar(
                                  child: IconButton(
                                      onPressed: () {
                                        CreateQuizCubit.getInst(context)
                                            .addNewQuestion();
                                      },
                                      icon: const Icon(Icons.add)),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  );
                },
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(
                AppPadding.p24,
                AppPadding.p24,
                AppPadding.p8,
                AppPadding.p8,
              ),
              child: Text(
                AppStrings.quizAdmin.tr(context),
                style: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.headlineLarge!.fontSize!,
                  color: ColorsManager.whiteColor,
                ),
              ),
            ),
      backgroundColor: Colors.transparent,
      // backgroundColor: Color(0x44000000),
      // elevation: 0,
    ),
  );
}
