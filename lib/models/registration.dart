import 'dart:io';

class Registration {
  String name;
  String email;
  String password;
  List<String> selectedGenres;
  String selectedLang;
  File profileImage;

  Registration(
      {this.name = "",
      this.email = "",
      this.password = "",
      this.selectedGenres = const [],
      this.selectedLang = "",
      this.profileImage});
}