import 'package:clean_architecture_template/features/auth/data/models/user_model.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/test.dart';

class TestModel extends Test {
  TestModel({
    super.id,
    super.title,
    super.difficulty,
    super.language, // id
    super.languageName,
    super.languageCode,
  });

  TestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    difficulty = json['difficulty'];
    language = json['language']; // id
    languageName = json['language_name'];
    languageCode = json['language_code'];
  }
}
