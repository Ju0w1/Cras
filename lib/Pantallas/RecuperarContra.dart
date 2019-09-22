import 'dart:async';
import 'dart:convert';

import 'package:cras/Modelo/rec_pwd.dart';
import 'package:cras/Pantallas/Logueo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


int _darkBlue = 0xFF022859;
Passwd passwd;
final _url = "http://cras-dev.com/Interfaz/interfaz.php?auth=4kebq1J2MD&tipo=pwd";

String mensaje_stackRec;

final GlobalKey<ScaffoldState> _scaffoldKeyPasswd = new GlobalKey<ScaffoldState>();
_showSnackBar(){
    final snackBar = new SnackBar(
      content: Text(mensaje_stackRec),
      duration: Duration(seconds: 3),
    );
    _scaffoldKeyPasswd.currentState.showSnackBar(snackBar);
}

class RecuperarContra extends StatefulWidget{
  @override
  _RecuperarContra createState() => _RecuperarContra();
}

class _RecuperarContra extends State<RecuperarContra>{
  final TextEditingController correocontrollerNoPass = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKeyPasswd,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.topCenter,
              color: Colors.transparent,
              child: Image.asset("assets/images/Logo.png",scale:7,),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width/1.1,
              padding: EdgeInsets.all(25),
              child: Column(
                children: <Widget>[
                  Text("Ingrese su correo para recibir su contraseña:", style: TextStyle(fontSize: 15),),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: correocontrollerNoPass,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.email,color: Color(_darkBlue),),
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  InkWell(
                    child: Container(
                      height: 40,
                      decoration: new BoxDecoration(
                        color: Color(_darkBlue),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      child: Center(
                        child: Text(
                          'Enviar'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      final response = await http.get("$_url&correo=${correocontrollerNoPass.text}");
                      if(response.statusCode == 200){
                        passwd = Passwd.fromJson(json.decode(response.body));
                        if(passwd.realizado == "1"){
                          mensaje_stackRec = passwd.mensaje;
                          _showSnackBar();
                          Timer(Duration(seconds: 3), (){
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          });
                        }else{
                          mensaje_stackRec = passwd.mensaje;
                          _showSnackBar();
                        }
                      }else{
                        mensaje_stackRec = "Fallo de Conexión";
                        _showSnackBar();
                      }
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'No tienes una cuenta?',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: 5,),
                      InkWell(
                        onTap: (){
                        },
                        child: Text(
                          'Registrarse',
                          style: TextStyle(
                            color: Color(_darkBlue),
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}