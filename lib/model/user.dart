class User {
  String? email;
  String? nama;

  User({email, nama});

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        nama = json['nama'];
}
