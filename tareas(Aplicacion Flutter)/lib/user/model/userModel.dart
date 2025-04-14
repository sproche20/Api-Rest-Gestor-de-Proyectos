class Usermodel {
  int? id;
  String nombreUser;
  String email;
  String rol;
  Usermodel(
      {this.id,
      required this.nombreUser,
      required this.email,
      required this.rol});
  factory Usermodel.fromJson(Map<String, dynamic> json) {
    return Usermodel(
        id: json['id'],
        nombreUser: json['nombreUser'],
        email: json['email'],
        rol: json['rol']);
  }
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombreUser': nombreUser,
      'email': email,
      'rol': rol
    };
  }
}
