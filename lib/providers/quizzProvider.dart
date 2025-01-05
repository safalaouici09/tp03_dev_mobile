import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models /question.dart';

class QuizProvider extends ChangeNotifier {
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;

  Future<void> fetchQuestions() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('questions').get();

      questions = snapshot.docs.map((doc) {
        return Question(
          text: doc['text'],
          options: List<String>.from(doc['options']),
          correctAnswerIndex: doc['correctAnswerIndex'],
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      print("Error fetching questions: $e");
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
    }
  }

  bool checkAnswer(int selectedIndex) {
    bool isCorrect =
        selectedIndex == questions[currentQuestionIndex].correctAnswerIndex;

    if (isCorrect) {
      score++;
    }

    notifyListeners();
    return isCorrect;
  }

  bool isQuizCompleted() {
    return currentQuestionIndex >= questions.length;
  }

  void resetQuiz() {
    currentQuestionIndex = 0;
    score = 0;
    notifyListeners();
  }
}
