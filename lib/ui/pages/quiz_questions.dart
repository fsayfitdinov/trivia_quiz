import 'package:flutter/material.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:quiz_app/controllers/quiz/quiz_controller.dart';
import 'package:quiz_app/controllers/quiz/quiz_state.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiz_app/ui/widgets/answer_card.dart';

class QuizQuestions extends StatelessWidget {
  final PageController controller;
  final QuizState state;
  final List<Question> questions;

  const QuizQuestions({
    Key? key,
    required this.controller,
    required this.state,
    required this.questions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Question ${index + 1} of ${questions.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text(
                HtmlCharacterEntities.decode(question.question),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Divider(
              color: Colors.grey[200],
              height: 32,
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
            Column(
              children: question.answers
                  .map((e) => AnswerCard(
                        answer: e,
                        isSelected: e == state.selectedAnswer,
                        isCorrect: e == question.correctAnswer,
                        isDisplayingAnswer: state.answered,
                        onTap: () => context
                            .read(quizControllerProvider.notifier)
                            .submitAnswer(question, e),
                      ))
                  .toList(),
            )
          ],
        );
      },
    );
  }
}
