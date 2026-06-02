// lib/features/chat/data/repositories/chat_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
// ignore: unused_import
import '../../../../core/network/network_providers.dart'; // Used by ApiChatRepository
import '../models/chat_message_model.dart';

// ── 1. THE CONTRACT ────────────────────────────────────────────────────
abstract class ChatRepository {
  Future<ChatMessageModel> sendMessage({
    required String message,
    String? sessionId,
    String? imageUrl,
  });
  Future<List<ChatSessionModel>> getSessions();
  Future<List<ChatMessageModel>> getMessages(String sessionId);
}

// ── 2. MOCK IMPLEMENTATION ─────────────────────────────────────────────
class MockChatRepository implements ChatRepository {
  // Realistic FarmerBot mock responses
  static const List<String> _responses = [
    '''🌱 Pertanyaan yang bagus! 

Berdasarkan pengetahuan saya, berikut beberapa hal yang perlu diperhatikan:

**Penanganan yang disarankan:**
• Periksa kondisi tanah terlebih dahulu — gunakan pH meter untuk mengukur keasaman
• Pastikan sistem drainase berfungsi baik
• Berikan pupuk sesuai kebutuhan tanaman

Apakah ada gejala spesifik yang Anda amati? Saya bisa memberikan saran yang lebih tepat. 🌿''',

    '''🔍 Saya mengerti masalahnya!

Berdasarkan deskripsi Anda, kemungkinan penyebabnya adalah:

1. **Kekurangan nutrisi** — terutama nitrogen atau magnesium
2. **Serangan hama** — cek bagian bawah daun
3. **Kondisi cuaca** — perubahan suhu drastis bisa mempengaruhi

**Langkah pertama yang saya sarankan:**
Foto bagian tanaman yang bermasalah dan gunakan fitur Scan AI kami untuk diagnosis yang lebih akurat! 📷

Ada pertanyaan lain? 😊''',

    '''💡 Tips berguna untuk Anda!

Untuk tanaman yang sehat di iklim tropis Indonesia:

🌊 **Air**: Siram pagi hari (06.00-09.00) atau sore (15.00-17.00)
🌿 **Pupuk**: Berikan setiap 2 minggu di musim tanam aktif  
☀️ **Sinar**: Minimal 6 jam sinar matahari langsung per hari
🐛 **Hama**: Periksa daun bawah setiap 3 hari sekali

Semoga tanaman Anda tumbuh subur! 🌱✨

Masih ada yang ingin ditanyakan?''',

    '''🤔 Pertanyaan menarik!

Untuk masalah yang Anda hadapi, saya menyarankan:

**Solusi jangka pendek (hari ini):**
• Isolasi tanaman yang terinfeksi agar tidak menyebar
• Kurangi penyiraman jika ada tanda busuk
• Cek apakah ada hama di sekitar akar

**Solusi jangka panjang (1-2 minggu):**
• Perbaiki komposisi media tanam
• Rotasi tanaman untuk musim berikutnya
• Pertimbangkan penggunaan pupuk hayati

Kalau masalah berlanjut, sebaiknya konsultasi langsung dengan Petugas Penyuluh Lapangan (PPL) di daerah Anda! 💪''',
  ];

  int _responseIndex = 0;
  final List<ChatMessageModel> _messages = [];
  String _sessionId = 'session-001';

  @override
  Future<ChatMessageModel> sendMessage({
    required String message,
    String? sessionId,
    String? imageUrl,
  }) async {
    _sessionId = sessionId ?? _sessionId;
    await Future.delayed(const Duration(milliseconds: 1500));

    // Add user message
    final userMsg = ChatMessageModel.userMessage(
      sessionId: _sessionId,
      content: message,
      imageUrl: imageUrl,
    );
    _messages.add(userMsg);

    // Generate bot response
    final response = _responses[_responseIndex % _responses.length];
    _responseIndex++;

    final botMsg = ChatMessageModel.botMessage(
      sessionId: _sessionId,
      content: response,
    );
    _messages.add(botMsg);

    // Return the BOT response (caller already added user msg optimistically)
    return botMsg;
  }

  @override
  Future<List<ChatSessionModel>> getSessions() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [ChatSessionModel.mockSession];
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_messages.isEmpty) {
      // Seed with welcome message
      _messages.add(ChatMessageModel.botMessage(
        sessionId: _sessionId,
        content: '''👋 Halo! Saya **FarmerBot**, asisten pertanian Anda!

Saya bisa membantu Anda dengan:
🌱 Pertanyaan seputar pertanian
🐛 Identifikasi hama dan penyakit
💊 Rekomendasi pupuk dan pestisida
📅 Jadwal tanam dan panen

Silakan tanyakan apa saja! Atau gunakan tombol di bawah untuk pertanyaan umum. 😊''',
      ));
    }
    return List.from(_messages);
  }
}

// ── 3. REAL API IMPLEMENTATION ─────────────────────────────────────────
class ApiChatRepository implements ChatRepository {
  final Dio dio;

  ApiChatRepository(this.dio);

  @override
  Future<ChatMessageModel> sendMessage({
    required String message,
    String? sessionId,
    String? imageUrl,
  }) async {
    final response = await dio.post('/chat/send', data: {
      'message': message,
      if (sessionId != null) 'sessionId': sessionId,
      if (imageUrl != null) 'imageUrl': imageUrl,
    });
    // API mengembalikan { sessionId: '...', reply: '...' }
    // bukan ChatMessageModel langsung, jadi kita buat manual
    final data = response.data as Map<String, dynamic>;
    return ChatMessageModel(
      id: 'api-${DateTime.now().millisecondsSinceEpoch}',
      sessionId: data['sessionId'] as String? ?? '',
      role: 'bot',
      content: data['reply'] as String? ?? '',
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<List<ChatSessionModel>> getSessions() async {
    final response = await dio.get('/chat/sessions');
    final list = response.data as List;
    return list.map((e) => ChatSessionModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String sessionId) async {
    final response = await dio.get('/chat/$sessionId/messages');
    final list = response.data as List;
    return list.map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}

// ── 4. PROVIDER SWITCH ──────────────────────────────────────────────────
// ✅ ONE LINE TOGGLE
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  // 👇 REAL: Connected to NestJS backend
  return ApiChatRepository(ref.watch(dioProvider));

  // 👇 MOCK: Uncomment to go back to mock during development
  // return MockChatRepository();
});
