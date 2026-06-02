// lib/core/constants/app_constants.dart

/// App-wide constants — strings, sizes, durations, mock data
class AppConstants {
  AppConstants._();

  // ── APP INFO ──────────────────────────────────────────────────────
  static const String appName = 'Agrotani';
  static const String appTagline = 'Asisten Pertanian Cerdas';

  // ── API ────────────────────────────────────────────────────────────
  // Cara ubah tanpa edit kode:
  //   flutter run --dart-define=API_URL=http://192.168.x.x:3000/api
  // Atau edit .vscode/launch.json (lebih praktis)
  // Emulator Android pakai: http://10.0.2.2:3000/api
  // Device fisik pakai: http://<IP-laptop>:3000/api
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://192.168.200.253:3000/api', // fallback ke IP WiFi saat ini
  );
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ── STORAGE KEYS ──────────────────────────────────────────────────
  static const String tokenKey = 'agrotani_access_token';
  static const String userKey = 'agrotani_user_data';

  // ── SCAN ──────────────────────────────────────────────────────────
  static const int maxImageSizeKb = 1024; // 1MB
  static const int imagePxLimit = 1280;   // Resize before upload

  // ── SIZES (Layout spacing rhythm) ─────────────────────────────────
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusRound = 100;

  static const double cardPadding = 16;
  static const double screenPadding = 20;

  // ── ANIMATION DURATIONS ───────────────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animMedium = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);
  static const Duration animSplash = Duration(milliseconds: 1800);
  static const Duration mockDelay = Duration(milliseconds: 2200);

  // ── FARMERBOT QUICK REPLIES ───────────────────────────────────────
  static const List<String> quickReplies = [
    '🌾 Cara menanam padi yang baik?',
    '🐛 Hama apa yang sering menyerang cabai?',
    '💧 Kapan waktu terbaik menyiram tanaman?',
    '🌿 Pupuk organik apa yang bagus?',
  ];

  // ── DAILY TIPS ────────────────────────────────────────────────────
  static const List<Map<String, String>> dailyTips = [
    {
      'icon': '💧',
      'title': 'Waktu Menyiram',
      'tip': 'Siram tanaman di pagi hari sebelum jam 10 atau sore setelah jam 16 untuk mengurangi penguapan.',
    },
    {
      'icon': '🌱',
      'title': 'Rotasi Tanam',
      'tip': 'Rotasi jenis tanaman setiap musim untuk mencegah penumpukan hama dan menjaga kesuburan tanah.',
    },
    {
      'icon': '🌿',
      'title': 'Pupuk Organik',
      'tip': 'Kompos daun kering + kotoran ternak = pupuk organik terbaik. Fermentasi 4-6 minggu sebelum dipakai.',
    },
    {
      'icon': '🐛',
      'title': 'Deteksi Dini Hama',
      'tip': 'Periksa bagian bawah daun setiap 3 hari. Hama biasanya bersembunyi di sana sebelum menyebar.',
    },
    {
      'icon': '☀️',
      'title': 'Kebutuhan Sinar Matahari',
      'tip': 'Sayuran butuh minimal 6 jam sinar langsung per hari. Pastikan area tanam tidak terhalang bayangan.',
    },
    {
      'icon': '🪣',
      'title': 'Drainase Baik',
      'tip': 'Tanah yang terlalu basah bisa menyebabkan busuk akar. Pastikan pot/lahan punya lubang drainase.',
    },
    {
      'icon': '✂️',
      'title': 'Pemangkasan Rutin',
      'tip': 'Pangkas daun kuning dan ranting mati agar nutrisi fokus ke pertumbuhan bagian yang sehat.',
    },
    {
      'icon': '🌡️',
      'title': 'Suhu Ideal',
      'tip': 'Kebanyakan sayuran tumbuh baik di 20-30°C. Di iklim Indonesia, tanam di musim hujan lebih optimal.',
    },
  ];
}
