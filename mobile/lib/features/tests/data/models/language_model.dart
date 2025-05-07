import 'package:clean_architecture_template/features/tests/domain/entities/language.dart';

class LanguageModel extends Language {
  LanguageModel({
    required super.id,
    required super.name,
    required super.code,
    super.icon,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'icon': icon,
    };
  }

  factory LanguageModel.fromEntity(Language language) {
    return LanguageModel(
      id: language.id,
      name: language.name,
      code: language.code,
      icon: language.icon,
    );
  }
} 