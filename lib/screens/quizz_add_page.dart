import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  int _correctAnswerIndex = 0;

  void _addQuestionToFirebase() async {
    if (_questionController.text.isNotEmpty &&
        _optionControllers.every((controller) => controller.text.isNotEmpty)) {
      final question = {
        'text': _questionController.text,
        'options': _optionControllers.map((c) => c.text).toList(),
        'correctAnswerIndex': _correctAnswerIndex,
      };

      await FirebaseFirestore.instance.collection('questions').add(question);

      // Reset form
      _questionController.clear();
      _optionControllers.forEach((controller) => controller.clear());
      setState(() {
        _correctAnswerIndex = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Question added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            ...List.generate(4, (index) {
              return TextField(
                controller: _optionControllers[index],
                decoration: InputDecoration(labelText: 'Option ${index + 1}'),
              );
            }),
            DropdownButton<int>(
              value: _correctAnswerIndex,
              onChanged: (value) {
                setState(() {
                  _correctAnswerIndex = value!;
                });
              },
              items: List.generate(4, (index) {
                return DropdownMenuItem(
                  value: index,
                  child: Text('Correct Answer: Option ${index + 1}'),
                );
              }),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addQuestionToFirebase,
              child: Text('Add Question'),
            ),
          ],
        ),
      ),
    );
  }
}
