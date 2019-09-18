import 'dart:convert';

import 'package:cras/Modelo/Estado.dart';
import 'package:cras/Modelo/rec_real.dart';
import 'package:cras/Modelo/temp_real.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

int _darkBlue = 0xFF022859;

TempReal tempReal;
RecReal recReal;
Conexion conexion;

const _urlTmpReal ="http://cras-dev.com/Interfaz/interfaz.php?auth=4kebq1J2MD&tipo=temp_rel";
const _urlRecReal ="http://cras-dev.com/Interfaz/interfaz.php?auth=4kebq1J2MD&tipo=recrel";
const _urlConexion ="http://cras-dev.com/Interfaz/interfaz.php?auth=4kebq1J2MD&tipo=obtener_estado";

class PantallaDispensadores extends StatefulWidget{
  var nombreUsuario;
  var correoUsuario;
  var nroSerie;
  var nombreDisp;
  PantallaDispensadores({Key key, @required this.nombreDisp, this.nroSerie, this.nombreUsuario, this.correoUsuario}) : super (key : key);
  @override
  _Dispensadores createState() => _Dispensadores(); 
}

var tempActual;
var tempMax;
var tempMin;
var recActual;
var largo;
var serie;
var tiempo =1;
var nombre;
var estado;

class _Dispensadores extends State<PantallaDispensadores>{
  
  void initState(){
    super.initState();
    nombre = widget.nombreDisp;
    serie = widget.nroSerie;
    getConexion();
    getTemp();
    String _setImage() {
      if(tempActual >= 75) {
        return "assets/images/temperature.png";
      } else if(tempActual < 75) {
        return "assets/images/cold.png";
      }
    }
  }
  
  Future getConexion()async{
    var response = await http.get("$_urlConexion&serie=${widget.nroSerie}");
    if(response.statusCode==200){
      conexion = Conexion.fromJson(json.decode(response.body));
      if(conexion.realizado == "1"){
        estado = conexion.estado[0].estado;
        print (estado);
      }
    }
  }

  Future getTemp()async{
    var respose = await http.get("$_urlTmpReal&serie=$serie");
    if(respose.statusCode == 200){
      tempReal = TempReal.fromJson(json.decode(respose.body));
      if(tempReal.realizado == "1"){
        largo = tempReal.temperatura.length;
        tempActual = tempReal.temperatura[largo-1].prom;
        tempMin = tempReal.temperatura[largo-1].min;
        tempMax = tempReal.temperatura[largo-1].max;
      }
    }
  }

  Future getRec()async{
    var respose = await http.get("$_urlRecReal&serie=$serie");
    if(respose.statusCode == 200){
      recReal = RecReal.fromJson(json.decode(respose.body));
      if(recReal.realizado == "1"){
        recActual = recReal.total[0].recaudado;
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text("Dispensador "+nombre),
        backgroundColor: Color(_darkBlue),
      ),
      drawer: Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text(widget.nombreUsuario),
                decoration: BoxDecoration(color: Color(_darkBlue)),
                accountEmail: new Text(widget.correoUsuario),
                currentAccountPicture: new CircleAvatar(
                  backgroundImage: ExactAssetImage("assets/images/user.png"),
                ),
              ),
            new ListTile(
                title: Text("Mapa Dispensadores"),
                onTap: (){/*
                  Navigator.push(
                    context,
                    FadeRoute(
                      page: new MapSample(nombre: widget.nombreUsuario, correo: widget.correoUsuario,)),
                  );
                */},
              ),
              new ListTile(
                title: Text("Resumen"),
                onTap: (){/*
                  Navigator.push(
                    context,
                    FadeRoute(
                      page: new HomeDashboard(nombre: widget.nombreUsuario, correo: widget.correoUsuario,)),
                  );
                */},
              ),
              new ListTile(
                title: Text("Agregar Dispensador"),
                onTap: (){/*
                  Navigator.push(
                    context,
                    FadeRoute(
                      page: new HomeAgregarPage(nombre: widget.nombreUsuario, correo: widget.correoUsuario,)),
                  );
                */},
              ),
              new ListTile(
                title: Text("Mantenimientos"),
                onTap: (){
                  /*Navigator.push(
                    context,
                    FadeRoute(
                      page: new MantenimientosSample(nombre: widget.nombreUsuario, correo: widget.correoUsuario,)
                    ),
                  );
                */},
              )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
                Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Conexión: ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold ),),
                    Text("En Línea/Fuera de Línea",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.red)),
                  ],
                ),
              ),
              SizedBox(height: 10,),
            Container(
                height: 100,
                width:  MediaQuery.of(context).size.width,                   
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width/1.5,
                          child: Padding(
                            padding: EdgeInsets.only(left: 25, top: 26),
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Recaudación actual:",style: TextStyle(fontSize: 18,),),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: FutureBuilder(
                                    future:getRec(),
                                    builder: (BuildContext context, AsyncSnapshot snapshot) => Text("\$"+"$recActual",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),) ,
                                  ),
                                ),
                              ],
                            )
                          ) 
                        ),
                        Container(
                          child: Image.asset("assets/images/coins.png",
                            scale: 7.5,
                            alignment: Alignment.centerRight,),
                        ),
                      ],
                    ),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                        offset: Offset(
                          0, // horizontal, move right 10
                          2, // vertical, move down 10
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25,),
                Container(
                height: 100,
                width:  MediaQuery.of(context).size.width,                   
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width/1.5,
                          child: Padding(
                            padding: EdgeInsets.only(left: 25, top: 26),
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Temperatura actual:",style: TextStyle(fontSize: 18),),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: FutureBuilder(
                                    future: getTemp(),
                                    builder: (BuildContext context, AsyncSnapshot snapshot)=>Text("$tempActual°C",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ],
                            )
                          ) 
                        ),
                        /*Container(
                          child: Image.asset(_setImage(),
                            scale: 7.5,
                            alignment: Alignment.centerRight,),
                        ),*/
                      ],
                    ),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                        offset: Offset(
                          0, // horizontal, move right 10
                          2, // vertical, move down 10
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25,),
                Container(
                height: 100,
                width:  MediaQuery.of(context).size.width,                   
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width/1.5,
                          child: Padding(
                            padding: EdgeInsets.only(left: 25, top: 26),
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Temperatura máxima",style: TextStyle(fontSize: 18),),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: FutureBuilder(
                                    future: getTemp(),
                                    builder: (BuildContext context, AsyncSnapshot snapshot)=>Text("$tempMax°C",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ],
                            )
                          ) 
                        ),
                        Container(
                          child: Image.asset("assets/images/temperature.png",
                            scale: 7.5,
                            alignment: Alignment.centerRight,),
                        ),
                      ],
                    ),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                        offset: Offset(
                          0, // horizontal, move right 10
                          2, // vertical, move down 10
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25,),
                    Container(
                height: 100,
                width:  MediaQuery.of(context).size.width,                   
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width/1.5,
                          child: Padding(
                            padding: EdgeInsets.only(left: 25, top: 26),
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Temperatura mínima",style: TextStyle(fontSize: 18),),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,          
                                  child: FutureBuilder(
                                    future: getTemp(),
                                    builder: (BuildContext context, AsyncSnapshot snapshot)=>Text("$tempMin°C",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ],
                            )
                          ) 
                        ),
                        Container(
                          child: Image.asset("assets/images/cold.png",
                            scale: 7.5,
                            alignment: Alignment.centerRight,),
                        ),
                      ],
                    ),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                        offset: Offset(
                          0, // horizontal, move right 10
                          2, // vertical, move down 10
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}