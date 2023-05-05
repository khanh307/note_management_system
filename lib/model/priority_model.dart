
class Priority {
  final int? id;
  final String? name;
  final String? createdAt;
  final int? userId;

  Priority({this.id, this.name, this.createdAt, this.userId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userid': userId,
    };
  }

  static Priority fromMap(Map<String, dynamic> map) {
    return Priority(
      id: map['id'],
      name: map['name'],
      createdAt: map['createdAt'],
    );
  }
}