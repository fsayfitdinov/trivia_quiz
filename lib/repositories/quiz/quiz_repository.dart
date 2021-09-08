import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiz_app/models/failure.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/enums/difficulty.dart';
import 'package:quiz_app/repositories/quiz/base_quiz_repository.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final quizRepositoryProvider =
    Provider<QuizRepository>((ref) => QuizRepository(ref.read));

class QuizRepository extends BaseQuizRepository {
  final Reader _read;

  QuizRepository(this._read);

  @override
  Future<List<Question>> getQuestions(
      {required int numQuestions,
      required int categoryId,
      required Difficulty diffulty}) async {
    try {
      final queryParams = {
        'type': 'multiple',
        'amount': numQuestions,
        'category': categoryId,
      };
      final response = await _read(dioProvider).get(
        'https://opentdb.com/api.php',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.data);
        final results = List<Map<String, dynamic>>.from(data['results']);
        if (results.isNotEmpty) {
          return results.map((e) => Question.fromMap(e)).toList();
        }
      }
      return [];
    } on DioError catch (err) {
      throw Failure(message: err.response?.statusMessage);
    } on SocketException {
      throw const Failure(message: 'No internet connection');
    }
  }
}
