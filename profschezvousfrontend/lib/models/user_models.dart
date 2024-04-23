class User {
  int? id;
  String? token;
  String? username;
  String? email,last_login,is_parent,image_profil,mmm, first_name, last_name;

  User({
    this.email,
    this.mmm,
    this.first_name,
    this.last_name,
    this.id,
    this.username,
    this.image_profil,
    this.is_parent,
    this.last_login,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json["email"],
      first_name: json["first_name"],
      mmm: json["mmm"],
      id: json["pk"],
      last_name: json["last_name"],
      username: json["username"],
      image_profil: json["image_profil"],
      is_parent: json["is_parent"],
      last_login: json["last_login"],
    );
  }
}
