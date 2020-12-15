import 'package:AppDown/Modules/LocationMonitorScreen.dart';
import 'package:AppDown/Modules/ZonesScreens/ZoneDetailScreen.dart';
import 'package:AppDown/Providers/MapsZonesProvider.dart';
import 'package:AppDown/Shared/Services/LocationBackgroundService.dart';
import 'package:AppDown/Shared/Services/NavigatorService.dart';
import 'package:AppDown/Shared/Services/SessionService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ZonesListScreen extends StatefulWidget {
  @override
  _ZonesListScreenState createState() => _ZonesListScreenState();
}

class _ZonesListScreenState extends State<ZonesListScreen> {

  bool _isMonitored = true;

  Future<bool> _initScreen() async
  {
    final userSession = await SessionService.getSessionMap();
    return await LocationBackgroundService.isUserMonitored(userSession['userId']);
  }

  @override
  void initState() 
  {
    super.initState();
    _initScreen().then((value){
      setState(() {
      _isMonitored = value;
    });
    });    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zonas'),
        centerTitle: true,
        actions: _isMonitored 
        ? <Widget>[
          IconButton(icon: Icon(Icons.add),
           onPressed: () => GetIt.I<NavigatorService>().navigateToAnimated('/zoneForm')
          ),
        ]
        : null
      ),
      body: FutureBuilder(
        future: Provider.of<MapsZonesProvider>(context, listen: false).loadZones(),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
        ? Center(child: CircularProgressIndicator())
        : Consumer<MapsZonesProvider> (
          child: Center(
            child: Text('Nenhuma zona configurada!'),
          ),
          builder: (ctx, zones, ch) => zones.count == 0
          ? ch
          : ListView.builder(
            itemCount: zones.count,
            itemBuilder: (ctx, i) => ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red
              ),
              title: Text(zones.itemByIndex(i).descrition.toUpperCase()),
              onTap: () async {

                //final userSession = await SessionService.getSessionMap();
                //final isMonitored = await LocationBackgroundService.isUserMonitored(userSession['userId']);

                if (_isMonitored) // usuario monitorado
                {
                  GetIt.I<NavigatorService>().navigatorKey.currentState.push(
                    MaterialPageRoute(builder: (ctx) => ZoneDetailScreen(zones.itemByIndex(i)))
                  );
                }
                else // usuario monitor
                {
                  GetIt.I<NavigatorService>().navigatorKey.currentState.push(
                    MaterialPageRoute(builder: (ctx) => LocationMonitorScreen(zones.itemByIndex(i).userAuthId))
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}