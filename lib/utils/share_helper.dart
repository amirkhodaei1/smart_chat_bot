import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  static final ScreenshotController _screenshotController = ScreenshotController();

  // رنگ پیش‌فرض در صورتی که کاربر رنگی انتخاب نکرده باشد
  static const Color _defaultGold = Color(0xFFD4AF37);
  static const Color _darkBgTop = Color(0xFF04090B);
  static const Color _darkBgBottom = Color(0xFF0A1418);

  /// پارامتر [customThemeColor] برای دریافت رنگ دلخواه کاربر اضافه شد
  static Future<void> createAndShareCard(
      BuildContext context,
      dynamic content,
      {Color? customThemeColor}
      ) async {

    // 🎨 استخراج رنگ: اولویت با رنگ ارسالی کاربر، سپس رنگ دریافتی از بک‌اند، و در نهایت رنگ پیش‌فرض
    Color activeColor = _defaultGold;

    if (customThemeColor != null) {
      activeColor = customThemeColor;
    } else {
      final String? hexColor = _extractField(content, 'theme_color') ?? _extractField(content, 'color');
      if (hexColor != null && hexColor.isNotEmpty) {
        try {
          activeColor = Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
        } catch (_) {}
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: activeColor.withValues(alpha: 0.3)),
          ),
          child: CircularProgressIndicator(color: activeColor, strokeWidth: 3),
        ),
      ),
    );

    try {
      const double targetWidth = 540.0;

      final imageBytes = await _screenshotController
          .captureFromWidget(
        Material(
          color: Colors.transparent,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: _buildDynamicCard(content, targetWidth, activeColor),
          ),
        ),
        pixelRatio: 3.5,
      )
          .timeout(const Duration(seconds: 15));

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (imageBytes == null) throw Exception("Empty image bytes generated.");

      final xFile = XFile.fromData(
        imageBytes,
        mimeType: 'image/png',
        name: 'hakim_story_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await Share.shareXFiles(
        [xFile],
        text: '📖 تبیین چندبعدی آیات در دستیار هوشمند حکیم',
        subject: _extractField(content, 'title') ?? "حکیم",
      );

    } catch (e) {
      if (context.mounted) {
        final nav = Navigator.of(context, rootNavigator: true);
        if (nav.canPop()) nav.pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'خطا در ساخت تصویر استوری: ${e.toString().split('\n').first}',
                    style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 13),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade800,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
      debugPrint("❌ ShareHelper Error: $e");
    }
  }

  // =========================================================================
  // Core UI Builder (با پشتیبانی از رنگ شخصی‌سازی شده)
  // =========================================================================

  static Widget _buildDynamicCard(dynamic content, double width, Color themeColor) {
    final String title = _extractField(content, 'title') ?? "تبیین آیات الهی";
    final String emoji = _extractField(content, 'emoji') ?? "✨";
    final String? arabicText = _extractField(content, 'arabicText') ?? _extractField(content, 'arabic_text');
    final String? introShare = _extractField(content, 'introduction_share') ?? _extractField(content, 'introduction');
    final String? analysisShare = _extractField(content, 'analysis_share') ?? _extractField(content, 'analysis');
    final String? strategyShare = _extractField(content, 'strategy_share') ?? _extractField(content, 'strategy');

    return Container(
      width: width,
      height: 960.0, // ارتفاع استاندارد استوری
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_darkBgTop, _darkBgBottom],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: themeColor.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 44, left: 36, right: 36, bottom: 20),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown, // جلوگیری از اورفلو و تنظیم خودکار سایز
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: width - 72),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(title, emoji, themeColor), // 🎨 رنگ کاربر اعمال شد
                        const SizedBox(height: 36),

                        if (arabicText != null && arabicText.trim().isNotEmpty) ...[
                          _buildArabicCalligraphyBox(arabicText.trim()),
                          const SizedBox(height: 36),
                        ],

                        if (introShare != null && introShare.trim().isNotEmpty)
                          _buildStorySection("✦ تبیین ملکوتی", introShare, const Color(0xFF38BDF8)),

                        if (analysisShare != null && analysisShare.trim().isNotEmpty)
                          _buildStorySection("🔍 تفسیر و تدبر چندبعدی", analysisShare, const Color(0xFF34D399)),

                        // 🎨 رنگ بخش سوم (راهبرد) حالا هم‌رنگ انتخاب کاربر است
                        if (strategyShare != null && strategyShare.trim().isNotEmpty)
                          _buildStorySection("⭐ راهبرد عملیاتی", strategyShare, themeColor),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          _buildFooter(),
        ],
      ),
    );
  }

  // =========================================================================
  // UI Components
  // =========================================================================

  static Widget _buildHeader(String title, String emoji, Color themeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: themeColor.withValues(alpha: 0.3)),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Vazirmatn',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            border: Border.all(color: themeColor.withValues(alpha: 0.5), width: 1.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "حکیم 🌟",
            style: TextStyle(
              color: themeColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazirmatn',
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildArabicCalligraphyBox(String arabicText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
      ),
      child: Text(
        arabicText,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          height: 1.8,
          fontWeight: FontWeight.w700,
          fontFamily: 'Vazirmatn',
        ),
      ),
    );
  }

  static Widget _buildStorySection(String title, String body, Color accentColor) {
    final cleanBody = body.replaceAll('**', '').trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      padding: const EdgeInsets.only(right: 18, left: 8),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: accentColor, width: 3.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              color: accentColor,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              fontFamily: 'Vazirmatn',
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cleanBody,
            style: TextStyle(
              color: const Color(0xFFE2E8F0).withValues(alpha: 0.95),
              fontSize: 10.5,
              height: 1.8,
              fontFamily: 'Vazirmatn',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildFooter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(color: Colors.white12, height: 1, thickness: 1),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, color: Colors.white.withValues(alpha: 0.3), size: 14),
              const SizedBox(width: 8),
              Text(
                "تبیین چندبعدی آیات | هوش مصنوعی قرآنی حکیم",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.35),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  fontFamily: 'Vazirmatn',
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.auto_awesome, color: Colors.white.withValues(alpha: 0.3), size: 14),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // Robust Data Extraction
  // =========================================================================

  static String? _extractField(dynamic content, String key) {
    if (content == null) return null;

    Map<String, dynamic>? dataMap;

    if (content is Map) {
      dataMap = content.map((k, v) => MapEntry(k.toString(), v));
    } else if (content is String) {
      try {
        final decoded = jsonDecode(content);
        if (decoded is Map) dataMap = decoded.map((k, v) => MapEntry(k.toString(), v));
      } catch (_) {}
    } else {
      try {
        final Map<dynamic, dynamic> rawMap = content.toJson();
        dataMap = rawMap.map((k, v) => MapEntry(k.toString(), v));
      } catch (_) {}
    }

    if (dataMap != null && dataMap.containsKey('data') && dataMap['data'] is Map) {
      final Map<dynamic, dynamic> innerRaw = dataMap['data'];
      dataMap = innerRaw.map((k, v) => MapEntry(k.toString(), v));
    }

    if (dataMap == null) {
      try {
        if (key == 'title') return content.title?.toString();
        if (key == 'emoji') return content.emoji?.toString();
        if (key == 'arabicText' || key == 'arabic_text') return content.arabicText?.toString();
        if (key == 'introduction' || key == 'introduction_share') return content.introduction?.toString();
        if (key == 'analysis' || key == 'analysis_share') return content.analysis?.toString();
        if (key == 'strategy' || key == 'strategy_share') return content.strategy?.toString();
      } catch (_) {}
      return null;
    }

    if (dataMap[key] != null) return dataMap[key].toString();

    final parts = key.split('_');
    final camelKey = parts.length == 1
        ? key
        : parts[0] + parts.sublist(1).map((e) => e[0].toUpperCase() + e.substring(1)).join();
    if (dataMap[camelKey] != null) return dataMap[camelKey].toString();

    final cleanKey = key.replaceAll('_share', '');
    if (dataMap[cleanKey] != null) return dataMap[cleanKey].toString();

    return null;
  }
}