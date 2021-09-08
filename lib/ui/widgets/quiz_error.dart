import 'package:flutter/material.dart';

import 'custom_button.dart';

class QuizError extends StatelessWidget {
  final String message;
  final VoidCallback press;

  const QuizError({
    Key? key,
    required this.message,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            title: 'Retry',
            press: press,
          ),
        ],
      ),
    );
  }
}
