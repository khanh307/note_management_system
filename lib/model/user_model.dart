class UserModel {
  int? id;
  String? email;
  String? password;
  String? firstname;
  String? lastname;

  UserModel({this.id, this.email, this.password, this.firstname, this.lastname});

  Map<String, dynamic> toMap() {
    return{
      'id': id,
      'email': email,
      'password': password,
      'firstname': firstname,
      'lastname': lastname,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      firstname: map['firstname'],
      lastname: map['lastname'],
    );
  }
}