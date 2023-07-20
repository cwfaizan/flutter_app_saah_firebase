class UserModel {
  final id;
  final userEmail;
  final userPhone;
  final userName;
  final userDOB;
  final gender;
  final isAdmin;

  UserModel({
    required this.id,
    required this.userEmail,
    required this.userPhone,
    required this.userName,
    required this.userDOB,
    required this.gender,
    required this.isAdmin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        userEmail: json['email'],
        userPhone: json['phone'],
        userName: json['name'],
        userDOB: json['dob'],
        gender: json['gender'],
        isAdmin: json['is_admin'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": userEmail,
        "phone": userPhone,
        "name": userName,
        "dob": userDOB,
        "gender": gender,
        "is_admin": isAdmin,
      };
}
