import 'package:flutter/material.dart';

class AgregarMantenimiento extends StatefulWidget{

  @override
  _AgregarMantenimiento createState() =>  _AgregarMantenimiento();
}

int _darkBlue = 0xFF022859;

class _AgregarMantenimiento extends State<AgregarMantenimiento>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
        ],
        centerTitle: true,
        title: Text("Agregar Mantenimiento"),
        backgroundColor: Color(_darkBlue),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                
              )
            ],
          ),
        ),
      ),
    );
  }
}