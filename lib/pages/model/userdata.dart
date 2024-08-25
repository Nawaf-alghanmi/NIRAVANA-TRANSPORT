class Userdata {
  String id;
  String email;
  String name;
  String type;

  Userdata({
    required this.id,
    required this.email,
    required this.name,
    required this.type,
  });

  factory Userdata.fromJson(Map<String, dynamic> json) {
    return Userdata(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }
}