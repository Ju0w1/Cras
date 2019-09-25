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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height/1.5,
              width: MediaQuery.of(context).size.width,
              child: ListView(
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
                },).toList(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width/2,
                height: 40,
                decoration: new BoxDecoration(
                  color: Color(_darkBlue),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Center(
                  child: Text(
                    'Agregar'.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              onTap: () {},
            ),
          ],
        )
      )
    );
  }
}