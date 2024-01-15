class MessageModel {
  final String text;
  final String userId;
  final int createdAt;
  final String textId;
  final bool isDeleted;

  MessageModel({
    required this.text,
    required this.userId,
    required this.createdAt,
    required this.textId,
    required this.isDeleted,
  });

  MessageModel.empty()
      : text = "",
        userId = "Anonymous",
        createdAt = DateTime.now().millisecondsSinceEpoch,
        textId = "",
        isDeleted = false;

  MessageModel.fromJson(Map<String, dynamic> json)
      : text = json["text"],
        userId = json["userId"],
        createdAt = json["createdAt"],
        textId = json["textId"],
        isDeleted = json["isDeleted"];

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "userId": userId,
      "createdAt": createdAt,
      "textId": textId,
      "isDeleted": isDeleted,
    };
  }
}
