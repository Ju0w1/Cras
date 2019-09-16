class AddUbicacion {
  String mensaje;
  String realizado;

  AddUbicacion({this.mensaje, this.realizado});

  AddUbicacion.fromJson(Map<String, dynamic> json) {
    mensaje = json['Mensaje'];
    realizado = json['Realizado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Mensaje'] = this.mensaje;
    data['Realizado'] = this.realizado;
    return data;
  }
}