import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_admin/core/error/failures.dart';
import 'package:quiz_admin/core/extensions/string_extension.dart';
import 'package:quiz_admin/features/general/services/general_repo.dart';
import 'package:quiz_admin/features/home_screen/services/models/quiz_model.dart';

import '../../../resources/app_strings.dart';
import '../../../resources/constants_manager.dart';
import '../../home_screen/services/models/question_model.dart';
import '../services/create_quiz_reop.dart';

part 'create_quiz_state.dart';

class CreateQuizCubit extends Cubit<CreateQuizState> {
  final CreateQuizRepo createQuizRepo;
  final GeneralRepo generalRepo;
  CreateQuizCubit({
    required this.createQuizRepo,
    required this.generalRepo,
  }) : super(CreateQuizInitial());

  static CreateQuizCubit getInst(BuildContext context) {
    return BlocProvider.of<CreateQuizCubit>(context);
  }

  //may be it dispose them
  @override
  Future<void> close() {
    _disposeControllers();
    return super.close();
  }

  //
  final formKey = GlobalKey<FormState>();
  //
  TextEditingController quizNameController = TextEditingController();
  TextEditingController quizDurationController = TextEditingController();
  ScrollController pageScrollController = ScrollController();
  //
  //this list is filled during the validation of correct answer textFields
  List<int> correctAnswersIndexes = [];
  //
  List<ScrollController> scrollControllers = List.generate(
    ConstantsManager.defaultQuestionNumbers,
    (index) => ScrollController(),
  );
  //
  List<TextEditingController> questionsControllers = List.generate(
    ConstantsManager.defaultQuestionNumbers,
    (index) => TextEditingController(),
  );
  //
  List<TextEditingController> correctAnswersControllers = List.generate(
    ConstantsManager.defaultQuestionNumbers,
    (index) => TextEditingController(),
  );
  //
  List<List<TextEditingController>> choicesControllers = List.generate(
    ConstantsManager.defaultQuestionNumbers,
    (index) => List.generate(
      ConstantsManager.defaultChoicesNumbers,
      (index) => TextEditingController(),
    ),
  );
  //
  //
  addNewQuestion() {
    scrollControllers.add(ScrollController());
    //
    questionsControllers.add(TextEditingController());
    correctAnswersControllers.add(TextEditingController());
    choicesControllers.add(
      [
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
      ],
    );
    //
    pageScrollController.animateTo(
      pageScrollController.position.maxScrollExtent + 550,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.fastOutSlowIn,
    );
    //
    emit(QuestionsNumChangedState());
  }

  //
  removeLastQuestion() {
    if (questionsControllers.length > 1) {
      scrollControllers.removeLast();
      //
      questionsControllers.removeLast();
      correctAnswersControllers.removeLast();
      choicesControllers.removeLast();
      //
      emit(QuestionsNumChangedState());
    }
  }

  //
  onPressAddChoice(int index) {
    ///////////Problem in disposing the new textEditing controller ////////////////
    choicesControllers[index].add(TextEditingController());
    //
    scrollControllers[index].animateTo(
      scrollControllers[index].position.maxScrollExtent + 200,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.fastOutSlowIn,
    );
    emit(ChoicesNumChangedState());
  }

  onPressRemoveChoice(int index) {
    if (choicesControllers[index].length > 2) {
      choicesControllers[index].removeLast();
      emit(ChoicesNumChangedState());
    }
  }

  Future createQuiz() async {
    bool isValid = formKey.currentState!.validate();
    if (isValid) {
      //
      emit(CreateQuizLoadingState());
      QuizModel quizModel = _generateQuizModel();
      await Future.delayed(const Duration(seconds: 2));
      //
      final either = await createQuizRepo.createQuiz(quizModel);
      either.fold(
        (l) {
          _handleFailure(l);
        },
        (r) {
          emit(CreateQuizSuccessState());
          _clearControllers();
        },
      );
      //
    }
  }

  Future editQuiz(QuizModel editedQuiz) async {
    bool isValid = formKey.currentState!.validate();
    if (isValid) {
      //
      emit(CreateQuizLoadingState());
      QuizModel quizModel = _generateQuizModel(editedQuizId: editedQuiz.quizId);
      await Future.delayed(const Duration(seconds: 2));
      //
      final either = await createQuizRepo.editQuiz(quizModel);
      either.fold(
        (l) {
          _handleFailure(l);
        },
        (r) {
          emit(CreateQuizSuccessState());
          _clearControllers();
        },
      );
      //
    }
  }

