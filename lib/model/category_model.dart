
class Category {
  final int? id;
  final String? name;
  final String? createdAt;
  final int? userId;

  Category({this.id, this.name, this.createdAt, this.userId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userid': userId,
    };
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      createdAt: map['createdAt'],
    );
  }
}