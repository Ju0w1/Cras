class TempReal {
  List<Temperatura> temperatura;
  String mensaje;
  String realizado;

  TempReal({this.temperatura, this.mensaje, this.realizado});

  TempReal.fromJson(Map<String, dynamic> json) {
    if (json['Temperatura'] != null) {
      temperatura = new List<Temperatura>();
      json['Temperatura'].forEach((v) {
        temperatura.add(new Temperatura.fromJson(v));
      });
    }
    mensaje = json['Mensaje'];
    realizado = json['Realizado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.temperatura != null) {
      data['Temperatura'] = this.temperatura.map((v) => v.toJson()).toList();
    }
    data['Mensaje'] = this.mensaje;
    data['Realizado'] = this.realizado;
    return data;
  }
}

class Temperatura {
  String nroSerie;
  String max;
  String prom;
  String min;
  String fecha;

  Temperatura({this.nroSerie, this.max, this.prom, this.min, this.fecha});

  Temperatura.fromJson(Map<String, dynamic> json) {
    nroSerie = json['nro_serie'];
    max = json['max'];
    prom = json['prom'];
    min = json['min'];
    fecha = json['Fecha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nro_serie'] = this.nroSerie;
    data['max'] = this.max;
    data['prom'] = this.prom;
    data['min'] = this.min;
    data['Fecha'] = this.fecha;
    return data;
  }
}