import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cras/Modelo/Registro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:ui';

int _darkBlue = 0xFF022859;
int _midBlue = 0xFF2E78A6;
int _lightBlue = 0xFF6AAED9;
Reg registro;

String mensaje_snack;

final GlobalKey<ScaffoldState> _scaffoldKey= new GlobalKey<ScaffoldState>();
_showSnackBar(){
  final snackBar = new SnackBar(
    content: Text(mensaje_snack),
    duration: Duration(seconds: 3),
  );
  _scaffoldKey.currentState.showSnackBar(snackBar);
}

const _urlInicio ="http://cras-dev.com/Interfaz/interfaz.php?auth=4kebq1J2MD&tipo=Dispensador";

class AgregarDispensador extends StatefulWidget {
  var nombre;
  var correo;
  AgregarDispensador({Key key, @required this.nombre, this.correo}) : super (key : key);
  @override
  _AgregarDispensador createState() {
    return _AgregarDispensador();
  }
}
  void _limpiar(){
    seriecontroller.clear();
    capacidadcontroller.clear();
    maxcontroller.clear();
    mincontroller.clear();
  }
  TextEditingController seriecontroller = TextEditingController();
  TextEditingController capacidadcontroller = TextEditingController();
  TextEditingController maxcontroller = TextEditingController();
  TextEditingController mincontroller = TextEditingController();
class _AgregarDispensador extends State<AgregarDispensador> {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agregar Dispensador',
      home: new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Agregar Dispensador",),
          backgroundColor: Color(_darkBlue),
        ),
        drawer: Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text("PEPITO"/*widget.nombre*/),
                decoration: BoxDecoration(color: Color(_darkBlue)),
                accountEmail: new Text(""/*widget.correo*/),
                currentAccountPicture: new CircleAvatar(
                  backgroundImage: ExactAssetImage("assets/images/user.png"),
                ),
              ),
            new ListTile(
                title: Text("Mapa Dispensadores"),
                onTap: (){},
              ),
              new ListTile(
                title: Text("Resumen"),
                onTap: (){},
              ),
              new ListTile(
                title: Text("Agregar Dispensador"),
                onTap: (){},
              ),
              new ListTile(
                title: Text("Mantenimientos"),
                onTap: (){},
              ),
          ],
        ),
      ),
        body:SingleChildScrollView(
          padding: const EdgeInsets.all(50),
          child: Column(
              children: <Widget>[
                Text("Nuevo Dispensador".toUpperCase(),style: TextStyle(decoration: TextDecoration.none,fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: seriecontroller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.add_circle),
                    hintText: 'Número de Serie',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextField(
                    controller: capacidadcontroller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.add_circle),
                      hintText: 'Capacidad',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextField(
                    controller: maxcontroller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.add_circle),
                      hintText: 'Temperatura Máxima',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextField(
                    controller: mincontroller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.add_circle),
                      hintText: 'Temperatura Mínima',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),), 
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: Color(_darkBlue),
                    onPressed: ()async{
                      var response = await http.get("${_urlInicio}&serie=${seriecontroller.text}&capacidad=${capacidadcontroller.text}&temp_max=${maxcontroller.text}&temp_min=${mincontroller.text}");
                      print(response);
                      if(response.statusCode==200){
                        registro=Reg.fromJson(json.decode(response.body));
                        if(registro.realizado == "1"){
                          _limpiar();
                          mensaje_snack = "Dispensador Agregado Correctamente";
                          _showSnackBar();
                        }else{
                          mensaje_snack = registro.mensaje;
                          _showSnackBar();
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40,right: 40),
                      child:Text(
                        "Agregar".toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 27),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}