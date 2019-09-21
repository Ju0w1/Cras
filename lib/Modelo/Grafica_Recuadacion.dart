class GrafRec {
  List<Recau> recau;
  String realizado;
  String mensaje;

  GrafRec({this.recau, this.realizado, this.mensaje});

  GrafRec.fromJson(Map<String, dynamic> json) {
    if (json['Recau'] != null) {
      recau = new List<Recau>();
      json['Recau'].forEach((v) {
        recau.add(new Recau.fromJson(v));
      });
    }
    realizado = json['Realizado'];
    mensaje = json['Mensaje'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.recau != null) {
      data['Recau'] = this.recau.map((v) => v.toJson()).toList();
    }
    data['Realizado'] = this.realizado;
    data['Mensaje'] = this.mensaje;
    return data;
  }
}

class Recau {
  String recaudado;
  String dispensador;
  String fecha;

  Recau({this.recaudado, this.dispensador, this.fecha});

  Recau.fromJson(Map<String, dynamic> json) {
    recaudado = json['Recaudado'];
    dispensador = json['Dispensador'];
    fecha = json['Fecha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Recaudado'] = this.recaudado;
    data['Dispensador'] = this.dispensador;
    data['Fecha'] = this.fecha;
    return data;
  }
}