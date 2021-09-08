import 'package:flutter/material.dart';
import 'package:quiz_app/controllers/quiz/quiz_controller.dart';
import 'package:quiz_app/controllers/quiz/quiz_state.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/repositories/quiz/quiz_repository.dart';
import 'package:quiz_app/ui/widgets/custom_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuizResults extends StatelessWidget {
  final QuizState state;
  final List<Question> questions;

  const QuizResults({
    Key? key,
    required this.state,
    required this.questions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${state.correct.length} / ${questions.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Text(
          'CORRECT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 40),
        CustomButton(
          title: 'New Quiz',
          press: () {
            context.refresh(quizRepositoryProvider);
            context.read(quizControllerProvider.notifier).reset();
          },
        )
      ],
    );
  }
}
