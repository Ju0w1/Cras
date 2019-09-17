//=====================IMPORTS=====================\\
import 'package:cras/Pantallas/PantallaCarga.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import '../Modelo/Registro.dart';
import 'dart:convert';
import 'Mapa.dart';

int _darkBlue = 0xFF022859;
int _midBlue = 0xFF2E78A6;
int _lightBlue = 0xFF6AAED9;
Reg registro;
final _url = "http://cras-dev.com/Interfaz/interfaz.php?auth=4kebq1J2MD&tipo=registro";

class Registro extends StatefulWidget{
  @override
  _Registro createState() => _Registro(); 
}
//=====================PANTALLA=====================\\

class _Registro extends State<Registro>{
  //=====================CONTROLLERS=====================\\
  final TextEditingController nombre = TextEditingController();
  final TextEditingController apellido = TextEditingController();
  final TextEditingController correo = TextEditingController();
  final TextEditingController pwd = TextEditingController();
  final TextEditingController pwd2 = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topCenter,
                    color: Colors.white,
                    child: Image.asset("assets/images/Logo.png",scale:11,),
                  ),
                  Container(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      children: <Widget>[
//Nombre
                        TextField(
                          controller: nombre,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            labelStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.person,color: Color(_darkBlue),),
                            labelText: 'Nombre',
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
//Apellido
                        TextField(
                          controller: apellido,
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            filled: true,
                            labelStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.person,color: Color(_darkBlue),),
                            labelText: "Apellido",
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
//Correo                
                        TextField(
                          controller: correo,
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            filled: true,
                            labelStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.email,color: Color(_darkBlue),),
                            labelText: "Correo",
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),                      
//Clave
                        TextField(
                          controller: pwd,
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            filled: true,
                            labelStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.vpn_key,color: Color(_darkBlue),),
                            labelText: "Contraseña",
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),  
//Confirmar Clave                        
                        TextField(
                          controller: pwd2,
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            filled: true,
                            labelStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.vpn_key,color: Color(_darkBlue),),
                            labelText: "Confirmar Contraseña",
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))
                            ),
                          ),
                        ),
                        SizedBox(height: 30,),  
//Boton                        
                        Container(
                          height: 40,
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                            shadowColor: Colors.blueAccent,
                            elevation: 7.0,
                            child: GestureDetector(
                              child: Center(
                                child: Text(
                                  "Registrarse".toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              onTap: () async{
                                var response = await http.get("$_url&nombre=${nombre.text}&apellido=${apellido.text}&correo=${correo.text}&clave=${pwd.text}&clave2=${pwd2.text}");
                                if(response.statusCode == 200){
                                  registro = Reg.fromJson(json.decode(response.body));
                                  if(registro.realizado == "1"){
                                    _navigator();
                                  }else{
                                    showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    child: new CupertinoAlertDialog(
                                      content: new Text(
                                        registro.mensaje,
                                        style: new TextStyle(fontSize: 16.0),
                                      ),
                                      actions: <Widget>[
                                        new FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: new Text("OK"))
                                      ],
                                    ));  
                                  }
                                }else{
                                  showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  child: new CupertinoAlertDialog(
                                    content: new Text(
                                      "Error en el servidor",
                                      style: new TextStyle(fontSize: 16.0),
                                    ),
                                    actions: <Widget>[
                                      new FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: new Text("OK"))
                                    ],
                                  ));
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  _navigator(){
  Navigator.of(context).pushAndRemoveUntil(
    new MaterialPageRoute(
      builder: (BuildContext context) => new Loader(pantallas: Mapa(nombre: nombre.text,correo: correo.text,),)),
      (Route<dynamic> route) => false);
}
}

