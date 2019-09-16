class Registro {
  String realizado;
  String mensaje;

  Registro({this.realizado, this.mensaje});

  Registro.fromJson(Map<String, dynamic> json) {
    realizado = json['Realizado'];
    mensaje = json['Mensaje'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Realizado'] = this.realizado;
    data['Mensaje'] = this.mensaje;
    return data;
  }
}