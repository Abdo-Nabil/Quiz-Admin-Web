import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_admin/features/create_quiz/cubits/create_quiz_cubit.dart';

import '../../../../core/shared/components/add_horizontal_space.dart';
import '../../../../core/shared/components/add_vertical_space.dart';
import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/app_strings.dart';
import '../../../../resources/colors_manager.dart';
import '../../../create_quiz/presentation/components/custom_container.dart';
import '../../../create_quiz/presentation/components/custom_text.dart';
import '../../../create_quiz/presentation/components/rounded_text_field.dart';

class QuestionContainer extends StatelessWidget {
  final int index;

  const QuestionContainer({
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final createQuizCubit = CreateQuizCubit.getInst(context);
    //
    return Align(
      child: CustomContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText('${AppStrings.question} ${index + 1}'),
            RoundedTextField(
              controller: createQuizCubit.questionsControllers[index],
              validate: (value) {
                return CreateQuizCubit.getInst(context).validateNotEmpty(value);
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  0, AppPadding.p16, AppPadding.p32, AppPadding.p8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(AppStrings.choices),
                  Row(
                    children: [
                      CircleAvatar(
                        child: IconButton(
                            onPressed: () {
                              createQuizCubit.onPressRemoveChoice(index);
                            },
                            icon: const Icon(Icons.remove)),
                      ),
                      const AddHorizontalSpace(AppPadding.p8),
                      CircleAvatar(
                        child: IconButton(
                            onPressed: () {
                              createQuizCubit.onPressAddChoice(index);
                            },
                            icon: const Icon(Icons.add)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: RawScrollbar(
                radius: const Radius.circular(AppPadding.p8),
                thumbVisibility: true,
                thumbColor: ColorsManager.whiteColor.withOpacity(0.5),
                controller: createQuizCubit.scrollControllers[index],
                child: BlocBuilder<CreateQuizCubit, CreateQuizState>(
                  //
                  buildWhen: (p, s) {
                    if (s is ChoicesNumChangedState) {
                      return true;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    //
                    return ListView.separated(
                      controller: createQuizCubit.scrollControllers[index],
                      shrinkWrap: true,
                      itemCount:
                          createQuizCubit.choicesControllers[index].length,
                      separatorBuilder: (context, _) {
                        return const AddVerticalSpace(AppPadding.p8);
                      },
                      itemBuilder: (context, z) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppPadding.p16),
                          child: Row(
                            children: [
                              CustomText('(${z + 1})  '),
                              Expanded(
                                child: RoundedTextField(
                                  controller: createQuizCubit
                                      .choicesControllers[index][z],
                                  validate: (value) {
                                    return CreateQuizCubit.getInst(context)
                                        .validateNotEmpty(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const CustomText(AppStrings.correctAnswer),
            RoundedTextField(
                controller: createQuizCubit.correctAnswersControllers[index],
                isGreenBorder: true,
                validate: (value) {
                  return CreateQuizCubit.getInst(context)
                      .validateCorrectAnswer(value, index);
                }),
          ],
        ),
      ),
    );
  }
}
