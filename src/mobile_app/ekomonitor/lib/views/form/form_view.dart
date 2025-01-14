import 'package:ekomonitor/data/questions.dart';
import 'package:ekomonitor/data/user_profile/providers/user_profile_provider.dart';
import 'package:ekomonitor/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Question {
  final String question;
  final String answerA;
  final String answerB;
  final String answerC;
  final String answerD;
  final String answerE;
  final String? selectedAnswer;

  Question({
    required this.question,
    required this.answerA,
    required this.answerB,
    required this.answerC,
    required this.answerD,
    required this.answerE,
    this.selectedAnswer,
  });

  copyWith({required String selectedAnswer}) {
    return Question(
      question: question,
      answerA: answerA,
      answerB: answerB,
      answerC: answerC,
      answerD: answerD,
      answerE: answerE,
      selectedAnswer: selectedAnswer,
    );
  }
}

class QuestionsNotifier extends StateNotifier<List<Question>> {
  QuestionsNotifier(List<Question> state) : super(state);

  void selectAnswer(int questionIndex, String answer) {
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
  const FormView({super.key});

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
                        final userId = ref.read(userProvider)!.userId;
                        ref.read(userProfileProvider.notifier).updateUserProfileWithForm(userId, questions);

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
  final ValueChanged<String?> onAnswerSelected;

  QuestionView({super.key, required this.question, required this.onAnswerSelected});

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
          value: 'Very interested',
          groupValue: question.selectedAnswer,
          onChanged: (value) => onAnswerSelected(value),
        ),
        RadioListTile(
          title: Text(question.answerB),
          value: 'Often',
          groupValue: question.selectedAnswer,
          onChanged: (value) => onAnswerSelected(value),
        ),
        RadioListTile(
          title: Text(question.answerC),
          value: 'Sometimes',
          groupValue: question.selectedAnswer,
          onChanged: (value) => onAnswerSelected(value),
        ),
        RadioListTile(
          title: Text(question.answerD),
          value: 'Somewhat concerned',
          groupValue: question.selectedAnswer,
          onChanged: (value) => onAnswerSelected(value),
        ),
        RadioListTile(
          title: Text(question.answerD),
          value: 'Somewhat important',
          groupValue: question.selectedAnswer,
          onChanged: (value) => onAnswerSelected(value),
        ),
      ],
    );
  }
}
