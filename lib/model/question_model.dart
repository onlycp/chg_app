class QuestionModel {
  final String answer;
  final String question;
  bool select = false;

  QuestionModel({this.answer, this.question});

  QuestionModel.fromJson(Map<String, dynamic> json)
      : answer = json['answer'],
        question = json['question'];
}
