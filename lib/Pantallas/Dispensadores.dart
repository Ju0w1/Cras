import 'dart:convert';
import 'package:cras/Modelo/Estado.dart';
import 'package:cras/Modelo/rec_real.dart';
import 'package:cras/Modelo/temp_real.dart';
import 'package:cras/Pantallas/Mantenimiento.dart';
import 'package:cras/Pantallas/Mapa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'SubPantallas/AgregarMantenimiento.dart';
import 'SubPantallas/ListaMantenimiento.dart';
import 'AgregarDispensador.dart';
import 'Resumen.dart';

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
var tempActualImagen;
var tempActual;
var tempMax;
var tempMin;
var recActual;
var largo;
var serie;
var tiempo =1;
var nombre;
var estado;
var imagen;

class _Dispensadores extends State<PantallaDispensadores>{
  void initState(){
    super.initState();
    nombre = widget.nombreDisp;
    serie = widget.nroSerie;
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

  Future getTempActual()async{
    var respose = await http.get("$_urlTmpReal&serie=$serie");
    if(respose.statusCode == 200){
      tempReal = TempReal.fromJson(json.decode(respose.body));
      if(tempReal.realizado == "1"){
        largo = tempReal.temperatura.length;
        tempActual = tempReal.temperatura[largo-1].prom;
      }
    }
    return tempActual;
  }
  Future getTempMax()async{
    var respose = await http.get("$_urlTmpReal&serie=$serie");
    if(respose.statusCode == 200){
      tempReal = TempReal.fromJson(json.decode(respose.body));
      if(tempReal.realizado == "1"){
        largo = tempReal.temperatura.length;
        tempMax = tempReal.temperatura[largo-1].max;
        tempActual = tempReal.temperatura[largo-1].prom;
      }
    }
    return tempMax;
  }
  Future getTempMin()async{
    var respose = await http.get("$_urlTmpReal&serie=$serie");
    if(respose.statusCode == 200){
      tempReal = TempReal.fromJson(json.decode(respose.body));
      if(tempReal.realizado == "1"){
        largo = tempReal.temperatura.length;
        tempMin = tempReal.temperatura[largo-1].min;
      }
    }
    return tempMin;
  }
  Future getTempImagen()async{
    var respose = await http.get("$_urlTmpReal&serie=$serie");
    if(respose.statusCode == 200){
      tempReal = TempReal.fromJson(json.decode(respose.body));
      if(tempReal.realizado == "1"){
        largo = tempReal.temperatura.length;
        tempActualImagen = tempReal.temperatura[largo-1].prom;
        if(int.parse(tempActualImagen) >= 75) {
          setState(() {
            imagen="assets/images/temperature.png";
          });
        } else if(int.parse(tempActualImagen) < 75) {
          setState(() {
            imagen="assets/images/cold.png";
          });
        }
      }
    }
    return imagen;
  }

  Future getRec()async{
    var respose = await http.get("$_urlRecReal&serie=$serie");
    if(respose.statusCode == 200){
      recReal = RecReal.fromJson(json.decode(respose.body));
      if(recReal.realizado == "1"){
        recActual = recReal.total[0].recaudado;
      }
    }
    return recActual;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        actions: <Widget>[
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(
                child: Icon(Icons.note_add),
                onTap: (){
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    child: new CupertinoAlertDialog(
                      content: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.note),
                                  SizedBox(width: 15),
                                  Text(
                                    "Lista de los Mantenimientos",
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                  )
                                ],
                              ),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> ListaMantenimiento(nro_serie:serie,nombre:widget.nombreUsuario,correo:widget.correoUsuario))),
                            ),
                            SizedBox(height: 15,),
                            GestureDetector(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.note_add),
                                  SizedBox(width: 15,),
                                  Text("Agregar Mantenimiento",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)
                                ],
                              ),
                              onTap:() => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> AgregarMantenimiento())),
                            )
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: new Text("OK"))
                      ],
                    )
                  );
                },
              )
            ],
          )
        ],
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
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Mapa(nombre: widget.nombreUsuario,correo: widget.correoUsuario,)
                    ),
                  );
                },
              ),
              new ListTile(
                title: Text("Resumen"),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Resumen(nombre: widget.nombreUsuario,correo: widget.correoUsuario,)
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
                      builder: (BuildContext context) => AgregarDispensador(nombre: widget.nombreUsuario,correo: widget.correoUsuario,)
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
                      builder: (BuildContext context) => Mantenimiento(nombre: widget.nombreUsuario,correo: widget.correoUsuario,)
                    ),
                  );
                },
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
                child: FutureBuilder(
                  future: getRec(),
                  builder: (BuildContext context,AsyncSnapshot snapshot){
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
                                    child: Text("Recaudación actual:",style: TextStyle(fontSize: 18,),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(2),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("\$"+"$recActual",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
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
                  },
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
                    child: FutureBuilder(
                      future: getTempActual(),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
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
                                        child: Text("Temperatura actual",style: TextStyle(fontSize: 18),),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(2),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,          
                                        child: Text("$tempActual°C",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                                      ),
                                    ],
                                  )
                                ) 
                              ),
                              Container(
                                child: FutureBuilder(
                                  future: getTempImagen(),
                                  builder: (BuildContext context, AsyncSnapshot snapshot){
                                    if(snapshot.data == null){
                                      return  Center(
                                          child:  CircularProgressIndicator(
                                          backgroundColor: Color(_darkBlue),
                                        ),
                                      );
                                    }else{
                                      return Image.asset(imagen,
                                        scale: 7.5,
                                        alignment: Alignment.centerRight,
                                      );
                                    }
                                  }
                                )
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
                SizedBox(height: 25,),
                Container(
                height: 100,
                width:  MediaQuery.of(context).size.width,                   
                    child: FutureBuilder(
                      future: getTempMax(),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
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
                                        child: Text("Temperatura máxima",style: TextStyle(fontSize: 18),),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(2),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,          
                                        child: Text("$tempMax°C",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
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
                SizedBox(height: 25,),
                Container(
                  height: 100,
                  width:  MediaQuery.of(context).size.width,                   
                    child: FutureBuilder(
                      future: getTempMin(),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
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
                                        child: Text("Temperatura mínima",style: TextStyle(fontSize: 18),),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(2),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,          
                                        child: Text("$tempMin°C",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
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
            ],
          ),
        ),
      ),
    );
  }
}