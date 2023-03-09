part of 'create_quiz_cubit.dart';

abstract class CreateQuizState extends Equatable {
  const CreateQuizState();
}

class CreateQuizInitial extends CreateQuizState {
  @override
  List<Object> get props => [];
}

class ChoicesNumChangedState extends CreateQuizState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class QuestionsNumChangedState extends CreateQuizState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class CreateQuizLoadingState extends CreateQuizState {
  @override
  List<Object> get props => [];
}

class CreateQuizSuccessState extends CreateQuizState {
  @override
  List<Object> get props => [];
}

class CreateQuizFailureState extends CreateQuizState {
  final String msg;
  const CreateQuizFailureState({required this.msg});
  @override
  List<Object> get props => [msg];
}
