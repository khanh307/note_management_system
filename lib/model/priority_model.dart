class PriorityModel {
  final int? id;
  final String? name;
  final String? createdAt;

  PriorityModel({this.id, this.name, this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt,
    };
  }

  static PriorityModel fromMap(Map<String, dynamic> map) {
    return PriorityModel(
      id: map['id'],
      name: map['name'],
      createdAt: map['createdAt'],
    );
  }
}
