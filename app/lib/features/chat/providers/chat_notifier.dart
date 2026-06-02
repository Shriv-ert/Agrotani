// lib/features/chat/providers/chat_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/chat_message_model.dart';
import '../data/repositories/chat_repository.dart';
import '../../scan/data/scan_result_model.dart';

// ── CHAT STATE ─────────────────────────────────────────────────────────
class ChatState {
  final List<ChatMessageModel> messages;
  final bool isSending;
  final String? sessionId;
  final String? errorMessage;

  const ChatState({
    this.messages = const [],
    this.isSending = false,
    this.sessionId,
    this.errorMessage,
  });

  ChatState copyWith({
    List<ChatMessageModel>? messages,
    bool? isSending,
    String? sessionId,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      sessionId: sessionId ?? this.sessionId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ── CHAT NOTIFIER ──────────────────────────────────────────────────────
class ChatNotifier extends AsyncNotifier<ChatState> {
  @override
  Future<ChatState> build() async {
    // Mulai dengan state kosong — session dibuat oleh API saat pesan pertama dikirim
    return const ChatState();
  }

  Future<void> sendMessage(String content, {String? imageUrl}) async {
    final currentState = state.value;
    if (currentState == null) return;

    // 1. Optimistic update — tambahkan pesan user ke UI langsung
    final tempSessionId = currentState.sessionId ?? '';
    final userMsg = ChatMessageModel.userMessage(
      sessionId: tempSessionId,
      content: content,
      imageUrl: imageUrl,
    );

    state = AsyncValue.data(
      currentState.copyWith(
        messages: [...currentState.messages, userMsg],
        isSending: true,
        clearError: true,
      ),
    );

    try {
      // 2. Kirim ke API — sessionId null = buat sesi baru otomatis di backend
      final response = await ref.read(chatRepositoryProvider).sendMessage(
        message: content,
        sessionId: currentState.sessionId,
        imageUrl: imageUrl,
      );

      // 3. Buat bot message dari response API
      // ApiChatRepository.sendMessage mengembalikan ChatMessageModel dari response
      // response.data = { sessionId: '...', reply: '...' }
      final updatedState = state.value;
      if (updatedState != null) {
        state = AsyncValue.data(
          updatedState.copyWith(
            messages: [...updatedState.messages, response],
            isSending: false,
            // Simpan sessionId dari response jika belum ada (sesi baru)
            sessionId: updatedState.sessionId ?? response.sessionId,
          ),
        );
      }
    } catch (e) {
      final updatedState = state.value;
      if (updatedState != null) {
        state = AsyncValue.data(
          updatedState.copyWith(
            isSending: false,
            errorMessage: 'Gagal mengirim pesan. Coba lagi.',
          ),
        );
      }
    }
  }

  // Reset chat — mulai sesi baru
  Future<void> newSession() async {
    state = const AsyncValue.data(ChatState());
  }

  void clearError() {
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncValue.data(currentState.copyWith(clearError: true));
    }
  }

  Future<void> setScanContext(ScanResultModel scan) async {
    final currentState = await future;

    final alreadyInjected = currentState.messages.any(
      (m) => m.content.contains('[Context: ${scan.id}]')
    );
    if (alreadyInjected) return;

    final prompt = 'Halo FarmerBot, saya baru saja melakukan scan tanaman.\n'
        'Diagnosis: ${scan.diagnosis}\n'
        'Keparahan: ${scan.severity}\n\n'
        'Bisakah Anda memberikan panduan lebih lanjut untuk mengatasi masalah ini?\n'
        '[Context: ${scan.id}]';

    await sendMessage(prompt, imageUrl: scan.imageUrl);
  }
}

final chatNotifierProvider =
    AsyncNotifierProvider<ChatNotifier, ChatState>(() {
  return ChatNotifier();
});
