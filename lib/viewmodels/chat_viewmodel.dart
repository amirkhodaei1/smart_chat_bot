import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:smart_chat_bot/models/chat_session.dart';
import 'package:smart_chat_bot/models/message_model.dart';
import 'package:smart_chat_bot/services/api_service.dart';

class ChatViewModel extends GetxController {
  // ==================== 1. Core State & UI Controllers ====================
  final sessions = <ChatSession>[].obs;
  final currentSession = Rxn<ChatSession>();
  final isLoading = false.obs;
  final canSend = false.obs;

  late final TextEditingController textController;
  late final ScrollController scrollController;

  final ApiService _apiService = ApiService();
  final GetStorage _storage = GetStorage();
  final String _storageKey = 'chat_sessions';

  // ==================== 2. Premium Audio Engine States ====================
  final AudioPlayer audioPlayer = AudioPlayer();
  final RxString playingMessageId = ''.obs;
  final RxBool isAudioLoading = false.obs;

  // مدیریت امن اشتراک استریم‌ها برای جلوگیری قطعی از Memory Leak
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<PlaybackEvent>? _playbackEventSubscription;

  @override
  void onInit() {
    super.onInit();
    textController = TextEditingController();
    scrollController = ScrollController();

    _loadSessions();
    if (sessions.isEmpty) {
      startNewChat();
    }

    textController.addListener(_updateSendButtonState);
    _initAudioPlayerListeners();
  }

  void _updateSendButtonState() {
    canSend.value = textController.text.trim().isNotEmpty;
  }

  // ==================== 3. Audio Engine Core Logic ====================
  void _initAudioPlayerListeners() {
    // شنونده وضعیت پخش صوتی (پایان خودکار فایل)
    _playerStateSubscription = audioPlayer.playerStateStream.listen(
          (state) {
        if (state.processingState == ProcessingState.completed) {
          _resetAudioState();
        }
      },
      onError: (error) {
        debugPrint("🎧 Audio Player State Stream Error: $error");
        _resetAudioState();
      },
    );

    // شنونده رویدادهای سیستمی پلیر جهت مانیتورینگ بافرینگ شبکه
    _playbackEventSubscription = audioPlayer.playbackEventStream.listen(
          (event) {},
      onError: (error) {
        debugPrint("🎧 Audio Player Playback Event Error: $error");
        _resetAudioState();
      },
    );
  }

