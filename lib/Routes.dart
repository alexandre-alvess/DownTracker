
import 'package:DownTracker/Modules/ChatScreens/ChatScreen.dart';
import 'package:DownTracker/Modules/LoginScreen.dart';
import 'package:DownTracker/Modules/QuestionScreens/QuestionFormScreen.dart';
import 'package:DownTracker/Modules/QuestionScreens/QuestionListScreen.dart';
import 'package:DownTracker/Modules/QuizScreens/QuizListScreen.dart';
import 'package:DownTracker/Modules/QuizScreens/QuizScreen.dart';
import 'package:DownTracker/Modules/UserScreen.dart';
import 'package:DownTracker/Modules/ZonesScreens/ConfigureMapsScreen.dart';
import 'package:DownTracker/Modules/HomeScreen.dart';
import 'package:DownTracker/Modules/LocationScreen.dart';
import 'package:DownTracker/Modules/MenuScreens/MenuScreen.dart';
import 'package:DownTracker/Modules/ZonesScreens/ZonesFormScreen.dart';
import 'package:DownTracker/Modules/ZonesScreens/ZonesListScreen.dart';
import 'package:DownTracker/Shared/Widgets/AuthScreen.dart';
import 'package:DownTracker/Shared/Widgets/SplashScreenApp.dart';
import 'package:flutter/material.dart';

class AppRoutes {

  final Map<String, Widget> routes = {
    '/': null,
    '/login': LoginScreen(),
    '/home': HomeScreen(),
    '/menu': MenuScreen(),
    '/location': LocationScreen(),
    '/configureLocation': ConfigureMapsScreen(),
    '/zoneList': ZonesListScreen(),
    '/zoneForm': ZonesFormScreen(),
    '/auth': AuthScreen(),
    '/questionList': QuestionListScreen(),
    '/questionForm': QuestionFormScreen(),
    '/quiz': QuizScreen(),
    '/chat': ChatScreen(),
    '/user': UserScreen(),
    '/quizList': QuizListScreen()
  };

  Widget _buildSplashScreen(BuildContext context) {
    /*return SplashScreen.callback(
      name: 'assets/splash/intro.flr',
      backgroundColor: Colors.grey[200],
      startAnimation: 'intro',
      until: () => Future.delayed(Duration(seconds: 3)),
      onSuccess: (data) => GetIt.I<NavigatorService>().navigateToAndRemove('/home'),
      loopAnimation: '1',
      endAnimation: '1',
      onError: (error, stacktrace) => print('Erro: $error'),
    );*/

    return SplashScreenApp();
  }

  Map<String, Widget Function(BuildContext)> buildRoutes() {
    return this.routes.map((key, value) {
      if (key == '/') {
        return MapEntry(key, (context) => _buildSplashScreen(context)); 
      }

      return MapEntry(key, (context) => value);
    });
  }
}