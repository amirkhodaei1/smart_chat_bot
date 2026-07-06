import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_chat_bot/models/chat_session.dart';
import 'package:smart_chat_bot/viewmodels/chat_viewmodel.dart';

class ChatDrawer extends StatelessWidget {
  final ChatViewModel viewModel;

  const ChatDrawer({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(28), bottomLeft: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 64, bottom: 28, left: 20, right: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
              ),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 24,
                  child: Icon(Icons.blur_on_rounded, color: Color(0xFF0F766E), size: 28),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("تاریخچه گفتگوها", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                    Text("مدیریت جلسات چت", style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                viewModel.startNewChat();
                Get.back();
              },
              icon: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
              label: const Text("شروع گفتگوی جدید", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
                elevation: 0,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: viewModel.sessions.length,
              itemBuilder: (context, index) {
                final session = viewModel.sessions[index];
                final isSelected = viewModel.currentSession.value?.id == session.id;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  child: ListTile(
                    selected: isSelected,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    selectedTileColor: const Color(0xFFF0FDFA),
                    leading: Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: isSelected ? const Color(0xFF0F766E) : const Color(0xFF64748B),
                      size: 20,
                    ),
                    title: Text(
                      session.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                        color: isSelected ? const Color(0xFF0F766E) : const Color(0xFF334155),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFF94A3B8), size: 20),
                      onPressed: () => _showDeleteConfirmation(context, session),
                    ),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      viewModel.changeSession(session);
                      Get.back();
                    },
                  ),
                );
              },
            )),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ChatSession session) {
    Get.defaultDialog(
      title: "حذف گفتگو",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      middleText: "آیا از حذف «${session.title}» مطمئن هستید؟",
      middleTextStyle: const TextStyle(fontSize: 14),
      textCancel: "انصراف",
      textConfirm: "حذف",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFE11D48),
      radius: 16,
      onConfirm: () {
        HapticFeedback.heavyImpact();
        viewModel.deleteSession(session);
        Get.back();
      },
    );
  }
}