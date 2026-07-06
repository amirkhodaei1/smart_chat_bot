// lib/models/message_model.dart

class Message {
  final String text;
  final DateTime timestamp;
  final bool isFromUser;
  final String? arabicText;
  final String? reference;
  final String? title;
  final String? emoji;
  final List<String>? bulletPoints;
  final List<String>? suggestions;

  Message({
    required this.text,
    DateTime? timestamp, // اختیاری کردن برای حل خطای missing_required_argument
    required this.isFromUser,
    this.arabicText,
    this.reference, // اضافه شدن ریفرنس برای حل خطای لایه ریپازیتوری
    this.title,
    this.emoji,
    this.bulletPoints,
    this.suggestions,
  }) : timestamp = timestamp ?? DateTime.now(); // مقداردهی خودکار زمان در صورت عدم ارسال

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      isFromUser: json['isFromUser'] ?? false,
      arabicText: json['arabicText'],
      reference: json['reference'],
      title: json['title'],
      emoji: json['emoji'],
      bulletPoints: json['bulletPoints'] != null ? List<String>.from(json['bulletPoints']) : null,
      suggestions: json['suggestions'] != null ? List<String>.from(json['suggestions']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isFromUser': isFromUser,
      'arabicText': arabicText,
      'reference': reference,
      'title': title,
      'bulletPoints': bulletPoints,
      'suggestions': suggestions,
    };
  }
}