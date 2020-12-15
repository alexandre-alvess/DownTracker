import 'package:AppDown/DataAccess/BaseDAO.dart';
import 'package:AppDown/Shared/Models/AnswerModel.dart';

class AnswerDAO extends BaseDAO<AnswerModel>
{
  @override
  String get tableName => 'Answers';

  @override
  AnswerModel toModel(Map<String, dynamic> map)
  {
    AnswerModel model = new AnswerModel();
    model.id = map['id'];
    //model.questionID = map['questionID'];
    model.answer = map['answer'];
    model.dataInclusao = map['dataInclusao'];
    //model.userId = map['userId'];

    return model;
  }

  @override
  Map<String, dynamic> toMapData(AnswerModel model)
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = model.id;
    //data['questionID'] = model.questionID;
    data['answer'] = model.answer;
    data['dataInclusao'] = model.dataInclusao;
    //data['userId'] = model.userId;

    return data;
  }
}