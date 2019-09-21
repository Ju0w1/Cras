import 'dart:convert';
import 'package:cras/Pantallas/Mantenimiento.dart';
import 'package:cras/Pantallas/Mapa.dart';
import 'package:http/http.dart' as http;
import 'package:cras/Modelo/recTotal.dart';
import 'package:flutter/material.dart';
//import 'package:cras/Gráficas/Grafica.dart';

import 'AgregarDispensador.dart';

int _darkBlue = 0xFF022859;
var recActualTotal;

RecTotal recTotal;

const _urlRecReal = "http://cras-dev.com/Interfaz/interfaz.php?auth=4kebq1J2MD&tipo=rectot";

class Resumen extends StatefulWidget{
  var nombre;
  var correo;
  Resumen({Key key, @required this.nombre, this.correo}) : super (key : key);
  @override
  _Resumen createState() => _Resumen(); 
}

class _Resumen extends State<Resumen>{
  
  Future _getRecTot() async{
    var respose = await http.get("${_urlRecReal}");
      if(respose.statusCode == 200){
        recTotal = RecTotal.fromJson(json.decode(respose.body));
        if(recTotal.realizado == "1"){
          recActualTotal = recTotal.tot[0].recaudado;
        }
      }
    return recActualTotal;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: new AppBar(
        title: Text("Resumen"),
        centerTitle: true,
        backgroundColor: Color(_darkBlue),
      ),
      drawer: Drawer(
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text(widget.nombre),
            decoration: BoxDecoration(color: Color(_darkBlue)),
            accountEmail: new Text(widget.correo),
            currentAccountPicture: new CircleAvatar(
              backgroundImage: ExactAssetImage("assets/images/user.png"),
            ),
          ),
          new ListTile(
            title: Text("Mapa Dispensadores"),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Mapa(nombre: widget.nombre,correo: widget.correo,)
                ),
              );
            },
          ),
          new ListTile(
            title: Text("Resumen"),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Resumen(nombre: widget.nombre,correo: widget.correo,)
                ),
              );
            },
          ),
          new ListTile(
            title: Text("Agregar Dispensador"),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => AgregarDispensador(nombre: widget.nombre,correo: widget.correo,)
                ),
              );
            },
          ),
          new ListTile(
            title: Text("Mantenimientos"),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Mantenimiento(nombre: widget.nombre,correo: widget.correo,)
                ),
              );
            },
          ),
        ],
      ),
    ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
            Container(
                height: 100,
                width:  MediaQuery.of(context).size.width,                   
                child: FutureBuilder(
                  future: _getRecTot(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.data == null){
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Color(_darkBlue),
                        ),
                      );
                    }else{
                      return Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width/1.5,
                            child: Padding(
                              padding: EdgeInsets.only(left: 25, top: 26),
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Recaudación Total",style: TextStyle(fontSize: 18),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(2),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("\$"+"$recActualTotal",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
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
                      );
                    }
                  }
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
             Padding(
               padding: EdgeInsets.only(top:20),
             ),
             Container(
               padding: EdgeInsets.all(10),
               decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: Colors.white,
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
               height: 200,
               width: MediaQuery.of(context).size.width,
               //child: TimeSeriesLineAnnotationChart.withSampleData(),
             )
            ],
          ),
        ),
      ),
    );
  }
}