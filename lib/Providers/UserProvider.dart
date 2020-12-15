import 'package:AppDown/DataAccess/UserDAO.dart';
import 'package:AppDown/Shared/Models/UserModel.dart';
import 'package:AppDown/Shared/Services/SessionService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

const String _monitor = "Monitor";

class UserProvider with ChangeNotifier
{
  final serviceDAO = new UserDAO();

  UserModel _item;

  String get itemName 
  {
    if (_item.nome == null)
    {
      _crieUsuarioPadrao();
    }
    return _item.nome;
  }

  TipoUser get tipoUser
  {
    return _item.tipo;
  }

  String get itemuserAuthId
  {
    return _item.userAuthId;
  }

  Future<void> loadUserFirebase() async
  {
    _item = null;
    final userSession = await SessionService.getSessionMap();

    print('loadUserFirebase - User: ${userSession['userId']}');

    var query = await FirebaseFirestore.instance
                      .collection('users')
                      .where('userAuthId', isEqualTo: userSession['userId']).get();

    if (query.docs.length > 0)
    {
      var modelData = query.docs.first.data();

      _item = new UserModel();
      _item.nome = modelData['name'];
      _item.tipoUser = modelData['tipoUser'];
      _item.userAuthId = modelData['userAuthId'];
      _item.tipo = modelData['tipoUser'] == _monitor ? TipoUser.Monitor : TipoUser.Monitorado;
    }

    if (_item == null)
    {
      _crieUsuarioPadrao();
    }
  }

  void _crieUsuarioPadrao()
  {
    _item = new UserModel();
    _item.nome = 'Usuário Padrão';
    _item.tipoUser = 'Standard User';
    _item.userAuthId = '-123456';
    _item.tipo = TipoUser.Standard;
  }

  Future<bool> addUser(UserModel model) async
  {
    try
    {
      final userSession = await SessionService.getSessionMap();
      await FirebaseFirestore.instance.collection('users').add({
        'name': model.nome,
        'tipoUser': model.tipo == TipoUser.Monitor ? 'Monitor' : 'Monitorado',
        'userAuthId': userSession['userId']
      });

      return true;
    }
    catch (error)
    {
      return false;
    }
  }
}