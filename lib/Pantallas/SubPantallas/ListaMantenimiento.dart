//=====================IMPORTS=====================\\
import 'package:flutter/material.dart';
import '../../Modelo/ListaMant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListaMantenimiento extends StatefulWidget{
  var nro_serie, nombre, correo;
  ListaMantenimiento({Key key, @required this.nro_serie, this.nombre, this.correo}) : super (key : key);
  @override
  _ListaMantenimiento createState() => _ListaMantenimiento();
}

int _darkBlue = 0xFF022859;
ListaMant lista;
Mantenimineto mant;
List<String> serie = [];
List<String> nombre = [];
List<String> fecha = [];
List<String> comentario = [];

final _url = "http://cras-dev.com/Interfaz/interfaz.php?auth=4kebq1J2MD&tipo=lista";

//=====================PANTALLA=====================\\
class _ListaMantenimiento extends State<ListaMantenimiento>{

//=====================FUTURE=====================\\
  Future getList() async{
    var response = await http.get(_url);
    if(response.statusCode == 200){
      lista = ListaMant.fromJson(json.decode(response.body));
      if(lista.realizado == "1"){
       /* for (int i = 0 ; i < lista.mantenimineto.length ; i++){
          serie.add(lista.mantenimineto[i].nroSerie);
          nombre.add(lista.mantenimineto[i].lugar);
          fecha.add(lista.mantenimineto[i].fecha);
          comentario.add(lista.mantenimineto[i].comentario);
        }*/
      }else{

      }
    }else{

    } 
  }

  @override
  void initState(){
    super.initState();
    getList();
  }
  @override
  Widget build(BuildContext context){ 
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Mantenimiento"),
        centerTitle: true,
        backgroundColor: Color(_darkBlue),
      ),
      body: _buildListView(lista),
    );
  }
  Widget _buildListView(ListaMant mant){
    return Row(
      children: <Widget>[
        Flexible(
          child: ListView.builder(
            itemCount: mant == null ? 0 : mant.mantenimineto.length,
            itemBuilder: (BuildContext context, int index) => buildMantListItem(mant.mantenimineto[index]),
          ),
        )
      ],
    );
  }

  Widget buildMantListItem(Mantenimineto item){
    return Card(
      child: Container(
        padding: EdgeInsets.only(bottom: 4.0,left: 4.0,right: 4.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  item.nroSerie + " " + item.lugar
                ),
                SizedBox(width: 10,),
                Text(
                  item.fecha
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Text(
                  item.comentario
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}