  _handleFailure(Failure failure) {
    if (failure.runtimeType == ServerFailure) {
      emit(const CreateQuizFailureState(msg: AppStrings.someThingWentWrong));
    }
    //
    else if (failure.runtimeType == OfflineFailure) {
      emit(const CreateQuizFailureState(
          msg: AppStrings.internetConnectionError));
    }
  }

  _generateQuizModel({String? editedQuizId}) {
    List<QuestionModel> questionsList = [];
    for (int x = 0; x < questionsControllers.length; x++) {
      questionsList.add(
        QuestionModel(
          questionId: '${x + 1}',
          question: questionsControllers[x].text,
          options: choicesControllers[x].map((e) => e.text).toList(),
          answerIndex: correctAnswersIndexes[x],
        ),
      );
    }
    return QuizModel(
      quizId: editedQuizId ?? '${DateTime.now().millisecondsSinceEpoch}',
      quizName: quizNameController.text,
      quizDuration: int.parse(quizDurationController.text),
      questions: questionsList,
    );
  }

  validateNotEmpty(BuildContext context, String value) {
    if (value.isEmpty) {
      return AppStrings.emptyValue.tr(context);
    }
    return null;
  }

  validateIsNumber(BuildContext context, String value) {
    if (int.tryParse(value) == null) {
      return AppStrings.enterANumber.tr(context);
    } else if (int.parse(value) <= 0) {
      return AppStrings.enterPositiveNum;
    }
    return null;
  }

  validateCorrectAnswer(BuildContext context, String value, int questionIndex) {
    if (value.isEmpty) {
      return AppStrings.emptyValue.tr(context);
    } else {
      bool isFound = false;

      for (int x = 0; x < choicesControllers[questionIndex].length; x++) {
        if (choicesControllers[questionIndex][x].text == value) {
          //add to AnswerIndexes List
          correctAnswersIndexes.add(x);
          isFound = true;
          break;
        }
      }
      if (!isFound) {
        return AppStrings.correctAnsMustBeOneOfChoices.tr(context);
      }
    }
    return null;
  }

  allocateData(QuizModel quizModel) {
    quizNameController.text = quizModel.quizName;
    quizDurationController.text = quizModel.quizDuration.toString();
    //
    scrollControllers = List.generate(
      quizModel.questions.length,
      (index) => ScrollController(),
    );
    //
    questionsControllers = List.generate(
      quizModel.questions.length,
      (index) =>
          TextEditingController(text: quizModel.questions[index].question),
    );
    //
    correctAnswersControllers = List.generate(
      quizModel.questions.length,
      (index) => TextEditingController(
        text: quizModel
            .questions[index].options[quizModel.questions[index].answerIndex],
      ),
    );
    //
    choicesControllers = List.generate(
      quizModel.questions.length,
      (index) => List.generate(
        quizModel.questions[index].options.length,
        (index2) => TextEditingController(
            text: quizModel.questions[index].options[index2]),
      ),
    );
  }

  //
  //
  _disposeControllers() {
    //
    pageScrollController.dispose();
    quizNameController.dispose();
    quizDurationController.dispose();
    //
    for (int x = 0; x < scrollControllers.length; x++) {
      scrollControllers[x].dispose();
    }
    for (int x = 0; x < questionsControllers.length; x++) {
      questionsControllers[x].dispose();
    }
    for (int x = 0; x < correctAnswersControllers.length; x++) {
      correctAnswersControllers[x].dispose();
    }
    for (int x = 0; x < choicesControllers.length; x++) {
      for (int y = 0; y < choicesControllers[x].length; y++) {
        choicesControllers[x][y].dispose();
      }
    }
  }

  _clearControllers() {
    quizNameController = TextEditingController();
    quizDurationController = TextEditingController();
    pageScrollController = ScrollController();
    correctAnswersIndexes = [];
    //
    scrollControllers = List.generate(
      ConstantsManager.defaultQuestionNumbers,
      (index) => ScrollController(),
    );
    //
    questionsControllers = List.generate(
      ConstantsManager.defaultQuestionNumbers,
      (index) => TextEditingController(),
    );
    //
    correctAnswersControllers = List.generate(
      ConstantsManager.defaultQuestionNumbers,
      (index) => TextEditingController(),
    );
    //
    choicesControllers = List.generate(
      ConstantsManager.defaultQuestionNumbers,
      (index) => List.generate(
        ConstantsManager.defaultChoicesNumbers,
        (index) => TextEditingController(),
      ),
    );
    //
  }
}