  Future<void> playAyahAudio(String messageId, String? customUrl, String arabicText) async {
    // مکانیزم گارد امنیتی: اگر فایلی در حال بافر اولیه است، درخواست جدید را نادیده بگیر
    if (isAudioLoading.value) return;

    // اگر روی همان صوت در حال پخش کلیک شد، آن را متوقف کن
    if (playingMessageId.value == messageId) {
      await _stopAudio();
      return;
    }

    try {
      isAudioLoading.value = true;
      playingMessageId.value = messageId;

      if (audioPlayer.playing) {
        await audioPlayer.stop();
      }

      // تمیزکاری و کالیبراسیون هوشمند لینک بر اساس هاست رسمی و بدون فیلتر تنزیل
      String url = (customUrl ?? "").trim();
      if (url.isEmpty) {
        url = "https://tanzil.net/res/audio/parhizgar/001001.mp3";
      }

      // اصلاح پروتکل‌های ناقص احتمالی
      if (!url.startsWith("http")) {
        url = "https://$url";
      }

      // تزریق سربرگ‌های استاندارد مرورگر برای عبور بدون دردسر از لایه‌های فیلترینگ و تحریم
      await audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(url),
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
            'Accept': 'audio/mpeg, audio/*, */*',
            'Connection': 'keep-alive',
          },
        ),
        preload: true,
      );

      isAudioLoading.value = false;
      await audioPlayer.play();

    } catch (e) {
      debugPrint("❌ playAyahAudio Critical Engine Error: $e");
      _resetAudioState();
      _showErrorSnackbar("خطا در بارگذاری فایل صوتی. وضعیت شبکه یا فیلترشکن خود را بررسی کنید.");
    }
  }

  Future<void> _stopAudio() async {
    try {
      await audioPlayer.stop();
    } catch (e) {
      debugPrint("Audio stop minor exception: $e");
    } finally {
      _resetAudioState();
    }
  }

  void _resetAudioState() {
    playingMessageId.value = '';
    isAudioLoading.value = false;
  }

  // ==================== 4. Session & Chat Storage Management ====================
  void _loadSessions() {
    try {
      final data = _storage.read<List<dynamic>>(_storageKey);
      if (data != null) {
        sessions.value = data.map((e) => ChatSession.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Storage Read Exception: $e");
    }
  }

  void _saveSessions() {
    try {
      _storage.write(_storageKey, sessions.map((s) => s.toJson()).toList());
    } catch (e) {
      debugPrint("Storage Write Exception: $e");
    }
  }

  void startNewChat() {
    _stopAudio();

    final newSession = ChatSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: "گفتگوی جدید",
      messages: [],
    );

    sessions.insert(0, newSession);
    currentSession.value = newSession;
    _saveSessions();
    _refreshUI();
  }

  void deleteSession(ChatSession session) {
    if (currentSession.value?.id == session.id) {
      _stopAudio();
    }

    sessions.removeWhere((s) => s.id == session.id);

    if (currentSession.value?.id == session.id) {
      currentSession.value = sessions.isNotEmpty ? sessions.first : null;
      if (currentSession.value == null) {
        startNewChat();
      }
    }
    _saveSessions();
    _refreshUI();
  }

  void changeSession(ChatSession session) {
    if (currentSession.value?.id == session.id) return;

    _stopAudio();
    currentSession.value = session;
    textController.clear();
    canSend.value = false;

    _refreshUI();
    animateToBottom();
  }

  // ==================== 5. AI Interaction & Pipeline ====================
  Future<void> sendMessageToAI() async {
    final content = textController.text.trim();
    if (content.isEmpty || currentSession.value == null || isLoading.value) return;

    final activeSession = currentSession.value!;

    textController.clear();
    canSend.value = false;

    // درج آنی پیام کاربر در UI برای ایجاد حس سرعت (Responsiveness)
    activeSession.messages.add(
      Message(text: content, isFromUser: true, timestamp: DateTime.now()),
    );

    // به روزرسانی هوشمند عنوان چت بر اساس اولین پیام
    if (activeSession.title == "گفتگوی جدید" && activeSession.messages.length == 1) {
      activeSession.title = content.length > 25 ? "${content.substring(0, 25)}..." : content;
    }

    _refreshUI();
    animateToBottom();

    isLoading.value = true;

    try {
      final aiMessage = await _apiService.sendMessage(
        message: content,
        sessionId: activeSession.id,
        conversation: activeSession.messages,
      );
      activeSession.messages.add(aiMessage);
    } catch (e) {
      debugPrint("AI Communication Error: $e");
      activeSession.messages.add(
        Message(
          text: "اتصال به سرور برقرار نشد. لطفاً مجدداً تلاش فرمایید.",
          isFromUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } finally {
      isLoading.value = false;
      _saveSessions();
      _refreshUI();
      animateToBottom();
    }
  }

  void selectSuggestion(String question) {
    textController.text = question;
    sendMessageToAI();
  }

  // ==================== 6. Performance & Cleanup Utilities ====================
  void animateToBottom() {
    if (!scrollController.hasClients) return;
    // تخصیص زمان‌بندی دقیق پس از اتمام رندر فریم فلاتر جهت اسکرول بدون پرش
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  void _refreshUI() {
    sessions.refresh();
    currentSession.refresh();
  }

  void _showErrorSnackbar(String message) {
    Get.rawSnackbar(
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Vazirmatn'),
        textDirection: TextDirection.rtl,
      ),
      backgroundColor: const Color(0xFFEF4444),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void onClose() {
    // قطع قطعی و کامل استریم‌ها برای جلوگیری از بروز Memory Leak در اپلیکیشن
    _playerStateSubscription?.cancel();
    _playbackEventSubscription?.cancel();

    try {
      if (audioPlayer.playing) {
        audioPlayer.stop();
      }
      audioPlayer.dispose();
    } catch (e) {
      debugPrint("Audio Player dispose exception: $e");
    }

    textController.removeListener(_updateSendButtonState);
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}