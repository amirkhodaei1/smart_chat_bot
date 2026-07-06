import 'package:flutter/material.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF0FDFA), Color(0xFFCCFBF1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F766E).withValues(alpha: 0.08),
                      blurRadius: 30,
                    )
                  ],
                ),
                child: const Icon(Icons.auto_awesome_rounded, size: 64, color: Color(0xFF0F766E)),
              ),
              const SizedBox(height: 32),
              const Text(
                  'سلام، من دستیار حکیم هستم! 👋',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF0F766E))
              ),
              const SizedBox(height: 14),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                    'با تکیه بر مبانی قرآن و معارف رسمی، در بستری ساده و روان پاسخگوی شما هستم. گفتگو را آغاز فرمایید.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.5, color: Color(0xFF64748B), height: 1.7, fontWeight: FontWeight.w500)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}