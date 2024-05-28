import 'eleve_model.dart';
import 'parent_model.dart';
import 'professeur_model.dart';

class User {
  int? id;
  String? token;
  String? username;
  String? email;
  String? lastLogin;
  String? imageProfile;
  String? firstName;
  String? lastName;
  bool? isActive;
  bool? isProfesseur;
  bool? isEleve;
  bool? isParent;
  UserDetails? userDetails;

  User({
    this.email,
    this.firstName,
    this.lastName,
    this.id,
    this.username,
    this.imageProfile,
    this.isActive,
    this.isParent,
    this.isEleve,
    this.isProfesseur,
    this.lastLogin,
    this.userDetails,
  });

  User copyWith({
    String? email,
    String? firstName,
    String? lastName,
    int? id,
    String? username,
    String? imageProfile,
    bool? isActive,
    bool? isParent,
    bool? isEleve,
    bool? isProfesseur,
    String? lastLogin,
    UserDetails? userDetails,
  }) {
    return User(
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      id: id ?? this.id,
      username: username ?? this.username,
      imageProfile: imageProfile ?? this.imageProfile,
      isActive: isActive ?? this.isActive,
      isParent: isParent ?? this.isParent,
      isEleve: isEleve ?? this.isEleve,
      isProfesseur: isProfesseur ?? this.isProfesseur,
      lastLogin: lastLogin ?? this.lastLogin,
      userDetails: userDetails ?? this.userDetails,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json["email"],
      firstName: json["first_name"],
      id: json["pk"],
      lastName: json["last_name"],
      username: json["username"],
      imageProfile: json["image_profil"],
      isActive: json["is_active"],
      isParent: json["is_parent"],
      isEleve: json["is_eleve"],
      isProfesseur: json["is_professeur"],
      lastLogin: json["last_login"],
      userDetails: UserDetails.fromJson(json["user_details"]),
    );
  }
}

class UserDetails {
  String? role;
  Parent? parent;
  Professeur? prof;
  Eleve? eleve;

  UserDetails({
    this.role,
    this.parent,
    this.prof,
    this.eleve,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    final role = json['role'];

    return UserDetails(
      role: role,
      parent: role == 'parent' ? Parent.fromJson(json['info']) : null,
      prof: role == 'prof' ? Professeur.fromJson(json['info']) : null,
      eleve: role == 'eleve' ? Eleve.fromJson(json['info']) : null,
    );
  }
}
