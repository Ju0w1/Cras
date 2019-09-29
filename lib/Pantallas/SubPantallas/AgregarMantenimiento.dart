import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cras/Modelo/agregar_mantenimiento.dart';
import 'package:flutter/material.dart';

class AgregarMantenimiento extends StatefulWidget{

  @override
  _AgregarMantenimiento createState() =>  _AgregarMantenimiento();
}

int _darkBlue = 0xFF022859;
AddMantenimiento addMantenimiento;

 String mensaje_snackAddMant;

  GlobalKey<ScaffoldState> _scaffoldKeyAgregarMant = new GlobalKey<ScaffoldState>();
  _showSnackBar(){
    final snackBar = new SnackBar(
      content: Text(mensaje_snackAddMant),
      duration: Duration(seconds: 3),
    );
    _scaffoldKeyAgregarMant.currentState.showSnackBar(snackBar).close();
  }

class _AgregarMantenimiento extends State<AgregarMantenimiento>{

    final TextEditingController comentariocontroller = TextEditingController();
    List _selecteCategorys = List();
    List _nombres = List();
    bool id;
    Map<String, dynamic> _categories = {
      "responseCode": "1",
      "responseText": "List categories.",
      "responseBody": [
        {"category_id": "1", "category_name": "Cambio de placa temporizadora"},
        {"category_id": "2", "category_name": "Cambio de placa de temperatura"},
        {"category_id": "3", "category_name": "Cambio de monedero"},
        {"category_id": "4", "category_name": "Cambio de fuente 12V"},
        {"category_id": "5", "category_name": "Cambio de calefón"},
        {"category_id": "6", "category_name": "Cambio de botón"},
        {"category_id": "7", "category_name": "Cambio de luz"},
        {"category_id": "8", "category_name": "Cambio de manguera/as"},
        {"category_id": "9", "category_name": "Otros"}
      ],
      "responseTotalResult": 9 // Total result is 9 here becasue we have 9 categories in responseBody.
    };

    void _onCategorySelected(bool selected, category_id) {
      if (selected == true) {
        setState(() {
          _selecteCategorys.add(category_id);
          if(category_id == "9" && selected == true){
            id = true;
          }else if(category_id == "9" && selected == false){
            id = false;
          }
        });
      }else {
        setState(() {
          _selecteCategorys.remove(category_id);
        });
      }
    }
  Future otro() async{
    if(id == true){
      return true;
    }
    else{
      return null;
    }
  }
    void _selectedNombres(bool selected, category_name) {
      if (selected == true) {
        setState(() {
          _nombres.add(category_name);
        });
      }else {
        setState(() {
          _nombres.remove(category_name);
        });
      }
    }
  
  List <String> mantienimientos = [];
  //int i;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKeyAgregarMant,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Agregar Mantenimiento"),
        backgroundColor: Color(_darkBlue),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height/1.5,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: _categories['responseTotalResult'],
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    value: _selecteCategorys.contains(_categories['responseBody'][index]['category_id']),
                    onChanged: (bool selected) {
                      _onCategorySelected(selected,_categories['responseBody'][index]['category_id']);
                      _selectedNombres(selected,_categories['responseBody'][index]['category_name']);
                    },
                    title: Text(_categories['responseBody'][index]['category_name']),
                  );
                }
              ),
            ),
            SizedBox(
              height: 5,
            ),
            FutureBuilder(
              future: otro(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if (snapshot.hasData){
                  return Padding(
                    padding: const EdgeInsets.only(left: 25,right: 25,),
                    child: Container(
                      child: TextField(
                        controller: comentariocontroller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.add_comment,color: Color(_darkBlue),),
                          labelText: 'Comentario',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                        ),
                      ),
                    ),
                  );
                }else {
                  return SizedBox(
                    height: 10,
                  );
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width/2,
                height: 40,
                decoration: new BoxDecoration(
                  color: Color(_darkBlue),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Center(
                  child: Text(
                    'Agregar'.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              onTap: () async{
                 final response = await http.get("http://cras-dev.com/Interfaz/interfaz.php?auth=4kebq1J2MD&tipo=mantenimiento&serie=3&comentario=${_nombres.toString()+", "+comentariocontroller.text}");
                 if (response.statusCode == 200){
                   addMantenimiento = AddMantenimiento.fromJson(json.decode(response.body));
                   if(addMantenimiento.realizado == "1"){
                     comentariocontroller.clear();
                     mensaje_snackAddMant = addMantenimiento.mensaje;
                     _showSnackBar();
                   }else{
                     mensaje_snackAddMant = addMantenimiento.mensaje;
                     _showSnackBar();
                   }
                 }else{
                  mensaje_snackAddMant == "Fallo de conexión";
                  _showSnackBar();
                 }
              },
            ),
            /*SizedBox(
              height: 15,
            )*/
          ],
        )
      )
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

/*

import 'dart:convert';

import 'package:cras/Modelo/agregar_mantenimiento.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() => runApp(new MyApp());

AddMantenimiento addMantenimiento;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Multi-Select & Unselect Checkbox in Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _selecteCategorys = List();
  List _nombres = List();

  Map<String, dynamic> _categories = {
    "responseCode": "1",
    "responseText": "List categories.",
    "responseBody": [
      {"category_id": "5", "category_name": "Barber"},
      {"category_id": "3", "category_name": "Es"},
      {"category_id": "7", "category_name": "Cook"}
    ],
    "responseTotalResult":
        3 // Total result is 3 here becasue we have 3 categories in responseBody.
  };

  void _onCategorySelected(bool selected, category_id) {
    if (selected == true) {
      setState(() {
        _selecteCategorys.add(category_id);
      });
    }else {
      setState(() {
        _selecteCategorys.remove(category_id);
      });
    }
  }

  void _selectedNombres (bool selected, category_name) {
    if (selected == true) {
      setState(() {
        _nombres.add(category_name);
      });
    }else {
      setState(() {
        _nombres.remove(category_name);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height/1.5,
              child: ListView.builder(
                itemCount: _categories['responseTotalResult'],
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    value: _selecteCategorys.contains(_categories['responseBody'][index]['category_id']),
                    onChanged: (bool selected) {
                      _onCategorySelected(selected,_categories['responseBody'][index]['category_id']);
                      _selectedNombres(selected,_categories['responseBody'][index]['category_name']);
                    },
                    title: Text(_categories['responseBody'][index]['category_name']),
                  );
                }),
            ),
            SizedBox(
              height: 25,
            ),
            FlatButton(
              child: Text("Press"),
              onPressed: () async{
                print(_nombres);
                 final response = await http.get("http://cras-dev.com/Interfaz/interfaz.php?auth=4kebq1J2MD&tipo=mantenimiento&serie=3&comentario=${_nombres.toString()}");
                 if (response.statusCode == 200){
                   addMantenimiento = AddMantenimiento.fromJson(json.decode(response.body));
                   if(addMantenimiento.realizado == "1"){
                     print("Agregado correctamente");
                   }
                 }
              },
            )
          ],
        ),
      )
    );
  }
}
*/