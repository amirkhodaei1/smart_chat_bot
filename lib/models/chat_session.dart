// lib/models/chat_session.dart

import 'message_model.dart';

class ChatSession {
  final String id;
  String title;
  final List<Message> messages;
  final DateTime createdAt;

  ChatSession({
    required this.id,
    required this.title,
    required this.messages,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'] ?? '',
      title: json['title'] ?? 'گفتگوی جدید',
      messages: json['messages'] != null
          ? (json['messages'] as List)
          .map((m) => Message.fromJson(m as Map<String, dynamic>))
          .toList()
          : <Message>[],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'messages': messages.map((m) => m.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
  };

  // متد کمکی برای راحتی
  bool get isEmpty => messages.isEmpty;

  int get messageCount => messages.length;

  Message? get lastMessage => messages.isNotEmpty ? messages.last : null;
}