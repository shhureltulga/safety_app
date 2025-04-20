class TrainingQuestion {
  final int id;
  final int instructionId;
  final String question;
  final List<String> choices;
  final String answer;

  TrainingQuestion({
    required this.id,
    required this.instructionId,
    required this.question,
    required this.choices,
    required this.answer,
  });

  factory TrainingQuestion.fromJson(Map<String, dynamic> json) {
    return TrainingQuestion(
      id: json['id'],
      instructionId: json['instructionId'],
      question: json['question'],
      choices: List<String>.from(json['choices']), // ✅ JSON array-ийг шууд авна
      answer: json['answer'],
    );
  }
}
