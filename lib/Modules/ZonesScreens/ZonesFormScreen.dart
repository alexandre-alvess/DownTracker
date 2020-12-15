import 'package:AppDown/Providers/MapsZonesProvider.dart';
import 'package:AppDown/Shared/Models/LocationZoneModel.dart';
import 'package:AppDown/Shared/Services/NavigatorService.dart';
import 'package:AppDown/Shared/Services/SessionService.dart';
import 'package:AppDown/Shared/Utils/EnumValidates.dart';
import 'package:AppDown/Shared/Widgets/LocationInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class ZonesFormScreen extends StatefulWidget {

  final LocationZoneModel modelInit;

  ZonesFormScreen({this.modelInit});

  @override
  _ZonesFormScreenState createState() => _ZonesFormScreenState();
}

class _ZonesFormScreenState extends State<ZonesFormScreen> {

  final _descritionController = TextEditingController();
  final _managerTokenController = TextEditingController();
  final _nickNameController = TextEditingController();
  LatLng _picketLocation;
  double _pickedRadius = 0;
  bool _switchAtivo;

  final phoneFormatter = MaskTextInputFormatter(
    mask: "(##) #####-####",
    filter: {"#": RegExp(r'[0-9]')}
  );

  void _selectLocation(LatLng position, double radius)
  {
    setState(() {
      _picketLocation = position;
      _pickedRadius = radius;
    });
  }

  EnumValidates _isValidForm()
  {
    if (_descritionController.text.isEmpty)
      return EnumValidates.Failed;
    if (_managerTokenController.text.isEmpty)
      return EnumValidates.ManagerTokenInvalid;
    if (_picketLocation == null)
      return EnumValidates.LocationInvalid;
    if (_pickedRadius < 100 || _pickedRadius > 500)
      return EnumValidates.ZoneInvalid;
    if (_switchAtivo && Provider.of<MapsZonesProvider>(context, listen: false).items.contains((e) => e.ativo))
      return EnumValidates.ZonesConfigureInvalid;

    return EnumValidates.Ok;
  }

  void _showErrorDialog(String messageError)
  {
    showDialog(context: context,
      barrierDismissible: false, /* configurado para fechar o dialog somente quando clicar no botao da box */
      builder: (context) {
        return AlertDialog(
          title: Text(messageError),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                GetIt.I<NavigatorService>().pop();
              },
            )
          ],
        );
      }
    );
  }

  Future<void> _submitForm(BuildContext context) async
  {
    var validate = _isValidForm();
    if (validate != EnumValidates.Ok) 
    {
      String messageError = '';

      switch (validate)
      {
        case EnumValidates.ManagerTokenInvalid:
        messageError = 'Cadastro inválido ! Token do monitor não informado.';
        break;

        case EnumValidates.LocationInvalid:
        messageError = 'Cadastro inválido ! Localização de zona não informada.';
        break;

        case EnumValidates.ZoneInvalid:
        messageError = 'Cadastro inválido ! Zona fora do raio limite.';
        break;

        case EnumValidates.ZonesConfigureInvalid:
        messageError = 'Cadastro inválido ! Já existe uma zona de localização configurada.';
        break;

        default:
        messageError = 'Cadatro inválido ! Preencha todos os campos obrigatórios.';
        break;
      }

      _showErrorDialog(messageError);
      return;
    }
    
    /* salvando zonas */
    LocationZoneModel model = new LocationZoneModel();
    model.ativo = _switchAtivo;
    model.descrition = _descritionController.text;
    model.position = _picketLocation;
    model.radius = _pickedRadius;
    model.managerToken = _managerTokenController.text.trim();
    
    final userSession = await SessionService.getSessionMap();
    model.userAuthId = userSession['userId'];

    if (_isValidModelInit())
      model.id = widget.modelInit.id;


    if (_isValidModelInit())
    {
      /* no caso do perfil de usuario: verificar se existe mais de uma configuracao de zona ativa */
      await Provider.of<MapsZonesProvider>(context, listen: false).updateZone(model);

      GetIt.I<NavigatorService>().navigatorKey.currentState.pop(model);
    }
    else
    {
      /* no caso do perfil de usuario: verificar se existe mais de uma configuracao de zona ativa */
      await Provider.of<MapsZonesProvider>(context, listen: false).addZone(model);

      GetIt.I<NavigatorService>().pop();
    }
  }

  _onChangedSwitchAtivo(bool value)
  {
    setState(() {
      _switchAtivo = value;
    });
  }

  void _initForm()
  {
    if (widget.modelInit != null)
    setState(() {
      _switchAtivo = widget.modelInit.ativo;
      _descritionController.text = widget.modelInit.descrition;
      _picketLocation = widget.modelInit.position;
      _pickedRadius = widget.modelInit.radius;
      _managerTokenController.text = widget.modelInit.managerToken;
    });
  }

  @override
  void initState()
  {
    super.initState();
    _initForm();
  }

  bool _isValidModelInit()
  {
    return widget.modelInit != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isValidModelInit()
        ? Text('Nova Zona')
        : Text('Alteração de Dados da Zona'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
                child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _descritionController,
                      decoration: InputDecoration(
                        labelText: 'Descrição*'
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _managerTokenController, 
                      decoration: InputDecoration(
                        labelText: 'Token de monitor*'
                      )
                    ),
                    SizedBox(height: 15),
                    !_isValidModelInit()
                    ? LocationInput(this._selectLocation)
                    : LocationInput(this._selectLocation, 
                                    position: widget.modelInit.position,
                                    radius: widget.modelInit.radius
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Ativo:',
                          style: TextStyle(
                            fontSize: 20,
                            decoration: TextDecoration.underline
                          ),
                        ),
                        Switch(value: _switchAtivo == null ? false : _switchAtivo, 
                          onChanged: (value) => _onChangedSwitchAtivo(value),
                          activeColor: Colors.green[600]
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            icon: Icon(!_isValidModelInit()
            ? Icons.add
            : Icons.check_circle_outline, 
            size: 32
            ),
            label: !_isValidModelInit()
            ? Text('Adicionar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            )
            : Text('Confirmar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            color: Colors.yellow[800],
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () => _submitForm(context), /* submissao do formulario */
          ),
        ],
      ),
    );
  }
}