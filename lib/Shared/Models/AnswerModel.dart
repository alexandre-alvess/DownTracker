class AnswerModel 
{
  String id;
  String answer;
  String question;
  String dataInclusao;
  String monitored;
  String imageUrl;

  AnswerModel({this.id, 
               this.question, 
               this.answer, 
               this.dataInclusao, 
               this.monitored, 
               this.imageUrl});

  AnswerModel.getModel(AnswerModel model)
  {
    this.id = model.id;
    this.question = model.question;
    this.answer = model.answer;
    this.dataInclusao = model.dataInclusao;
    this.monitored = model.monitored;
    this.imageUrl = model.imageUrl;
  }
}