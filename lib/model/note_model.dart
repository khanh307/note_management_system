
class Note {
  int? id;
  String? name;
  int? categoryId;
  int? statusId;
  int? priorityId;
  int? userId;
  String? planDate;
  String? createdAt;

  Note({this.id, this.name, this.userId, this.categoryId, this.statusId, this.priorityId,
      this.planDate, this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'categoryId': categoryId,
      'statusId': statusId,
      'priorityId': priorityId,
      'planDate': planDate,
    };
  }
}