//=====================IMPORTS=====================\\
import 'dart:convert';
import 'package:cras/Modelo/Inicio.dart';
import 'package:cras/Pantallas/RecuperarContra.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Mapa.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'Registro.dart';
import 'PantallaCarga.dart';
//=====================DECLARACIONES=====================\\
int _darkBlue = 0xFF022859;
Inicio inicio;
final _url = "http://cras-dev.com/Interfaz/interfaz.php?auth=4kebq1J2MD&tipo=sesion";

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
String tokencito;

String mensaje_snacklog;

final GlobalKey<ScaffoldState> _scaffoldKeyLog = new GlobalKey<ScaffoldState>();
_showSnackBar(){
  final snackBar = new SnackBar(
    content: Text(mensaje_snacklog),
    duration: Duration(seconds: 3),
  );
  _scaffoldKeyLog.currentState.showSnackBar(snackBar);
}

class Login extends StatefulWidget{
  @override
  _Logueo createState() => _Logueo();
}

//=====================PANTALLA=====================\\
class _Logueo extends State<Login>{
  @override
  void initState() {
    super.initState();
    setupNotification();
  }

  void setupNotification()async{
    _firebaseMessaging.getToken().then((token){
      tokencito = token;
      print(tokencito);
    });
  }

  final TextEditingController correocontroller = TextEditingController();
  final TextEditingController clavecontroller = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKeyLog,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
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
//Email
                  TextField(
                    controller: correocontroller,
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
                    height: 15,
                  ),
//Contraseña
                  TextField(
                    controller: clavecontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.vpn_key,color: Color(_darkBlue),),
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => new RecuperarContra()),
                        );
                      },
                      child: Text(
                        'No recuerda su contraseña?',
                        style: TextStyle(
                          color: Colors.grey, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
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
                          'Ingresar'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
//=====================COMUNICACIÓN WEB-SERVICE=====================\\
                      final response = await http.get("$_url&correo=${correocontroller.text}&clave=${clavecontroller.text}&token=${tokencito}");
                      if(response.statusCode == 200){
                        inicio = Inicio.fromJson(json.decode(response.body));
                        if(inicio.realizado=="1"){
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (BuildContext context) => Loader (pantallas: Mapa(nombre: inicio.logueo[0].nombre+" "+inicio.logueo[0].apellido,correo: inicio.logueo[0].correo,))),
                              (Route<dynamic> route) => false
                          );
                        }else{
                          mensaje_snacklog = inicio.mensaje;
                          _showSnackBar();
                        }
                      }else{
                        mensaje_snacklog = "Fallo de Conexión";
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Registro(),
                            )
                          );
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