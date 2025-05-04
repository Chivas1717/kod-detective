class User {
  int? id;
  String? username;
  String? email;
  String? token;
  int? score;
  
  // Optional fields you might want to keep
  String? profilePic;
  String? status;

  User({
    this.id,
    this.username,
    this.email,
    this.token,
    this.score,
    this.profilePic,
    this.status,
  });

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? token,
    int? score,
    String? profilePic,
    String? status,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      token: token ?? this.token,
      score: score ?? this.score,
      profilePic: profilePic ?? this.profilePic,
      status: status ?? this.status,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['user_id'],
      username: json['username'],
      email: json['email'],
      token: json['token'],
      score: json['score'],
      profilePic: json['profile_pic'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'token': token,
      'score': score,
      'profile_pic': profilePic,
      'status': status,
    };
  }
}
