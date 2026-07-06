import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_chat_bot/viewmodels/chat_viewmodel.dart';

// ایمپورت‌های کامپوننت‌های تفکیک‌شده جدید
import 'widgets/advanced_chat_bubble.dart';
import 'widgets/chat_input_area.dart';
import 'widgets/chat_drawer.dart';
import 'widgets/chat_empty_state.dart';
import 'widgets/typing_indicator.dart';
// جایگزین تمام ایمپورت‌های مربوط به این دو فایل:
class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatViewModel viewModel = Get.put(ChatViewModel());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: AppBar(
          title: const Text(
            'دستیار هوشمند حکیم',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.white, letterSpacing: 0.5),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF0F766E),
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: IconButton(
                icon: const Icon(Icons.add_box_rounded, size: 28, color: Colors.white),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  viewModel.startNewChat();
                },
              ),
            ),
          ],
        ),
        drawer: ChatDrawer(viewModel: viewModel), // استفاده از ویجت تفکیک‌شده دراور
        body: Column(
          children: [
            // ۱. لیست نمایش پیام‌ها با مدیریت وضعیت خالی
            Expanded(
              child: Obx(() {
                final session = viewModel.currentSession.value;
                if (session == null || session.messages.isEmpty) {
                  return const ChatEmptyState(); // استفاده از ویجت مستقل وضعیت خالی
                }
                return ListView.builder(
                  controller: viewModel.scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: session.messages.length,
                  itemBuilder: (context, index) {
                    return AdvancedChatBubble(
                      message: session.messages[index],
                      controller: viewModel,
                    );
                  },
                );
              }),
            ),

            // ۲. انیمیشن سه‌نقطه زنده شناور هنگام پردازش هوش مصنوعی
            Obx(() => viewModel.isLoading.value
                ? const AdvancedTypingIndicator() // استفاده از ویجت مستقل لودینگ انیمیشنی
                : const SizedBox.shrink()),

            // ۳. باکس کپسولی و مدرن ورودی پیام
            ChatInputArea(viewModel: viewModel), // استفاده از ویجت مستقل نوار متنی
          ],
        ),
      ),
    );
  }
}