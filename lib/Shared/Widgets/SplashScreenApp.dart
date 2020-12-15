import 'dart:async';
import 'dart:math';
import 'package:AppDown/DataAccess/DbUtils.dart';
import 'package:AppDown/Shared/Services/NavigatorService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_core/firebase_core.dart';

class SplashScreenApp extends StatefulWidget {

  final int delay;

  SplashScreenApp({
    this.delay = 5
  });

  @override
  _SplashScreenAppState createState() => _SplashScreenAppState(delay);
}

class _SplashScreenAppState extends State<SplashScreenApp> {
  
  final int delay;

  _SplashScreenAppState(this.delay);

  @override
  void initState() {
    super.initState();

    /* future de delay do splashscreen */
    Future futureScreen = Future.delayed(Duration(seconds: delay));

    /* inicializa o banco de dados */
    Future futureDb = DbUtils.getInstance().dataBase;

    /* inicializa o firebase */
    Future futureFirebase = Firebase.initializeApp();

    /* aguarda a inicialização dos seguintes componentes:
      - banco de dados
      - tempo de splashscreen do app 
      - firebase
    */
    Future.wait([futureDb, futureScreen, futureFirebase]).then((List values) 
    {
      GetIt.I<NavigatorService>().navigateToAndRemove('/auth');
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 55.0, 5, 0),
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              /*Center(
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset('assets/images/bg.png'),
                ),
              ),*/
              Center(
                child: Shimmer.fromColors(
                  period: Duration(milliseconds: 1500),
                  baseColor: Color(0xff7f00ff),
                  highlightColor: Color(0xffe100ff),
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          transform: Matrix4.rotationZ(-20 * pi / 180)..translate(-18.0),
                          child: Text(
                            "DownTracker",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 60.0,
                              fontFamily: 'Pacifico',
                              shadows: <Shadow>[
                                Shadow(
                                  blurRadius: 18.0,
                                  color: Colors.black87,
                                  offset: Offset.fromDirection(120, 12)
                                )
                              ]
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}