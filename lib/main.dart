import 'dart:convert';

import 'package:DownTracker/Providers/AnswerProvider.dart';
import 'package:DownTracker/Providers/AuthProvider.dart';
import 'package:DownTracker/Providers/MapsZonesProvider.dart';
import 'package:DownTracker/Providers/QuestionProvider.dart';
import 'package:DownTracker/Providers/UserProvider.dart';
import 'package:DownTracker/Routes.dart';
import 'package:DownTracker/Shared/Services/LocationBackgroundService.dart';
import 'package:DownTracker/Shared/Services/NavigatorService.dart';
import 'package:DownTracker/Shared/Services/SessionService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

final GetIt locatorService = GetIt.I;

void main() {

  bool callbackLocation = false;

  /* Garante a comunicacao com nativo e todos os servicos dart foi estabelecido */
  WidgetsFlutterBinding.ensureInitialized(); 

  /* Estabelece comunicacao de canal com o nativo */
  const MethodChannel _channel = const MethodChannel('geolocation_plugin'); 
  /* Handle de captura da comunicacao com o nativo */
  _channel.setMethodCallHandler((MethodCall call) async {

    print(call.method);

    if (call.method == 'callbackLocation')
    {
      /* Recebeu uma nova localizacao do usuario */

      callbackLocation = true;

      var arguments = call.arguments.split(',');
      var latitude = arguments[0];
      var longitude = arguments[1];
      var velocidade = arguments[2];
      var isRunningInBackground = arguments[3];

      print('latitude: ${latitude.toString()}');
      print('longitude: ${longitude.toString()}');
      print('velocidade: ${velocidade.toString()}');
      print('isRunningInBackground: ${isRunningInBackground.toString()}');

      final userSession = await SessionService.getSessionMap();

      if (userSession == null)
      {
        return;
      }

      print('INICIO: Realizando serviço de monitoramento de localização do usuário a partir da zona de localização configurada...');

      print('firebase');
      await Firebase.initializeApp();

      final isMonitored = await LocationBackgroundService.isUserMonitored(userSession['userId']);

      if (!isMonitored)
      {
        print('user não é monitorado');
        return;
      }

      print('user é monitorado');

      FirebaseFirestore.instance.collection('locationTracking').add({
        'latitude': latitude,
        'longitude': longitude,
        'date': Timestamp.now(),
        'monitored': 'monitored callbackLocation teste',
        'monitoredId': userSession['userId']
      });

      final dataZone = await LocationBackgroundService.getLocationZoneUser(userSession['userId']);

      if (dataZone != null)
      {

        print('entrou no bloco dataZone');
        print('zoneLatitude: ${dataZone['latitude']}');
        print('zoneLongitude: ${dataZone['longitude']}');
        print('zoneRadius: ${dataZone['radius']}');

        final insideZone = await LocationBackgroundService.isLocationInsideRadius(double.parse(latitude.toString()),  // latitude obtida do user
                                                                                  double.parse(longitude.toString()), // longitude obtida do user
                                                                                  dataZone['latitude'],               // latitude da zone do user
                                                                                  dataZone['longitude'],              // longitude da zone do user
                                                                                  dataZone['radius']);                // radius configurado da zone do user
        
        print('FIM: Realizado monitorado de localização do usuário a partir da zona de localização configurada...');
        
        if (!insideZone)
        {
          print('Monitorado está fora da zona configurada...');
          await LocationBackgroundService.sendNotificationManager(userSession['userId'], msg: 'TESTE DE TRACKING');
        }
        else
        {
          print('Monitorado está dentro da zona configurada...');
        }
      }
    }
  });

  registerLocators();
  runApp(AppDown(callbackLocation: callbackLocation));
}

/* registra os localizadores de servicos */
void registerLocators() {
  locatorService.registerLazySingleton<NavigatorService>(() => NavigatorService());
}

class AppDown extends StatelessWidget {

  bool callbackLocation = false;

  AppDown({this.callbackLocation});

  @override
  Widget build(BuildContext context) {

    if (callbackLocation)
    {
      return SizedBox();
    }

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new MapsZonesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => new AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => new QuestionProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => new AnswerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => new UserProvider(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity
        ),
        navigatorKey: locatorService<NavigatorService>().navigatorKey,
        initialRoute: '/',
        routes: AppRoutes().buildRoutes(),
      )
    );
  }
}
