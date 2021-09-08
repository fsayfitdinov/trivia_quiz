import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiz_app/controllers/quiz/quiz_controller.dart';
import 'package:quiz_app/controllers/quiz/quiz_state.dart';
import 'package:quiz_app/enums/difficulty.dart';
import 'package:quiz_app/models/failure.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/repositories/quiz/quiz_repository.dart';
import 'package:quiz_app/ui/widgets/custom_button.dart';
import 'package:quiz_app/ui/widgets/quiz_error.dart';
import 'package:quiz_app/ui/widgets/quiz_results.dart';

import 'quiz_questions.dart';

final quizQuestionsProvider = FutureProvider.autoDispose<List<Question>>(
  (ref) => ref.watch(quizRepositoryProvider).getQuestions(
        numQuestions: 5,
        categoryId: Random().nextInt(24) + 9,
        diffulty: Difficulty.any,
      ),
);

class QuizScreen extends HookWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quizQuestions = useProvider(quizQuestionsProvider);
    final pageController = usePageController();

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xffd4418e),
            Color(0xff0652c5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: quizQuestions.when(
          data: (questions) => _buildBody(context, pageController, questions),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => QuizError(
            message:
                error is Failure ? error.message ?? '' : 'Something went wrong',
            press: () => context.refresh(quizRepositoryProvider),
          ),
        ),
        bottomSheet: _bottomSheet(context, quizQuestions, pageController),
      ),
    );
  }

  Widget _bottomSheet(BuildContext context,
      AsyncValue<List<Question>> quizQuestions, PageController pageController) {
    return quizQuestions.maybeWhen(
      data: (questions) {
        final quizState = useProvider(quizControllerProvider);
        if (!quizState.answered) return const SizedBox.shrink();
        return CustomButton(
          title: pageController.page!.toInt() + 1 < questions.length
              ? 'Next question'
              : 'See results',
          press: () {
            context
                .read(quizControllerProvider.notifier)
                .nextQuestion(questions, pageController.page!.toInt());
            if (pageController.page!.toInt() + 1 < questions.length) {
              pageController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
            }
          },
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildBody(BuildContext context, PageController controller,
      List<Question> questions) {
    if (questions.isEmpty)
      return QuizError(message: 'No questions found', press: () {});

    final quizState = useProvider(quizControllerProvider);
    if (quizState.status == QuizStatus.complete) {
      return QuizResults(state: quizState, questions: questions);
    } else {
      return QuizQuestions(
        controller: controller,
        state: quizState,
        questions: questions,
      );
    }
  }
}
