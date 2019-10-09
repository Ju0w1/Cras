class Conexion {
  List<Estado> estado;
  String mensaje;
  String realizado;

  Conexion({this.estado, this.mensaje, this.realizado});

  Conexion.fromJson(Map<String, dynamic> json) {
    if (json['Estado'] != null) {
      estado = new List<Estado>();
      json['Estado'].forEach((v) {
        estado.add(new Estado.fromJson(v));
      });
    }
    mensaje = json['Mensaje'];
    realizado = json['Realizado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.estado != null) {
      data['Estado'] = this.estado.map((v) => v.toJson()).toList();
    }
    data['Mensaje'] = this.mensaje;
    data['Realizado'] = this.realizado;
    return data;
  }
}

class Estado {
  String estado;
  String year;
  String month;
  String day;
  String hour;
  String minute;

  Estado(
      {this.estado, this.year, this.month, this.day, this.hour, this.minute});

  Estado.fromJson(Map<String, dynamic> json) {
    estado = json['Estado'];
    year = json['Year'];
    month = json['Month'];
    day = json['Day'];
    hour = json['Hour'];
    minute = json['Minute'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Estado'] = this.estado;
    data['Year'] = this.year;
    data['Month'] = this.month;
    data['Day'] = this.day;
    data['Hour'] = this.hour;
    data['Minute'] = this.minute;
    return data;
  }
}