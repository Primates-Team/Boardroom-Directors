class UserModel {
  final String firstName;
  final String lastName;
  final String gender;
  final DateTime? dob;
  final String designation;
  final String mobile;
  final String email;
  final String? password;
  final String profileUrl;

  UserModel(
      {required this.firstName,
      required this.lastName,
      required this.gender,
      this.dob,
      required this.designation,
      required this.mobile,
      required this.email,
      this.password,
      required this.profileUrl});
}
