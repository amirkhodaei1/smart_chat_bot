import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_chat_bot/models/message_model.dart';
import 'package:smart_chat_bot/viewmodels/chat_viewmodel.dart';
import 'package:smart_chat_bot/utils/share_helper.dart'; // مطمئن شوید مسیر فولدربندی درست است
class AdvancedChatBubble extends StatelessWidget {
  final Message message;
  final ChatViewModel controller;

  const AdvancedChatBubble({
    super.key,
    required this.message,
    required this.controller,
  });

  // ==================== پارس محتوای سه‌بعدی از بک‌اَند ====================
  ({
  String? title,
  String? emoji,
  String? introduction,
  String? etymology,
  String? analysis,
  String? contemporary,
  String? strategy,
  String? arabicText,
  String? audioUrl, // اضافه شدن فیلد صوت به ساختار فرانت
  List<String> bulletPoints,
  List<String> suggestions,
  String rawFallbackText,
  }) _parseMessageContent() {
    try {
      final Map<String, dynamic> jsonData = jsonDecode(message.text);

      return (
      title: jsonData['title'] as String?,
      emoji: jsonData['emoji'] as String?,
      introduction: jsonData['introduction'] as String?,
      etymology: jsonData['etymology'] as String?,
      analysis: jsonData['analysis'] as String?,
      contemporary: jsonData['contemporary'] as String?,
      strategy: jsonData['strategy'] as String?,
      arabicText: jsonData['arabicText'] as String?,
      audioUrl: jsonData['audioUrl'] as String?, // ست شدن فیلد صوت از بک‌انَد
      bulletPoints: (jsonData['bulletPoints'] as List?)?.cast<String>() ?? [],
      suggestions: (jsonData['suggestions'] as List?)?.cast<String>() ?? [],
      rawFallbackText: "",
      );
    } catch (_) {
      // اگر متن پیام JSON نبود (مثل پیام‌های قدیمی یا پیام کاربر)، بدون خطا وارد رندر ساده می‌شود
      return (
      title: null,
      emoji: null,
      introduction: null,
      etymology: null,
      analysis: null,
      contemporary: null,
      strategy: null,
      arabicText: null,
      audioUrl: null,
      bulletPoints: [],
      suggestions: [],
      rawFallbackText: message.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.isFromUser;
    final time = "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}";

    if (isUser) {
      return _buildUserBubble(context, time);
    } else {
      final content = _parseMessageContent();
      return _buildAiBubble(context, content, time);
    }
  }

  // ==================== حباب چت کاربر ====================
  Widget _buildUserBubble(BuildContext context, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.76),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F766E), Color(0xFF115E59)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
            bottomLeft: Radius.circular(6),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F766E).withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Text(
          message.text,
          style: const TextStyle(fontSize: 14.5, color: Colors.white, fontWeight: FontWeight.w500, height: 1.55),
        ),
      ),
    );
  }

  // ==================== حباب چت هوش مصنوعی (فوق پیشرفته) ====================
  Widget _buildAiBubble(BuildContext context, dynamic content, String time) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.88, // عرض کمی بیشتر برای خوانایی
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFE2E8F0).withValues(alpha: 0.8), width: 1.2),
          boxShadow: [
            BoxShadow(color: const Color(0xFF0F766E).withValues(alpha: 0.04), blurRadius: 24, offset: const Offset(0, 8)),
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(content.title ?? 'پاسخ حکیمانه', content.emoji ?? '✨'),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            _buildBody(content),

            // 🔥 خط اصلاح شده: پاس دادن کانتکست و استفاده از متغیر صحیح time
            _buildFooter(context, time, content),

            if (content.suggestions.isNotEmpty) _buildSuggestions(content.suggestions),
          ],
        ),
      ),
    );
  }

  // ==================== هدر اصلی کارت ====================
  Widget _buildHeader(String title, String emoji) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
    decoration: const BoxDecoration(
      color: Color(0xFFF8FAFC),
      borderRadius: BorderRadius.only(topLeft: Radius.circular(26), topRight: Radius.circular(26)),
    ),
    child: Row(
      textDirection: TextDirection.rtl,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F4F1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 15)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14.5,
              color: Color(0xFF0F766E),
              letterSpacing: 0.2,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      ],
    ),
  );

  // ==================== چیدمان بدنه (بخش‌بندی بومی و نیتیو) ====================
  Widget _buildBody(dynamic content) {
    // 🛡️ اگر پاسخ به صورت متن ساده (غیر JSON) بود، فقط متن خام را رندر کن
    if (content.rawFallbackText != null && content.rawFallbackText.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(18),
        child: _buildParsedRichText(content.rawFallbackText),
      );
    }

    // رندر بخش‌های ساختاریافته در صورت parse موفق JSON
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        textDirection: TextDirection.rtl,
        children: [
          if (content.arabicText != null && content.arabicText.isNotEmpty)
            _buildArabicSection(
              content.arabicText!,
              message.timestamp.millisecondsSinceEpoch.toString(),
              content.audioUrl,
            ),

          if (content.introduction != null && content.introduction.isNotEmpty) ...[
            _buildSectionTitle("✦ جلوه اول: تبیین ملکوتی"),
            _buildParsedRichText(content.introduction),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Color(0xFFF1F5F9)),
            ),
          ],

          if (content.etymology != null && content.etymology.isNotEmpty) ...[
            _buildSectionTitle("❖ تبارشناسی و واژه‌گزینی"),
            _buildParsedRichText(content.etymology),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Color(0xFFF1F5F9)),
            ),
          ],

          if (content.analysis != null && content.analysis.isNotEmpty) ...[
            _buildSectionTitle("🔍 کالبدشکافی تفسیری"),
            _buildParsedRichText(content.analysis),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Color(0xFFF1F5F9)),
            ),
          ],

          if (content.contemporary != null && content.contemporary.isNotEmpty) ...[
            _buildSectionTitle("🌐 امتداد در زیست معاصر"),
            _buildParsedRichText(content.contemporary),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Color(0xFFF1F5F9)),
            ),
          ],

          if (content.strategy != null && content.strategy.isNotEmpty) ...[
            _buildSectionTitle("⭐ چکیده راهبرد"),
            _buildParsedRichText(content.strategy),
          ],

          if (content.bulletPoints != null && content.bulletPoints.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...content.bulletPoints.map((point) => _buildBulletPoint(point)),
          ],
        ],
      ),
    );
  }

  // ==================== مینی‌ویجت‌ها ====================
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F766E),
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  // جادوی رندر متن: تبدیل **کلمات بولد** به کلمات برجسته رنگی
  Widget _buildParsedRichText(String text) {
    final List<TextSpan> spans = [];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    int lastMatchEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: const TextStyle(fontSize: 14.5, height: 1.8, color: Color(0xFF334155), fontWeight: FontWeight.w400),
        ));
      }
      spans.add(TextSpan(
        text: match.group(1), // کلمه بولد شده
        style: const TextStyle(fontSize: 14.5, height: 1.8, color: Color(0xFF0F766E), fontWeight: FontWeight.w800),
      ));
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: const TextStyle(fontSize: 14.5, height: 1.8, color: Color(0xFF334155), fontWeight: FontWeight.w400),
      ));
    }

    return RichText(
      textDirection: TextDirection.rtl,
      text: TextSpan(children: spans),
    );
  }

  Widget _buildArabicSection(String text, String messageId, String? audioUrl) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
          colors: [Color(0xFFF0FDFA), Color(0xFFE6F4F1)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft
      ),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFCCFBF1), width: 1.2),
      boxShadow: [
        BoxShadow(color: const Color(0xFF0F766E).withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 3))
      ],
    ),
    child: Stack(
      children: [
        // متن آیه قرآن
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24), // پدینگ برای تداخل نکردن با دکمه صوت
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'UthmanTaha',
                fontSize: 30,
                fontWeight: FontWeight.normal,
                color: Color(0xFF115E59),
                height: 1.8,
                shadows: [
                  Shadow(offset: Offset(0.2, 0.2), color: Color(0xFF115E59)),
                  Shadow(offset: Offset(-0.2, -0.2), color: Color(0xFF115E59)),
                ],
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
        ),

        // دکمه پخش تلاوت صوتی در گوشه بالا سمت چپ باکس
        Positioned(
          left: 6,
          top: 6,
          child: Obx(() {
            final isCurrentPlaying = controller.playingMessageId.value == messageId;
            final isLoading = controller.isAudioLoading.value && isCurrentPlaying;
            final isPlaying = isCurrentPlaying && !isLoading;

            if (isLoading) {
              return const Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF14B8A6)),
                  ),
                ),
              );
            }

            return IconButton(
              splashRadius: 20,
              icon: Icon(
                isPlaying ? Icons.stop_circle_rounded : Icons.play_circle_fill_rounded,
                size: 26,
                color: isPlaying ? const Color(0xFFEF4444) : const Color(0xFF0F766E),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                controller.playAyahAudio(messageId, audioUrl, text);
              },
            );
          }),
        ),
      ],
    ),
  );

  Widget _buildBulletPoint(String point) => Container(
    margin: const EdgeInsets.symmetric(vertical: 4.5),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFEDF2F7), width: 1),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 7, left: 12),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(color: Color(0xFF14B8A6), shape: BoxShape.circle),
        ),
        Expanded(
          child: _buildParsedRichText(point), // بولت‌ها هم از متن غنی پشتیبانی کنند
        ),
      ],
    ),
  );

  Widget _buildFooter(BuildContext context, String time, dynamic content) => Padding(
    padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
    child: Row(
      children: [
        Text(time, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
        const Spacer(),

        // 🔥 دکمه اشتراک‌گذاری کارت گرافیکی در پس‌زمینه
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.share_rounded, size: 19, color: Color(0xFF94A3B8)),
          tooltip: 'اشتراک‌گذاری کارت تبیین آیه',
          onPressed: () {
            HapticFeedback.lightImpact();
            ShareHelper.createAndShareCard(
              context,
              content,
              customThemeColor: Colors.tealAccent, // 🎨 رنگی که کاربر انتخاب کرده
            );// پاس دادن کانتکست زنده
          },
        ),

        const SizedBox(width: 6),

        // دکمه کپی هوشمند
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.copy_all_rounded, size: 19, color: Color(0xFF94A3B8)),
          onPressed: () {
            HapticFeedback.lightImpact();

            String clipboardText = "";
            if (content.rawFallbackText.isNotEmpty) {
              clipboardText = content.rawFallbackText;
            } else {
              if (content.arabicText != null) clipboardText += "${content.arabicText}\n\n";
              if (content.introduction != null) clipboardText += "✦ تبیین ملکوتی:\n${content.introduction}\n\n";
              if (content.etymology != null) clipboardText += "❖ ریشه‌شناسی:\n${content.etymology}\n\n";
              if (content.analysis != null) clipboardText += "🔍 تفسیر:\n${content.analysis}\n\n";
              if (content.contemporary != null) clipboardText += "🌐 زیست معاصر:\n${content.contemporary}\n\n";
              if (content.strategy != null) clipboardText += "⭐ راهبرد:\n${content.strategy}\n\n";
            }

            clipboardText = clipboardText.replaceAll('**', '');

            Clipboard.setData(ClipboardData(text: clipboardText.trim()));
            Get.rawSnackbar(
              messageText: const Text("متن پاسخ به صورت یکپارچه کپی شد", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              backgroundColor: const Color(0xFF1E293B),
              snackPosition: SnackPosition.TOP,
              borderRadius: 14,
              margin: const EdgeInsets.all(16),
            );
          },
        ),
      ],
    ),
  );

  Widget _buildSuggestions(List<String> suggestions) => Container(
    padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
    decoration: const BoxDecoration(
      color: Color(0xFFF8FAFC),
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(26), bottomRight: Radius.circular(26)),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: suggestions.map((suggestion) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.5),
            child: ActionChip(
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFFCCFBF1), width: 1.2),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              label: Text(
                suggestion,
                style: const TextStyle(fontSize: 12.5, color: Color(0xFF0F766E), fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                controller.selectSuggestion(suggestion);
              },
            ),
          );
        }).toList(),
      ),
    ),
  );
}