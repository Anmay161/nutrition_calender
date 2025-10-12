class AddUser {
  final String? id;
  final String name;
  final String email;
  final String phoneNo;

  AddUser({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNo,
  });

  toJson() {
    return {
      "UserName": name,
      "Email": email,
      "Phone": phoneNo,
    };
  }



}
