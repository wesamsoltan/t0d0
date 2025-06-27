class User {
  static const String collectionName = "User";
  String? uid;
  String? fullName;
  String? email;
  int? age;

  User({this.uid, this.age, this.email, this.fullName});

  User.fromFireStore(Map<String, dynamic>? data) {
    uid = data?["id"];
    fullName = data?["fullName"];
    email = data?["email"];
    age = data?["age"];
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": uid,
      "fullName": fullName,
      "age": age,
      "email": email
    };
  }
}
