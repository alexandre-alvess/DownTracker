import 'package:DownTracker/Providers/AuthProvider.dart';
import 'package:DownTracker/Providers/UserProvider.dart';
import 'package:DownTracker/Shared/Models/UserModel.dart';
import 'package:DownTracker/Shared/Services/NavigatorService.dart';
import 'package:DownTracker/Shared/Utils/AuthException.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

enum LoginMode { Signup, Login }

class LoginCard extends StatefulWidget {
  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {

  GlobalKey<FormState> _form = GlobalKey();
  LoginMode _loginMode = LoginMode.Login;
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isCheckManager = false;

  Map<String, String> _authData = {
    'email': '',
    'password': ''
  };

  void _showErrorDialog(String msg)
    {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error_outline,
                color: Colors.red,
              ),
              Text('  Falha de autenticação',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          content: Container(
            width: double.infinity,
            height: 50.0,
            child: Center(
              child: Text(msg,
                style: TextStyle(
                  fontSize: 20
                ),
              )
            )
          ),
          actions: <Widget>[
            FlatButton(onPressed: () {
              GetIt.I<NavigatorService>().pop();
            },
            child: Text('FECHAR',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            )
          ],
        )
      );
    }

  Future<void> _submit() async
  {
    if (!_form.currentState.validate())
    {
       return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);

    try
    {
      if (_loginMode == LoginMode.Login)
      {
        // Login firebase
        await provider.login(_authData['email'], _authData['password']);
      }
      else
      {
        // Registrar firebase
        await provider.signup(_authData['email'], _authData['password']);
        
        // grava o perfil do usuario
        UserModel userModel = new UserModel();
        userModel.tipo = _isCheckManager ? TipoUser.Monitor : TipoUser.Monitorado;
        userModel.nome = 'User';
        await Provider.of<UserProvider>(context, listen: false).addUser(userModel);
      }
    } 
    on AuthException catch (error)
    {
      _showErrorDialog(error.toString());
    }
    catch (error)
    {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchLoginMode()
  {
    if (_loginMode == LoginMode.Login)
    {
      setState(() {
        _loginMode = LoginMode.Signup;
      });
    }
    else
    {
      setState(() {
        _loginMode = LoginMode.Login;
      });
    }
  }

  _onChangedCheckBox(bool value)
  {
    setState(() {
      _isCheckManager = value;
    });
  }

  _buildRegisterLogin()
  {
    return Column(
      children: <Widget> [
        TextFormField(
          decoration: InputDecoration(labelText: 'Confirme a senha'),
          obscureText: true,
          validator: _loginMode == LoginMode.Signup 
          ? (value) 
          {
            if (value != _passwordController.text)
            {
              return 'Senha são diferentes!';
            }
            return null;
          } 
          : null,
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget> [
            Text('Monitor',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 17.5
              ),
            ),
            Checkbox(value: _isCheckManager,
              activeColor: Colors.green,
              onChanged: (value) => _onChangedCheckBox(value)
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final deviceSize = MediaQuery.of(context).size;


    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Container(
        height: _loginMode == LoginMode.Login ? 290 : 431,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget> [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (
                      value.isEmpty || 
                      !value.contains('@') || 
                      !EmailValidator.validate(value.trim())
                     )
                  {
                    return 'Informe um e-mail válido!';
                  }
                  return null; // email valido
                },
                onSaved: (value) => _authData['email'] = value.trim(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                controller: _passwordController,
                obscureText: true, // abstrai os caracteres de senha por '*'
                validator: (value) {
                  if (value.isEmpty)
                  {
                    return 'Informe sua senha';
                  }
                  if (value.length < 6)
                  {
                    return 'Informe uma senha com pelo menos 6 caracteres';
                  }
                  return null; // senha valida
                },
                onSaved: (value) => _authData['password'] = value,
              ),

              if (_loginMode == LoginMode.Signup)
                _buildRegisterLogin(),
                
              Spacer(),

              if (_isLoading)
                CircularProgressIndicator()
              else
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 8.0
                  ),
                  child: Text(
                    _loginMode == LoginMode.Login 
                    ? 'ENTRAR'
                    : 'REGISTRAR'
                  ),
                  onPressed: _submit,
                ),
              FlatButton(
                child: Text(
                  _loginMode == LoginMode.Login
                  ? 'REGISTRAR'
                  : 'LOGIN'
                ),
                textColor: Theme.of(context).primaryColor,
                onPressed: _switchLoginMode, 
              )
            ],
          ),
        ),
      ),
    );
  }
}