class JournalModel {
  final int? id;
  final String? name;
  final String? createdAt;

  JournalModel({this.id, this.name, this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt,
    };
  }

  static JournalModel fromMap(Map<String, dynamic> map) {
    return JournalModel(
      id: map['id'],
      name: map['name'],
      createdAt: map['createdAt'],
    );
  }
}
