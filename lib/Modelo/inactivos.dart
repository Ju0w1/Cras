
class Inactivos {
  List<Dispensadores> dispensadores;

  Inactivos({this.dispensadores});

  Inactivos.fromJson(Map<String, dynamic> json) {
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
  String serie;
  String activo;

  Dispensadores({this.serie, this.activo});

  Dispensadores.fromJson(Map<String, dynamic> json) {
    serie = json['Serie'];
    activo = json['Activo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Serie'] = this.serie;
    data['Activo'] = this.activo;
    return data;
  }
}