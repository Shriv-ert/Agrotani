// lib/features/chat/providers/chat_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/chat_message_model.dart';
import '../data/repositories/chat_repository.dart';

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
    // Load initial messages (or start fresh)
    const sessionId = 'session-001';
    final messages = await ref
        .read(chatRepositoryProvider)
        .getMessages(sessionId);
    return ChatState(messages: messages, sessionId: sessionId);
  }

  Future<void> sendMessage(String content, {String? imageUrl}) async {
    final currentState = state.value;
    if (currentState == null) return;

    // 1. Optimistic update — add user message immediately to UI
    final userMsg = ChatMessageModel.userMessage(
      sessionId: currentState.sessionId ?? 'session-001',
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
      // 2. Send to backend/mock and get bot response
      final botMsg = await ref.read(chatRepositoryProvider).sendMessage(
        message: content,
        sessionId: currentState.sessionId,
        imageUrl: imageUrl,
      );

      // 3. Append bot response
      final updatedState = state.value;
      if (updatedState != null) {
        state = AsyncValue.data(
          updatedState.copyWith(
            messages: [...updatedState.messages, botMsg],
            isSending: false,
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

  void clearError() {
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncValue.data(currentState.copyWith(clearError: true));
    }
  }
}

final chatNotifierProvider =
    AsyncNotifierProvider<ChatNotifier, ChatState>(() {
  return ChatNotifier();
});
