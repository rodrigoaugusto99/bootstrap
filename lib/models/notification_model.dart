class NotificationModel {
  final String id;
  String body;
  final Map<String, dynamic>? data;
  String title;
  final DateTime createdAt;
  final String? topic;
  final String? userId;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.body,
    required this.data,
    required this.title,
    required this.createdAt,
    required this.topic,
    required this.userId,
    this.isRead = false,
  });

  factory NotificationModel.fromDocument(String id, Map<String, dynamic> data) {
    return NotificationModel(
      id: id,
      body: data['body'],
      data: data['data'],
      title: data['title'],
      createdAt: data['createdAt'].toDate(),
      topic: data['topic'],
      userId: data['userId'],
    );
  }
}
