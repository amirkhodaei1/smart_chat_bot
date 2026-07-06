import 'package:flutter/material.dart';

class AdvancedTypingIndicator extends StatefulWidget {
  const AdvancedTypingIndicator({super.key});

  @override
  State<AdvancedTypingIndicator> createState() => _AdvancedTypingIndicatorState();
}

class _AdvancedTypingIndicatorState extends State<AdvancedTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _mainController;

  // تعریف بازه‌های زمانی مجزا (Intervals) برای ایجاد حالت تعقیب و گریز (Staggered) دات‌ها
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(); // تکرار مداوم کل چرخه انیمیشن

    // تقسیم‌بندی تایم‌لاین ۱۴۰۰ میلی‌ثانیه‌ای به بازه‌های استپ‌دار با افکت برگشت کشسانی (Back Curve)
    _dotAnimations = List.generate(3, (index) {
      final double start = index * 0.16; // پله اول: 0.0، پله دوم: 0.16، پله سوم: 0.32
      final double end = start + 0.45;   // مدت زمان لرزش هر دات درون چرخه

      return CurvedAnimation(
        parent: _mainController,
        curve: Interval(
          start,
          end.clamp(0.0, 1.0),
          curve: Curves.easeInOutBack, // ایجاد حالت کشسانی و جهش ارگانیک در ابتدا و انتهای حرکت
        ),
      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // تمیزترین حالت رندر جابجایی با لایه فیزیکال دستگاه
    final ThemeData theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(6),
          ),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.025),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                final double animValue = _dotAnimations[index].value;

                // فرمول تبدیل بازه رندر به رفت و برگشت متقارن (موج عمودی دگرگون‌شونده)
                // این بخش ارزش دات را در اوج انیمیشن (0.5) به بالاترین حد می‌رساند
                final double transformationFactor = (animValue - 0.5).abs() * 2; // تبدیل به فرمت V-Shape
                final double heightOffset = (1.0 - transformationFactor).clamp(0.0, 1.0);

                return Transform.translate(
                  // دات‌ها با فیزیک اِلاستیک ۸ پیکسل به بالا پرتاب می‌شوند
                  offset: Offset(0, -heightOffset * 8),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3.5),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // گرادیان داینامیک: رنگ دات‌ها در اوج پرتاب پررنگ‌تر و در کف مات‌تر می‌شود
                      gradient: ColorGradientEnforcer.getIndicatorGradient(heightOffset),
                      boxShadow: [
                        if (heightOffset > 0.5)
                          BoxShadow(
                            color: const Color(0xFF14B8A6).withValues(alpha: 0.15 * heightOffset),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

/// لایه محاسباتی انتزاعی برای مدیریت استایل دات‌ها جهت سبک نگه‌داشتن متد متد تئوری رندر فلاتر
class ColorGradientEnforcer {
  static Gradient getIndicatorGradient(double factor) {
    // ترکیب آلفای داینامیک بین ۳۰٪ تا ۱۰۰٪ بر اساس میزان ارتفاع دات
    final Color primaryColor = const Color(0xFF14B8A6);
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        primaryColor.withValues(alpha: 0.4 + (factor * 0.6)),
        primaryColor.withValues(alpha: 0.2 + (factor * 0.8)),
      ],
    );
  }
}