class GraficaRec {
  List<Total> total;
  String realizado;
  String mensaje;

  GraficaRec({this.total, this.realizado, this.mensaje});

  GraficaRec.fromJson(Map<String, dynamic> json) {
    if (json['Total'] != null) {
      total = new List<Total>();
      json['Total'].forEach((v) {
        total.add(new Total.fromJson(v));
      });
    }
    realizado = json['Realizado'];
    mensaje = json['Mensaje'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.total != null) {
      data['Total'] = this.total.map((v) => v.toJson()).toList();
    }
    data['Realizado'] = this.realizado;
    data['Mensaje'] = this.mensaje;
    return data;
  }
}

class Total {
  String recaudado;
  String dispensador;
  String fecha;

  Total({this.recaudado, this.dispensador, this.fecha});

  Total.fromJson(Map<String, dynamic> json) {
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
