class Question {
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  //final String imageUrl;

  Question({
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    // required this.imageUrl,
  });

  // Add a factory constructor to create a Question from Firestore data
  factory Question.fromFirestore(Map<String, dynamic> data) {
    return Question(
      text: data['text'],
      options: List<String>.from(data['options']),
      correctAnswerIndex: data['correctAnswerIndex'],
      //   imageUrl: data['imageUrl'] ?? '',
    );
  }
}
