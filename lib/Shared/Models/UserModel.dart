enum TipoUser 
{ 
  Monitor, 
  Monitorado,
  Standard 
}
const String _monitor = 'Monitor';
const String _monitorado = 'Monitorado';

class UserModel
{
  final int id = 1;
  String nome;
  String tipoUser;
  TipoUser tipo;
  String userAuthId;

  UserModel({this.nome, this.tipo, this.userAuthId})
  {
    this.tipoUser = tipo == TipoUser.Monitor ? _monitor : _monitorado;
  }

  UserModel.getModel(UserModel model)
  {
    this.nome = model.nome;
    this.tipoUser = model.tipo == TipoUser.Monitor ? _monitor : _monitorado;
    this.userAuthId = model.userAuthId;
  }
}