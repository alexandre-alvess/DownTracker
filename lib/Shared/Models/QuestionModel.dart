class QuestionModel
{
  String id;
  String question;
  String title;

  QuestionModel({this.id, this.question, this.title});

  QuestionModel.getModel(QuestionModel model)
  {
    this.id = model.id;
    this.question = model.question;
    this.title = model.title;
  }
}