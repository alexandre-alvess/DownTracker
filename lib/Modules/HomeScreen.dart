
import 'package:AppDown/Shared/Services/NavigatorService.dart';
import 'package:AppDown/Shared/Widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  initState()
  {
    super.initState();

    PermissionHandler().requestPermissions(
      [PermissionGroup.locationAlways, PermissionGroup.locationAlways]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: DownAppBar.build(
        title: Text(
          'DownTracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Pacifico'
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => GetIt.I<NavigatorService>().navigateToAnimated('/menu')
        ),
        action: IconButton(
          icon: Icon(Icons.account_circle, size: 24.0),
          onPressed: () => GetIt.I<NavigatorService>().navigateToAnimated('/user'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            'OLÁ, BEM VINDO AO DonwTracker',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: Icon(
          Icons.chat,
        ),
        onPressed: () => GetIt.I<NavigatorService>().navigateToAnimated('/chat')
      ),
    );
  }
}