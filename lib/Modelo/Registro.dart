class Reg {
  String realizado;
  String mensaje;

  Reg({this.realizado, this.mensaje});

  Reg.fromJson(Map<String, dynamic> json) {
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