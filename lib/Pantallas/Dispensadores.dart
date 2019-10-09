import 'dart:convert';
import 'package:cras/Modelo/Estado.dart';
import 'package:cras/Modelo/agregar_mantenimiento.dart';
import 'package:cras/Modelo/rec_real.dart';
import 'package:cras/Modelo/remover_disp.dart';
import 'package:cras/Modelo/retiro.dart';
import 'package:cras/Modelo/temp_real.dart';
import 'package:cras/Pantallas/Mapa.dart';
import 'package:cras/Pantallas/SubPantallas/ListaMantenimiento.dart' as prefix0;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Modelo/graficaRec.dart';
import 'SubPantallas/AgregarMantenimiento.dart';
import 'SubPantallas/ListaMantenimiento.dart';
import 'AgregarDispensador.dart';
import 'Resumen.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import 'package:intl/intl.dart';

int _darkBlue = 0xFF022859;

TempReal tempReal;
RecReal recReal;
GraficaRec recgraficareal;
Conexion conexion;
Remover remover;
Retiro retiro;

const _urlTmpReal ="http://cras-dev.com/Interfaz/interfaz.php?auth=4kebq1J2MD&tipo=temp_rel";
const _urlRecReal ="http://cras-dev.com/Interfaz/interfaz.php?auth=4kebq1J2MD&tipo=recrel";
const _urlRecGrafReal ="http://cras-dev.com/Interfaz/interfaz.php?auth=4kebq1J2MD&tipo=recgraf";
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
var hour;
var minute;
var day;
var month;
var year;
var prueba;
int day2;
var hora2;
var horaCel;
var diaCel;
List<Rec> recgraf = [];
class _Dispensadores extends State<PantallaDispensadores>{
  void initState(){
    super.initState();
    nombre = widget.nombreDisp;
    serie = widget.nroSerie;
    getConexion();
    horaCel=DateTime.now().hour.toInt();
    diaCel=DateTime.now().day.toInt();
    print(getConexion());
  }
  Future getConexion()async{
    var response = await http.get("$_urlConexion&serie=${widget.nroSerie}");
    if(response.statusCode==200){
      conexion = Conexion.fromJson(json.decode(response.body));
      if(conexion.realizado == "1"){
        var largocon = conexion.estado.length;
        estado = conexion.estado[largocon-1].estado;
        hour = int.parse(conexion.estado[largocon-1].hour);
        ///hour = hour +1;
        day = int.parse(conexion.estado[largocon-1].day);
        day2 = day -1;
        //hora2 = await hour-1;
      }
    }
    return [estado,hour,day,day2];
  }
  Future grafica()async{
    var respose = await http.get("$_urlTmpReal&serie=$serie");
    if(respose.statusCode == 200){
      tempReal = TempReal.fromJson(json.decode(respose.body));
      if(tempReal.realizado == "1"){
        var largo = tempReal.temperatura.length;
        tempMax = tempReal.temperatura[largo-1].max;
        tempMin = tempReal.temperatura[largo-1].min;
      }
    }
    final data = [
      new Data("Maxima",int.parse(tempMax)),
      new Data("Minima",int.parse(tempMin)),
    ];
    return [
      new charts.Series<Data, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        displayName: "Temperatúra Máxima y Mínima",
        domainFn: (Data sales, _) => sales.tipo,
        measureFn: (Data sales, _) => sales.valor,
        data: data,
        labelAccessorFn: (Data sales,_) => '${sales.tipo} : ${sales.valor.toString()}°C'
      )
    ];
  }
  Future graficaRec() async{
    recgraf.clear();
    var respose = await http.get("$_urlRecGrafReal&serie=$serie");  
    if(respose.statusCode == 200){
      recgraficareal = GraficaRec.fromJson(json.decode(respose.body));
      if(recgraficareal.realizado == "1"){
        for(int i = 0; i < recgraficareal.total.length; i++){
          recgraf.add(new Rec(DateTime.parse(recgraficareal.total[i].fecha),int.parse(recgraficareal.total[i].recaudado)));
        }
      }
    }
    return [
      charts.Series<Rec,DateTime>(
        data: recgraf,
        domainFn: (Rec rec,_)=>rec.fecha,
        measureFn: (Rec rec,_)=>rec.valor,
        id: 'Recaudado',
        colorFn: (_,__)=>charts.MaterialPalette.blue.shadeDefault
      )
    ];
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
                child: Icon(Icons.settings),
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
                              onTap:() => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> AgregarMantenimiento(nro_serie: widget.nroSerie,))),
                            ),
                            SizedBox(height: 15,),
                            GestureDetector(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.location_off),
                                  SizedBox(width: 15),
                                  Text(
                                    "Remover ubicación",
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                  ),
                                ],
                              ),
                              onTap: ()async{
                                final response = await http.get("http://cras-dev.com/Interfaz/interfaz.php?auth=4kebq1J2MD&tipo=baja&serie=${widget.nroSerie}");
                                if (response.statusCode == 200){
                                  remover = Remover.fromJson(json.decode(response.body));
                                  if(remover.realizado == "1"){
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Mapa(nombre: widget.nombreUsuario,correo: widget.correoUsuario,)), (Route<dynamic> route) => false);
                                  }else{
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(remover.mensaje),
                                    ));
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: new Text("OK")
                        )
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
          ],
        ),
      ),
      body: Builder(
        builder: (BuildContext context){
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  FutureBuilder(
                    future: getConexion(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(snapshot.data == null){
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Color(_darkBlue),
                            ),
                          ),
                        );
                      }
                      else if(snapshot.data[0]== "1" && snapshot.data[1] == DateTime.now().hour.toInt() && (snapshot.data[2] == diaCel || snapshot.data[3] == diaCel)){
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Conexión: ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold ),),
                              Text("En Línea",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.lightGreen)),
                            ],
                          ),
                        );
                      }else{
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Conexión: ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold ),),
                              Text("Sin Conexión",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.red)),
                            ],
                          ),
                        ); 
                      }
                    },
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
                    InkWell(
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width/2,
                        decoration: new BoxDecoration(
                          color: Color(_darkBlue),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        child: Center(
                          child: Text(
                            "Retirar recaudación",style: TextStyle(color: Colors.white),
                          )
                        ),
                      ),
                      onTap: ()async{
                        final response = await http.get("http://www.cras-dev.com/Interfaz/interfaz.php?auth=4kebq1J2MD&tipo=retiro&correo=${widget.correoUsuario}&serie=${widget.nroSerie}");
                        if (response.statusCode == 200){
                          retiro = Retiro.fromJson(json.decode(response.body));
                          if(retiro.realizado == "1"){
                            print("Retirado correctamente");
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(retiro.mensaje),
                            ));
                          }else{
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(retiro.mensaje),
                            ));
                          }
                        }else{
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Fallo de conexión"),
                          ));
                        }
                      },
                    ),
                  SizedBox(height: 25,),
                  Container(
                      height: 100,
                      child: FutureBuilder(
                        future: graficaRec(),
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          if(snapshot.data == null){
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Color(_darkBlue),
                              ),
                            );
                          }else{
                            return charts.TimeSeriesChart(snapshot.data,animate: true,animationDuration: Duration(seconds: 1));
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
                          future: getTempActual() ,
                          builder: (BuildContext context, AsyncSnapshot snapshot){
                            if(snapshot.data == null){
                              print(snapshot.data);
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
                    height: 250,
                    width:  MediaQuery.of(context).size.width,                   
                        child: FutureBuilder(
                          future: grafica(),
                          builder: (BuildContext context, AsyncSnapshot snapshot){
                            if(snapshot.data == null){
                              return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Color(_darkBlue),
                                ),
                              );
                            }else{
                              return Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: charts.BarChart(
                                    snapshot.data,vertical: true,
                                    barRendererDecorator: charts.BarLabelDecorator<String>(
                                    ),
                                    domainAxis: charts.OrdinalAxisSpec(
                                      renderSpec: charts.NoneRenderSpec()
                                    ),
                                    animate: true,
                                    animationDuration: Duration(seconds: 2),
                                    behaviors: [
                                      charts.ChartTitle("Temperatura Máxima y Mínima",titleStyleSpec: charts.TextStyleSpec(fontSize: 12,)),
                                    ],
                                  ),
                                ),
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
                  ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Rec{
  DateTime fecha;
  int valor;
  Rec(this.fecha,this.valor);
}

class Data{
  String tipo;
  int valor;
  Data(this.tipo,this.valor);
}