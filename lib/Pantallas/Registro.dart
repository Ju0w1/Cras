//=====================IMPORTS=====================\\
import 'package:cras/Pantallas/PantallaCarga.dart';
import 'package:cras/Pantallas/RecuperarContra.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import '../Modelo/Registro.dart';
import 'dart:convert';
import 'Mapa.dart';

int _darkBlue = 0xFF022859;
Reg registro;
final _url = "http://cras-dev.com/Interfaz/interfaz.php?auth=4kebq1J2MD&tipo=registro";

String mensaje_snackReg;

final GlobalKey<ScaffoldState> _scaffoldKeyPasswd = new GlobalKey<ScaffoldState>();
_showSnackBar(){
    final snackBar = new SnackBar(
      content: Text(mensaje_snackReg),
      duration: Duration(seconds: 3),
    );
    _scaffoldKeyPasswd.currentState.showSnackBar(snackBar);
}

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
      key: _scaffoldKeyPasswd,
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
                        InkWell(
                          child: Container(
                            height: 40,
                            decoration: new BoxDecoration(
                              color: Color(_darkBlue),
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            ),
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
                          ),
                          onTap: ()async{
                            var response = await http.get("$_url&nombre=${nombre.text}&apellido=${apellido.text}&correo=${correo.text}&clave=${pwd.text}&clave2=${pwd2.text}");
                            if(response.statusCode == 200){
                              if(pwd.text == pwd2.text){
                                registro = Reg.fromJson(json.decode(response.body));
                                if(registro.realizado == "1"){
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => Loader (pantallas: Mapa(nombre: nombre.text+" "+apellido.text,correo: correo.text,))),
                                      (Route<dynamic> route) => false
                                  );
                                }else{
                                  mensaje_snackReg = registro.mensaje;
                                  _showSnackBar();
                                }
                              }else{
                                mensaje_snackReg = "No coinciden las contraseñas";
                                _showSnackBar();
                              }
                            }else{
                              mensaje_snackReg = "Fallo de Conexión";
                              _showSnackBar();
                            }
                          },
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
}

