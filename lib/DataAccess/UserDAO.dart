import 'package:AppDown/DataAccess/BaseDAO.dart';
import 'package:AppDown/Shared/Models/UserModel.dart';

class UserDAO extends BaseDAO<UserModel>
{
  @override
  String get tableName => 'User';

  @override
  UserModel toModel(Map<String, dynamic> map)
  {
    UserModel model = new UserModel();
    model.nome = map['nome'];
    model.tipoUser = map['tipoUser'];
    model.tipo = map['tipoUser'] == 'Monitor' ? TipoUser.Monitor : TipoUser.Monitorado;
    return model;
  }

  @override
  Map<String, dynamic> toMapData(UserModel model)
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = model.id;
    data['nome'] = model.nome;
    data['tipoUser'] = model.tipoUser;

    return data;
  }

}