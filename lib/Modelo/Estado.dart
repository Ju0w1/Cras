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

  Estado({this.estado});

  Estado.fromJson(Map<String, dynamic> json) {
    estado = json['Estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Estado'] = this.estado;
    return data;
  }
}