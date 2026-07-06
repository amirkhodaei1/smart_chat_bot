import 'package:flutter/material.dart';
// حتماً آدرس دقیق ایمپورت مدل و کنترلر پروژه خودت را چک کن:
import 'package:smart_chat_bot/models/message_model.dart';
import 'package:smart_chat_bot/viewmodels/chat_viewmodel.dart';

class AdvancedChatBubble extends StatelessWidget {
  final Message message; // استفاده از مدل اصلاح شده شما
  final ChatViewModel controller;

  const AdvancedChatBubble({
    super.key,
    required this.message,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // ۱. رفع ارور لایف‌سایکل خط ۱۷: تبدیل role به فیلد واقعی مدل شما
    bool isUser = message.isFromUser;

    // ۲. رندر پیام کاربر
    if (isUser) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withValues(alpha: 0.15),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Text(
            message.text, // 💡 رفع ارور خط ۳۵: تبدیل rawText به text
            style: const TextStyle(fontFamily: 'Vazir', fontSize: 15, color: Colors.black87),
          ),
        ),
      );
    }

    // ۳. رفع ارور خط ۴۲: بررسی فالبک با چک کردن مستقیم فیلد title به جای uiData
    if (message.title == null) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
          child: Text(
            message.text, // 💡 رفع ارور خط ۴۶: تبدیل rawText به text
            style: const TextStyle(fontFamily: 'Vazir', fontSize: 14.5, color: Colors.black87),
            textDirection: TextDirection.rtl,
          ),
        ),
      );
    }

    // ۴. ساختار یو‌آی کارتونی و پیشرفته برای هوش مصنوعی (JSON پیشرفته)
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // هدر کارت (تیتر جذاب + ایموجی)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade50, Colors.indigo.shade50],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(19),
                  topRight: Radius.circular(19),
                ),
              ),
              child: Row(
                children: [
                  Text(message.emoji ?? '🤖', style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message.title!,
                      style: TextStyle(
                        fontFamily: 'Vazir',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.indigo.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // بدنه اصلی متن
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                message.text,
                style: const TextStyle(fontFamily: 'Vazir', fontSize: 14.5, height: 1.5, color: Colors.black87),
                textDirection: TextDirection.rtl,
              ),
            ),

            // نکات کلیدی (Bullet Points)
            if (message.bulletPoints != null && message.bulletPoints!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, bottom: 10),
                child: Column(
                  children: message.bulletPoints!.map((point) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: TextDirection.rtl,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6, left: 8),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
                          ),
                          Expanded(
                            child: Text(
                              point,
                              style: TextStyle(fontFamily: 'Vazir', fontSize: 13, color: Colors.grey.shade800),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

            // بخش سوالات پیشنهادی (Suggestions)
            if (message.suggestions != null && message.suggestions!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(19),
                    bottomRight: Radius.circular(19),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "پیشنهاد گفتگو:",
                      style: TextStyle(fontFamily: 'Vazir', fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      alignment: WrapAlignment.end,
                      children: message.suggestions!.map((suggestion) {
                        return ActionChip(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.indigo.shade100),
                          label: Text(
                            suggestion,
                            style: TextStyle(fontFamily: 'Vazir', fontSize: 12, color: Colors.indigo.shade700),
                          ),
                          onPressed: () => controller.selectSuggestion(suggestion),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}