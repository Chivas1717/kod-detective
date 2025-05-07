class Test {
  int? id;
  String? title;
  String? difficulty;
  int? language;
  String? languageName;
  String? languageCode;

  Test({
    this.id,
    this.title,
    this.difficulty,
    this.language,
    this.languageName,
    this.languageCode,
  });

  Test copyWith({
    int? id,
    String? title,
    String? difficulty,
    int? language,
    String? languageName,
    String? languageCode,
  }) {
    return Test(
      id: id ?? this.id,
      title: title ?? this.title,
      difficulty: difficulty ?? this.difficulty,
      language: language ?? this.language,
      languageName: languageName ?? this.languageName,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}
