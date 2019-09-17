//=====================IMPORTS=====================\\
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


int _darkBlue = 0xFF022859;
int _midBlue = 0xFF2E78A6;
int _lightBlue = 0xFF6AAED9;

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
                    child: Image.asset("assets/images/Logo 800px.png",scale:11,),
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
                        SizedBox(height: 10,)
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