import 'package:AppDown/DataAccess/BaseDAO.dart';
import 'package:AppDown/Shared/Models/QuestionModel.dart';

class QuestionDAO extends BaseDAO<QuestionModel>
{
  @override
  String get tableName => 'Questions';

  @override
  QuestionModel toModel(Map<String, dynamic> map)
  {
    QuestionModel model = new QuestionModel();
    model.id = map['id'];
    model.question = map['question'];

    return model;
  }

  @override
  Map<String, dynamic> toMapData(QuestionModel model)
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = model.id;
    data['question'] = model.question;

    return data;
  }
}