import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audioplayers/audioplayers.dart';

import '../providers/quizzProvider.dart';
import '../widget/questionWidget.dart';

class QuizzPage extends StatefulWidget {
  @override
  State<QuizzPage> createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> {
  bool _isLoading = true;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final String correctSoundUrl =
      "https://res.cloudinary.com/dlpp5i2wa/video/upload/v1736077040/sounds/wm0ppgq3j5qyvalda1m4.mp3";
  final String incorrectSoundUrl =
      "https://res.cloudinary.com/dlpp5i2wa/video/upload/v1736077040/sounds/ju6zzlfgskyofgqhojmf.mp3";

  @override
  void initState() {
    super.initState();
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    _initializeQuiz(quizProvider);
  }

  Future<void> _initializeQuiz(QuizProvider quizProvider) async {
    await quizProvider.fetchQuestions();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _playAnswerSound(bool isCorrect) async {
    try {
      await _audioPlayer
          .play(UrlSource(isCorrect ? correctSoundUrl : incorrectSoundUrl));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void _showResultDialog(QuizProvider quizProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Quiz Completed!"),
        content: Text("Your final score is: ${quizProvider.score}"),
        actions: [
          TextButton(
            onPressed: () {
              quizProvider.resetQuiz();
              Navigator.pop(ctx);
              setState(() {
                _isLoading = true;
              });
              _initializeQuiz(quizProvider);
            },
            child: const Text("Restart Quiz"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 3,
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(164, 47, 193, 1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          print("Settings clicked");
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        user?.photoURL != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(user!.photoURL!),
                                radius: 40,
                              )
                            : const CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.person,
                                    size: 40, color: Colors.white),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 6,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : QuestionWidget(
                      question: quizProvider
                          .questions[quizProvider.currentQuestionIndex],
                      questionNumber: quizProvider.currentQuestionIndex + 1,
                      totalQuestions: quizProvider.questions.length,
                      onOptionSelected: (selectedOption) async {
                        final isCorrect =
                            quizProvider.checkAnswer(selectedOption);
                        print("correct " + isCorrect.toString());

                        if (isCorrect != null) {
                          await _playAnswerSound(isCorrect);

                          if (quizProvider.isQuizCompleted()) {
                            _showResultDialog(quizProvider);
                          } else {
                            quizProvider.nextQuestion();
                          }
                        }
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
