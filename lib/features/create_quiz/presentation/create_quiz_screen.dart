import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_admin/core/extensions/string_extension.dart';
import 'package:quiz_admin/core/shared/components/add_vertical_space.dart';
import 'package:quiz_admin/core/util/navigator_helper.dart';
import 'package:quiz_admin/features/authentication/presentation/widgets/custom_button.dart';
import 'package:quiz_admin/core/shared/components/build_app_bar.dart';
import 'package:quiz_admin/features/create_quiz/presentation/components/question_container.dart';
import 'package:quiz_admin/features/home_screen/services/models/quiz_model.dart';
import 'package:quiz_admin/resources/colors_manager.dart';
import '../../../../core/shared/components/background_image.dart';
import '../../../../core/util/dialog_helper.dart';
import '../../../../core/util/toast_helper.dart';
import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/app_strings.dart';
import '../../create_quiz/presentation/components/custom_container.dart';
import '../../create_quiz/presentation/components/custom_text.dart';
import '../../create_quiz/presentation/components/rounded_text_field.dart';
import '../../home_screen/presentation/home_screen.dart';
import '../cubits/create_quiz_cubit.dart';

//
class CreateQuizScreen extends StatefulWidget {
  final QuizModel? editedQuiz;
  const CreateQuizScreen({this.editedQuiz, Key? key}) : super(key: key);

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  //

  @override
  void initState() {
    ToastHelper.initializeToast(context);
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    CreateQuizCubit createQuizCubit = CreateQuizCubit.getInst(context);
    //
    if (widget.editedQuiz != null) {
      createQuizCubit.allocateData(widget.editedQuiz!);
    }
    //
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocConsumer<CreateQuizCubit, CreateQuizState>(
        listener: (context, state) {
          if (state is CreateQuizLoadingState) {
            DialogHelper.loadingDialog(context);
          }
          //
          else if (state is CreateQuizSuccessState) {
            Navigator.of(context).pop();
            NavigatorHelper.pushAndRemoveUntil(context, const HomeScreen());
          }
          //
          else if (state is CreateQuizFailureState) {
            Navigator.of(context).pop();
            DialogHelper.messageDialog(context, state.msg);
          }
          //
        },
        buildWhen: (previousState, state) {
          if (state is CreateQuizLoadingState ||
              state is CreateQuizSuccessState ||
              state is CreateQuizFailureState) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: buildAppBar(context: context, showAddMinus: true),
            body: Stack(
              // fit: StackFit.expand,
              children: [
                const BackgroundImage(),
                SafeArea(
                  child: Form(
                    key: CreateQuizCubit.getInst(context).formKey,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppPadding.p24),
                        child: RawScrollbar(
                          controller: createQuizCubit.pageScrollController,
                          radius: const Radius.circular(AppPadding.p8),
                          thumbVisibility: true,
                          thumbColor: ColorsManager.whiteColor.withOpacity(0.5),
                          child: SingleChildScrollView(
                            controller: createQuizCubit.pageScrollController,
                            child: Column(
                              children: [
                                CustomContainer(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                          AppStrings.quizName.tr(context)),
                                      RoundedTextField(
                                          controller: createQuizCubit
                                              .quizNameController,
                                          validate: (value) {
                                            return CreateQuizCubit.getInst(
                                                    context)
                                                .validateNotEmpty(
                                                    context, value);
                                          }),
                                      const AddVerticalSpace(AppPadding.p16),
                                      CustomText(
                                          AppStrings.quizDuration.tr(context)),
                                      RoundedTextField(
                                        controller: createQuizCubit
                                            .quizDurationController,
                                        validate: (value) {
                                          return CreateQuizCubit.getInst(
                                                  context)
                                              .validateIsNumber(context, value);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const AddVerticalSpace(AppPadding.p16),

                                ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: CreateQuizCubit.getInst(context)
                                      .questionsControllers
                                      .length,
                                  separatorBuilder: (context, _) {
                                    return const AddVerticalSpace(
                                        AppPadding.p16);
                                  },
                                  itemBuilder: (context, index) {
                                    return QuestionContainer(index: index);
                                  },
                                ),
                                const AddVerticalSpace(AppPadding.p32),
                                widget.editedQuiz == null
                                    ? CustomButton(
                                        text: AppStrings.createQuiz.tr(context),
                                        onTap: () {
                                          CreateQuizCubit.getInst(context)
                                              .createQuiz();
                                        },
                                      )
                                    : CustomButton(
                                        text: AppStrings.editQuiz.tr(context),
                                        onTap: () {
                                          CreateQuizCubit.getInst(context)
                                              .editQuiz(widget.editedQuiz!);
                                        },
                                      ),

                                // GreetingText(state.userModel.name),
                                // AvailableQuizzes(state.quizzes.length),
                                // Body(quizzes: state.quizzes),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
