import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class Segunda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cras',
      home:  new SplashScreen(
        seconds: 3,
        navigateAfterSeconds: new Tercera(),
        title: new Text('Cargando...',
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),),
        backgroundColor: Colors.white,
        loaderColor: Colors.red
      )
    );
  }
}

class Tercera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cras',
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("3ra Pantalla",) ,
        ),
      ),
    );
  }
}