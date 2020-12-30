
import 'package:DownTracker/Modules/MenuScreens/MenuOptions.dart';
import 'package:DownTracker/Shared/Services/NavigatorService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            MenuBar(),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 8.0),
                    Divider(height: 4.0),
                    MenuOptions()
                  ],
                ),
              )
            )
          ],
        ),
      )
    );
  }
}

class MenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 18.0
        ),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 45.0,
                  alignment: Alignment.center,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => GetIt.I<NavigatorService>().pop(),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 45.0,
                    alignment: Alignment.center,
                    child: Text('MENU', /* colocar a logo do app */ 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ) 
                  ),
                )
              ],
            )
          ],
        )
      ),
    );
  }
}