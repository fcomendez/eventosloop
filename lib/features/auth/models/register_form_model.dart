class RegisterFormModel {
  RegisterFormModel({
    required this.nombres,
    required this.apellidos,
    required this.username,
    required this.fechaNacimiento,
    required this.genero,
    required this.direccion,
    required this.comuna,
    required this.region,
    required this.codigoPostal,
    required this.email,
    required this.password,
  });

  final String nombres;
  final String apellidos;
  final String username;
  final DateTime fechaNacimiento;
  final String genero;
  final String direccion;
  final String comuna;
  final String region;
  final String codigoPostal;
  final String email;
  final String password;
}
