class User {
  String? uuid;
  String? email;
  String? username;
  String? createdAt;

  User({required this.uuid, required this.email, required this.username, required this.createdAt});

  User.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    email = json['email'];
    username = json['username'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['email'] = email;
    data['username'] = username;
    data['createdAt'] = createdAt;
    return data;
  }
}
