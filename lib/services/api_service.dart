import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/message_model.dart';

class ApiService {
  // روت دقیق وب‌سرویس شما
  static const String _baseUrl = "https://amsiber.ir/api/";

  Future<Message> sendMessage({
    required String message,
    required String sessionId,
    required List<Message> conversation,
  }) async {
    try {
      final uri = Uri.parse(_baseUrl);

      debugPrint("Sending to: $uri");
      debugPrint("Payload: ${jsonEncode({"message": message, "session_id": sessionId})}");

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "message": message,
          "session_id": sessionId,
        }),
      ).timeout(const Duration(seconds: 45)); // افزایش تایم‌اوت به ۴۵ ثانیه برای پردازش‌های سنگین هوش مصنوعی

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("========= RAW SERVER RESPONSE =========");
      debugPrint(response.body);
      debugPrint("=======================================");

      if (response.statusCode == 200) {
        // ۱. ابتدا بایت‌ها را به صورت UTF-8 دیکود می‌کنیم
        final String decodedBody = utf8.decode(response.bodyBytes);

        // ۲. صحت داشتن فرمت جی‌سون را بررسی می‌کنیم
        try {
          final Map<String, dynamic> testJson = jsonDecode(decodedBody);

          // ۳. اگر جی‌سون ارسالی از پایتون حاوی ارور سیستمی بود (بلاک خطای سراسری فلاسک)
          if (testJson['status'] == 'error') {
            return Message(
              text: "⚠️ خطای سیستم:\n${testJson['message'] ?? 'خطای ناشناخته در بک‌بند'}",
              isFromUser: false,
            );
          }

          // ۴. حالت استاندارد: کل جی‌سونِ ساختاریافته را به صورت رشته (String) به فیلد text پاس می‌دهیم
          // تا AdvancedChatBubble در متد _parseMessageContent آن را باز کند.
          return Message(
            text: decodedBody,
            isFromUser: false,
          );

        } catch (jsonError) {
          // اگر خروجی سرور اصلاً جی‌سون نبود و متن ساده بود (مواقعی که سرور کرش می‌کند یا خطا می‌دهد)
          return Message(
            text: decodedBody,
            isFromUser: false,
          );
        }
      } else {
        String errorDetail = "";
        try {
          final errorData = jsonDecode(utf8.decode(response.bodyBytes));
          errorDetail = errorData['message'] ?? errorData['error'] ?? response.body;
        } catch (_) {
          errorDetail = response.body;
        }

        debugPrint("Response Error Body: $errorDetail");

        return Message(
          text: "⚠️ خطای سرور (${response.statusCode}):\n$errorDetail",
          isFromUser: false,
        );
      }
    } catch (e) {
      debugPrint("Exception caught in ApiService: $e");
      return Message(
        text: "⚠️ خطا در ارتباط: ${e.toString().split('\n').first}",
        isFromUser: false,
      );
    }
  }
}