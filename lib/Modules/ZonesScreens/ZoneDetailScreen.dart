import 'package:DownTracker/Modules/ZonesScreens/ZonesFormScreen.dart';
import 'package:DownTracker/Shared/Models/LocationZoneModel.dart';
import 'package:DownTracker/Shared/Services/NavigatorService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ZoneDetailScreen extends StatefulWidget {

  final LocationZoneModel model;

  ZoneDetailScreen(this.model);

  @override
  _ZoneDetailScreenState createState() => _ZoneDetailScreenState();
}

class _ZoneDetailScreenState extends State<ZoneDetailScreen> {
  
  LocationZoneModel _modelForm;

  _updateModelForm(LocationZoneModel model)
  {
    setState(() {
      _modelForm = LocationZoneModel.getModel(model);
    });

    print(_modelForm?.descrition);
  }

  _updateEditData() async
  {
    final LocationZoneModel result = await GetIt.I<NavigatorService>().navigatorKey.currentState.push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => ZonesFormScreen(modelInit: _modelForm)
      )
    );

    if (result == null) return;
      
    _updateModelForm(result);
  }

  _buildContainer(Widget child)
  {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.0,
          color: Colors.black
        ),
      ),
      child: child
    );
  }

  _buildText(String label, String date)
  {
    return Text.rich(
      TextSpan(
        text: label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          decoration: TextDecoration.underline
        ),
        children: <TextSpan>[
          TextSpan(text: ' ' + date, 
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
              decoration: TextDecoration.none
            )
          ),
        ],
      ),
    );
  }

  @override
  void initState() 
  {
    super.initState();
    _updateModelForm(widget.model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_modelForm.descrition.toUpperCase()),
        centerTitle: true,
        actions: <Widget> [
          IconButton(icon: Icon(Icons.edit), 
            onPressed: () => _updateEditData() /* chamada de edição e atualização dos dados do form */
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 22),
              _buildContainer(_buildText('Token do monitor:', _modelForm.managerToken.toString())),
              SizedBox(height: 22),
              _buildContainer(_buildText('Latitude:', _modelForm.position.latitude.toString())),
              SizedBox(height: 22),
              _buildContainer(_buildText('Longitude:', _modelForm.position.longitude.toString())),
              SizedBox(height: 22),
              _buildContainer(_buildText('Radio de Zona:', _modelForm.radius.toString())),
              SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget> [
                  Text('Ativo:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decoration: TextDecoration.underline
                    ),
                  ),
                  Switch(value: _modelForm.ativo,
                  onChanged: (value) {},
                  activeColor: Colors.green,
                )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}