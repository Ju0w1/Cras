class Inicio {
  List<Logueo> logueo;
  String realizado;
  String mensaje;

  Inicio({this.logueo, this.realizado, this.mensaje});

  Inicio.fromJson(Map<String, dynamic> json) {
    if (json['Logueo'] != null) {
      logueo = new List<Logueo>();
      json['Logueo'].forEach((v) {
        logueo.add(new Logueo.fromJson(v));
      });
    }
    realizado = json['Realizado'];
    mensaje = json['Mensaje'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.logueo != null) {
      data['Logueo'] = this.logueo.map((v) => v.toJson()).toList();
    }
    data['Realizado'] = this.realizado;
    data['Mensaje'] = this.mensaje;
    return data;
  }
}

class Logueo {
  String nombre;
  String apellido;
  String correo;

  Logueo({this.nombre, this.apellido, this.correo});

  Logueo.fromJson(Map<String, dynamic> json) {
    nombre = json['nombre'];
    apellido = json['apellido'];
    correo = json['correo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombre'] = this.nombre;
    data['apellido'] = this.apellido;
    data['correo'] = this.correo;
    return data;
  }
}