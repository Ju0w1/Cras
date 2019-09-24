import 'package:flutter/material.dart';

class AgregarMantenimiento extends StatefulWidget{

  @override
  _AgregarMantenimiento createState() =>  _AgregarMantenimiento();
}

int _darkBlue = 0xFF022859;


class _AgregarMantenimiento extends State<AgregarMantenimiento>{

  Map<String, bool> values = {
    'Cambio de placa temporizadora': false,
    'Cambio de placa de temperatura': false,
    'Cambio de monedero': false,
    'Cambio de fuente 12V': false,
    'Cambio de calefón': false,
    'Cambio de botón': false,
    'Cambio de luz': false,
    'Cambio de manguera/as': false,
    'Otros': false,
  };
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Agregar Mantenimiento"),
        backgroundColor: Color(_darkBlue),
      ),
      body: ListView(
        children: values.keys.map((String key) {
          return new CheckboxListTile(
            title: new Text(key),
            value: values[key],
            onChanged: (bool value) {
              setState(() {
                values[key] = value;
              });
            },
          );
        }).toList(),
      ),
    );
  }
}