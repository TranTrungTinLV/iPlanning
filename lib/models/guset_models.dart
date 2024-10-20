// Dành cho người dùng không dùng app
class GuestModel {
  String email;
  String name;
  bool gender;
  String note;
  bool invited;
  GuestModel(this.email, this.name, this.gender, this.note, this.invited);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'gender': gender,
      'note': note,
    };
  }
}
