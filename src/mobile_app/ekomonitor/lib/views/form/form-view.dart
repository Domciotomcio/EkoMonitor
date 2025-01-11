import 'package:ekomonitor/data/questions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Question {
  final String question;
  final String answerA;
  final String answerB;
  final String answerC;
  final String answerD;
  final int? selectedAnswer; // 0, 1, 2, 3

  Question({
    required this.question,
    required this.answerA,
    required this.answerB,
    required this.answerC,
    required this.answerD,
    this.selectedAnswer,
  });

  copyWith({required int selectedAnswer}) {
    return Question(
      question: question,
      answerA: answerA,
      answerB: answerB,
      answerC: answerC,
      answerD: answerD,
      selectedAnswer: selectedAnswer,
    );
  }
}

class QuestionsNotifier extends StateNotifier<List<Question>> {
  QuestionsNotifier(List<Question> state) : super(state);

  void selectAnswer(int questionIndex, int answer) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == questionIndex)
          state[i].copyWith(selectedAnswer: answer)
        else
          state[i],
    ];
  }
}

final questionsProvider =
    StateNotifierProvider<QuestionsNotifier, List<Question>>((ref) {
  return QuestionsNotifier(QUESTIONS);
});

class FormView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Form for new user'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return QuestionView(
                    question: question,
                    onAnswerSelected: (answer) {
                      ref
                          .read(questionsProvider.notifier)
                          .selectAnswer(index, answer!);
                    });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final allAnswered = questions.every(
                            (question) => question.selectedAnswer != null);

                        if (!allAnswered) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please answer all questions'),
                            ),
                          );
                          return;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('All questions answered!'),
                            ),
                          );
                          
                        }

                        // save answers
                        // Navigator.of(context).pop();
                      },
                      child: Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionView extends StatelessWidget {
  final Question question;
  final ValueChanged<int?> onAnswerSelected;

  QuestionView({required this.question, required this.onAnswerSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(question.question),
        SizedBox(height: 10),
        RadioListTile(
          title: Text(question.answerA),
          value: 0,
          groupValue: question.selectedAnswer,
          onChanged: (value) => onAnswerSelected(value),
        ),
        RadioListTile(
          title: Text(question.answerB),
          value: 1,
          groupValue: question.selectedAnswer,
          onChanged: (value) => onAnswerSelected(value),
        ),
        RadioListTile(
          title: Text(question.answerC),
          value: 2,
          groupValue: question.selectedAnswer,
          onChanged: (value) => onAnswerSelected(value),
        ),
        RadioListTile(
          title: Text(question.answerD),
          value: 3,
          groupValue: question.selectedAnswer,
          onChanged: (value) => onAnswerSelected(value),
        ),
      ],
    );
  }
}
