
class Status {
  final int? id;
  final String? name;
  final String? createdAt;
  final int? userId;

  Status({this.id, this.name, this.createdAt, this.userId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userid': userId,
    };
  }

  static Status fromMap(Map<String, dynamic> map) {
    return Status(
      id: map['id'],
      name: map['name'],
      createdAt: map['createdAt'],
    );
  }
}