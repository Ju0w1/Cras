class ListaMant {
  List<Mantenimineto> mantenimineto;
  String mensaje;
  String realizado;

  ListaMant({this.mantenimineto, this.mensaje, this.realizado});

  ListaMant.fromJson(Map<String, dynamic> json) {
    if (json['Mantenimineto'] != null) {
      mantenimineto = new List<Mantenimineto>();
      json['Mantenimineto'].forEach((v) {
        mantenimineto.add(new Mantenimineto.fromJson(v));
      });
    }
    mensaje = json['Mensaje'];
    realizado = json['Realizado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mantenimineto != null) {
      data['Mantenimineto'] =
          this.mantenimineto.map((v) => v.toJson()).toList();
    }
    data['Mensaje'] = this.mensaje;
    data['Realizado'] = this.realizado;
    return data;
  }
}

class Mantenimineto {
  String nroSerie;
  String lugar;
  String fecha;
  String comentario;

  Mantenimineto({this.nroSerie, this.lugar, this.fecha, this.comentario});

  Mantenimineto.fromJson(Map<String, dynamic> json) {
    nroSerie = json['Nro_serie'];
    lugar = json['Lugar'];
    fecha = json['Fecha'];
    comentario = json['Comentario'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Nro_serie'] = this.nroSerie;
    data['Lugar'] = this.lugar;
    data['Fecha'] = this.fecha;
    data['Comentario'] = this.comentario;
    return data;
  }
}