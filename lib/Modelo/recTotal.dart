class RecTotal {
  List<Tot> tot;
  String realizado;
  String mensaje;

  RecTotal({this.tot, this.realizado, this.mensaje});

  RecTotal.fromJson(Map<String, dynamic> json) {
    if (json['Tot'] != null) {
      tot = new List<Tot>();
      json['Tot'].forEach((v) {
        tot.add(new Tot.fromJson(v));
      });
    }
    realizado = json['Realizado'];
    mensaje = json['Mensaje'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tot != null) {
      data['Tot'] = this.tot.map((v) => v.toJson()).toList();
    }
    data['Realizado'] = this.realizado;
    data['Mensaje'] = this.mensaje;
    return data;
  }
}

class Tot {
  String recaudado;

  Tot({this.recaudado});

  Tot.fromJson(Map<String, dynamic> json) {
    recaudado = json['Recaudado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Recaudado'] = this.recaudado;
    return data;
  }
}