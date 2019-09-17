import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';

int _darkBlue = 0xFF022859;
int _lightBlue = 0xFF6AAED9;

class Loader extends StatefulWidget {
  var pantallas;
  var nombreDrawer;
  var correoDrawer;
  Loader({Key key, @required this.pantallas, this.correoDrawer, this.nombreDrawer}) : super (key : key);
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation <double> animation_rotation;
  Animation <double> animation_radius_in;
  Animation <double> animation_radius_out;
  var pantalla;
  final double _radius = 100.0;
  double radius = 0.0;

  @override
  void initState(){
    super.initState();
    pantalla = widget.pantallas;
    /*Future.delayed(Duration(seconds: 5),(){
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => pantalla ),
          (Route<dynamic>route) =>false,
      );
    });*/
    Timer(Duration(seconds: 5),() =>Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => pantalla)
      )
    );

    
    controller = AnimationController(vsync: this,duration: Duration(seconds: 4));
    
    animation_rotation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller,curve: Interval(0.0, 1.0,curve: Curves.linear)));

    animation_radius_in = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: controller,curve: Interval(
      0.75,1.0, curve: Curves.elasticIn
    )));

    animation_radius_out = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller,curve: Interval(
      0.0,0.25, curve: Curves.elasticOut
    )));

    controller.addListener((){
      setState(() {
        if(controller.value >= 0.75 && controller.value <= 1.0){
        radius = animation_radius_in.value * _radius;
      }else if(controller.value >= 0.0 && controller.value <= 0.25){
        radius = animation_radius_out.value * _radius;
      }
      });
    });
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 500,
      height: 500,
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
            color: Colors.white,
            child: Image.asset('assets/images/Logo_1000px.png',scale: 30,),
            ),
          ),
          Center(
          child: RotationTransition(
            turns: animation_rotation,
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset(radius*cos(pi/4), radius*sin(pi/4)),
                  child: Dot(
                    radius: 15.0,
                    color: Color(_darkBlue),),
                ),
                Transform.translate(
                  offset: Offset(radius*cos(2*pi/4), radius*sin(2*pi/4)),
                  child: Dot(
                    radius: 10.0,
                    color: Color(_lightBlue),),
                ),
                Transform.translate(
                  offset: Offset(radius*cos(3*pi/4), radius*sin(3*pi/4)),
                  child: Dot(
                    radius: 15.0,
                    color: Color(_darkBlue),),
                ),
                Transform.translate(
                  offset: Offset(radius*cos(4*pi/4), radius*sin(4*pi/4)),
                  child: Dot(
                    radius: 10.0,
                    color: Color(_lightBlue),),
                ),
                Transform.translate(
                  offset: Offset(radius*cos(5*pi/4), radius*sin(5*pi/4)),
                  child: Dot(
                    radius: 15.0,
                    color: Color(_darkBlue),),
                ),
                Transform.translate(
                  offset: Offset(radius*cos(6*pi/4), radius*sin(6*pi/4)),
                  child: Dot(
                    radius: 10.0,
                    color: Color(_lightBlue),),
                ),
                Transform.translate(
                  offset: Offset(radius*cos(7*pi/4), radius*sin(7*pi/4)),
                  child: Dot(
                    radius: 15.0,
                    color: Color(_darkBlue),),
                ),
                Transform.translate(
                  offset: Offset(radius*cos(8*pi/4), radius*sin(8*pi/4)),
                  child: Dot(
                    radius: 10.0,
                    color: Color(_lightBlue),),
                )
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {

  final double radius;
  final Color color;

  Dot({this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: this.radius,
        height: this.radius,
        decoration: BoxDecoration(
          color: this.color,
          shape: BoxShape.circle
        ),
      ),
    );
  }
  
}
