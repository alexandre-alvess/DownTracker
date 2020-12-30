import 'dart:math';
import 'package:DownTracker/Shared/Widgets/LoginCard.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 0.5),
                  Color.fromRGBO(255, 188, 117, 0.9)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              )
            ),
          ),
          Container(
            width: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(), // permite ao usuario realizar scroll da UI
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 90.0
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget> [
                  Container(
                    margin: EdgeInsets.only(bottom: 22.0, top: 60.0),
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 70
                    ),
                    transform: Matrix4.rotationZ(-10 * pi / 180)..translate(-10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white54,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, 5)
                        ),
                      ],
                    ),
                    child: Text('DonwTracker',
                      style: TextStyle(
                        color: Theme.of(context).accentTextTheme.headline6.color,
                        fontSize: 30,
                        fontFamily: 'Pacifico'
                      ),
                    ),
                  ),
                  LoginCard()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}