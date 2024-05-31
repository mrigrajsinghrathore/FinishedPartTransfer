class dbModel {
  String? Name;
  String? role;
  int? id;
  String? companyId;
  String? username;
  String? password;
  String? Email;



  dbModel({this.Name,this.role,this.id, this.companyId, this.username, this.password,this.Email});

  factory dbModel.formMap(Map<String, dynamic> map) {
    return dbModel(
      Name: map['Name'],
      role: map['role'],
        id: map['id'],
        companyId: map['companyId'],
        username: map['username'],
        password: map['password'],
        Email: map['Email'],
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': Name,
      'role': role,
      'id': id,
      'companyId': companyId,
      'username': username,
      'password': password,
      'Email': Email,

    };
  }
}