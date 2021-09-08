import 'package:equatable/equatable.dart';
import 'package:quiz_app/models/question_model.dart';

enum QuizStatus {
  initial,
  correct,
  incorrect,
  complete,
}

class QuizState extends Equatable {
  final QuizStatus status;
  final String selectedAnswer;
  final List<Question> correct;
  final List<Question> incorrect;

  QuizState({
    required this.status,
    required this.selectedAnswer,
    required this.correct,
    required this.incorrect,
  });

  bool get answered =>
      status == QuizStatus.correct || status == QuizStatus.incorrect;

  @override
  List<Object?> get props => [
        selectedAnswer,
        correct,
        incorrect,
        status,
      ];

  factory QuizState.initial() => QuizState(
        status: QuizStatus.initial,
        selectedAnswer: '',
        correct: [],
        incorrect: [],
      );

  QuizState copyWith(
      {String? selectedAnswer,
      List<Question>? correct,
      List<Question>? incorrect,
      QuizStatus? status}) {
    return QuizState(
      status: status ?? this.status,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      correct: correct ?? this.correct,
      incorrect: incorrect ?? this.incorrect,
    );
  }
}
