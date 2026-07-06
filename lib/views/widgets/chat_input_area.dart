import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_chat_bot/viewmodels/chat_viewmodel.dart';

class ChatInputArea extends StatelessWidget {
  final ChatViewModel viewModel;

  const ChatInputArea({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F766E).withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: viewModel.textController,
                  maxLines: 5,
                  minLines: 1,
                  textDirection: TextDirection.rtl,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(fontSize: 15, color: Color(0xFF1E293B), fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                    hintText: 'یک کلام حکیمانه یا پرسش بفرستید...',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6, left: 8, right: 8),
                child: Obx(() {
                  final isEnabled = !viewModel.isLoading.value && viewModel.canSend.value;
                  return AnimatedScale(
                    scale: isEnabled ? 1.0 : 0.92,
                    duration: const Duration(milliseconds: 150),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: isEnabled ? const Color(0xFF0F766E) : const Color(0xFFF1F5F9),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_upward_rounded,
                          color: isEnabled ? Colors.white : const Color(0xFF94A3B8),
                          size: 20,
                        ),
                        onPressed: isEnabled
                            ? () {
                          HapticFeedback.mediumImpact();
                          viewModel.sendMessageToAI();
                        }
                            : null,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}