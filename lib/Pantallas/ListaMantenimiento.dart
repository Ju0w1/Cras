import 'package:flutter/material.dart';

class ListaMantenimiento extends StatefulWidget{

  @override
  _ListaMantenimiento createState() => _ListaMantenimiento();
}

int _darkBlue = 0xFF022859;

class _ListaMantenimiento extends State<ListaMantenimiento>{

  @override
  Widget build(BuildContext context){ 
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Mantenimiento"),
        centerTitle: true,
        backgroundColor: Color(_darkBlue),
      ),
      body: Text("data"),
    );
  }
}