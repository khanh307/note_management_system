class StatusModel {
  final int? id;
  final String? name;
  final String? createdAt;

  StatusModel({this.id, this.name, this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt,
    };
  }

  static StatusModel fromMap(Map<String, dynamic> map) {
    return StatusModel(
      id: map['id'],
      name: map['name'],
      createdAt: map['createdAt'],
    );
  }
}
