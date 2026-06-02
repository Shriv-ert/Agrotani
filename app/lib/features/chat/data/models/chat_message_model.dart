// lib/features/chat/data/models/chat_message_model.dart

class ChatMessageModel {
  final String id;
  final String sessionId;
  final String role; // 'user' | 'bot'
  final String content;
  final String? imageUrl;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.id,
    required this.sessionId,
    required this.role,
    required this.content,
    this.imageUrl,
    required this.createdAt,
  });

  bool get isUser => role == 'user';
  bool get isBot => role == 'bot';

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String? ?? '',
      sessionId: json['sessionId'] as String? ?? '',
      role: json['role'] as String? ?? 'bot',
      content: json['content'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sessionId': sessionId,
    'role': role,
    'content': content,
    'imageUrl': imageUrl,
    'createdAt': createdAt.toIso8601String(),
  };

  // Factory for creating a user message locally (before sending)
  factory ChatMessageModel.userMessage({
    required String sessionId,
    required String content,
    String? imageUrl,
  }) {
    return ChatMessageModel(
      id: 'local-${DateTime.now().millisecondsSinceEpoch}',
      sessionId: sessionId,
      role: 'user',
      content: content,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );
  }

  // Factory for creating a bot message locally
  factory ChatMessageModel.botMessage({
    required String sessionId,
    required String content,
  }) {
    return ChatMessageModel(
      id: 'bot-${DateTime.now().millisecondsSinceEpoch}',
      sessionId: sessionId,
      role: 'bot',
      content: content,
      createdAt: DateTime.now(),
    );
  }
}

class ChatSessionModel {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ChatMessageModel? lastMessage;

  const ChatSessionModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    return ChatSessionModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Chat Baru',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
      lastMessage: json['lastMessage'] != null
          ? ChatMessageModel.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
    );
  }

  static final mockSession = ChatSessionModel(
    id: 'session-001',
    title: 'FarmerBot',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}
