class Dispensador {
  List<Dispensadores> dispensadores;

  Dispensador({this.dispensadores});

  Dispensador.fromJson(Map<String, dynamic> json) {
    if (json['Dispensadores'] != null) {
      dispensadores = new List<Dispensadores>();
      json['Dispensadores'].forEach((v) {
        dispensadores.add(new Dispensadores.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dispensadores != null) {
      data['Dispensadores'] =
          this.dispensadores.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dispensadores {
  String nroSerie;
  String lat;
  String long;
  String lugar;
  String total;
  String temperatura;

  Dispensadores(
      {this.nroSerie,
      this.lat,
      this.long,
      this.lugar,
      this.total,
      this.temperatura});

  Dispensadores.fromJson(Map<String, dynamic> json) {
    nroSerie = json['nro_serie'];
    lat = json['lat'];
    long = json['long'];
    lugar = json['lugar'];
    total = json['total'];
    temperatura = json['Temperatura'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nro_serie'] = this.nroSerie;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['lugar'] = this.lugar;
    data['total'] = this.total;
    data['Temperatura'] = this.temperatura;
    return data;
  }
}
