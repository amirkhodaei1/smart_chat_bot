import 'package:smart_chat_bot/models/message_model.dart';

abstract class ChatRepository {
  Future<String> sendMessage({
    required String message,
    required List<Message> conversation,
    String? systemPrompt,
  });
}