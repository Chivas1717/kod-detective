class Language {
  final int id;
  final String name;
  final String code;
  final String? icon;

  Language({
    required this.id,
    required this.name,
    required this.code,
    this.icon,
  });

  @override
  String toString() {
    return 'Language(id: $id, name: $name, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Language && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 