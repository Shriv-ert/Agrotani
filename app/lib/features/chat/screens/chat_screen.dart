// lib/features/chat/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../data/models/chat_message_model.dart';
import '../providers/chat_notifier.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _textCtrl = TextEditingController();
  final _scrollController = ScrollController();
  bool _showQuickReplies = true;

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (animated) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    final content = text.trim();
    if (content.isEmpty) return;

    _textCtrl.clear();
    setState(() => _showQuickReplies = false);

    await ref.read(chatNotifierProvider.notifier).sendMessage(content);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FarmerBot', style: AppTextStyles.titleLarge),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Online',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Messages ──────────────────────────────────────────────────
          Expanded(
            child: chatAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
                    const SizedBox(height: 12),
                    Text('Gagal memuat chat', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(chatNotifierProvider),
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
              data: (chatState) {
                // Scroll to bottom when new messages arrive
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(animated: false));

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.screenPadding,
                    vertical: 12,
                  ),
                  itemCount: chatState.messages.length +
                      (chatState.isSending ? 1 : 0),
                  itemBuilder: (_, index) {
                    if (index == chatState.messages.length && chatState.isSending) {
                      return _TypingIndicator();
                    }
                    final msg = chatState.messages[index];
                    return _ChatBubble(message: msg);
                  },
                );
              },
            ),
          ),

          // ── Quick Replies ──────────────────────────────────────────────
          if (_showQuickReplies)
            _QuickRepliesBar(
              onTap: (reply) => _sendMessage(reply),
            ),

          // ── Input Bar ─────────────────────────────────────────────────
          _ChatInputBar(
            controller: _textCtrl,
            onSend: _sendMessage,
            isSending: chatAsync.value?.isSending ?? false,
          ),
        ],
      ),
    );
  }
}

// ── Chat Bubble ──────────────────────────────────────────────────────────
class _ChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: message.content));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pesan disalin'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.78,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isUser ? AppColors.chatUserBubble : AppColors.chatBotBubble,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isUser ? 18 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _buildMessageContent(isUser),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_rounded, size: 18, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent(bool isUser) {
    final content = message.content;
    // Simple bold parsing (** text **)
    final spans = _parseBoldText(content, isUser);
    return RichText(
      text: TextSpan(
        children: spans,
        style: AppTextStyles.chatMessage.copyWith(
          color: isUser ? AppColors.chatUserText : AppColors.chatBotText,
        ),
      ),
    );
  }

  List<InlineSpan> _parseBoldText(String text, bool isUser) {
    final spans = <InlineSpan>[];
    final parts = text.split('**');
    for (var i = 0; i < parts.length; i++) {
      if (i % 2 == 0) {
        spans.add(TextSpan(text: parts[i]));
      } else {
        spans.add(TextSpan(
          text: parts[i],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
      }
    }
    return spans;
  }
}

// ── Typing Indicator ─────────────────────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.chatBotBubble,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final delay = i * 0.33;
                    final val = ((_controller.value - delay) % 1.0).clamp(0.0, 1.0);
                    final y = -4 * (1 - (2 * (val - 0.5)).abs()).clamp(0.0, 1.0);
                    return Transform.translate(
                      offset: Offset(0, y),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quick Replies Bar ────────────────────────────────────────────────────
class _QuickRepliesBar extends StatelessWidget {
  final void Function(String) onTap;
  const _QuickRepliesBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.quickReplies.length,
        itemBuilder: (_, index) {
          final reply = AppConstants.quickReplies[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onTap(reply),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.3)),
                ),
                child: Text(
                  reply,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Chat Input Bar ───────────────────────────────────────────────────────
class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSend;
  final bool isSending;

  const _ChatInputBar({
    required this.controller,
    required this.onSend,
    required this.isSending,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              enabled: !isSending,
              decoration: InputDecoration(
                hintText: 'Tanya tentang pertanian...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textDisabled,
                ),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                    color: AppColors.primaryLight,
                    width: 1.5,
                  ),
                ),
              ),
              onSubmitted: isSending ? null : onSend,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: isSending
                ? null
                : () => onSend(controller.text),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: isSending ? null : AppColors.primaryGradient,
                color: isSending ? AppColors.surfaceVariant : null,
                shape: BoxShape.circle,
              ),
              child: isSending
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryLight,
                      ),
                    )
                  : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
