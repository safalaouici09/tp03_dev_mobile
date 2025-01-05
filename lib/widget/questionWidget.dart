import 'package:flutter/material.dart';

import '../models /question.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final int questionNumber;
  final int totalQuestions;
  final Function(int) onOptionSelected;

  const QuestionWidget({
    Key? key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Question Number

        // Question Card
        Card(
          color: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Question $questionNumber/$totalQuestions",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.help_outline,
                      size: 30,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        question.text,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Options
        ...question.options.asMap().entries.map((entry) {
          int index = entry.key;
          String option = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ElevatedButton(
              onPressed: () => onOptionSelected(index),
              child: Text(option),
            ),
          );
        }).toList(),
      ],
    );
  }
}
