import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    super.id,
    super.username,
    super.profilePic,
    super.status,
    super.email,
    super.token,
    super.score,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    profilePic = json['profile_pic'];
    status = json['status'];
    email = json['email'];
    token = json['token'];
    score = json['score'];
  }
}
