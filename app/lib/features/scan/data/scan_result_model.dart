// lib/features/scan/data/scan_result_model.dart

class ScanResultModel {
  final String id;
  final String imageUrl;
  final String diagnosis;
  final String severity; // Ringan / Sedang / Parah
  final String confidence; // e.g. "89%"
  final String recommendation; // Full text with steps
  final String? rawResponse;
  final String? feedback; // "accurate" / "inaccurate" / null
  final DateTime createdAt;

  const ScanResultModel({
    required this.id,
    required this.imageUrl,
    required this.diagnosis,
    required this.severity,
    required this.confidence,
    required this.recommendation,
    this.rawResponse,
    this.feedback,
    required this.createdAt,
  });

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    return ScanResultModel(
      id: json['id'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      diagnosis: json['diagnosis'] as String? ?? '',
      severity: json['severity'] as String? ?? 'Ringan',
      confidence: json['confidence'] as String? ?? '0%',
      recommendation: json['recommendation'] as String? ?? '',
      rawResponse: json['rawResponse'] as String?,
      feedback: json['feedback'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'imageUrl': imageUrl,
    'diagnosis': diagnosis,
    'severity': severity,
    'confidence': confidence,
    'recommendation': recommendation,
    'rawResponse': rawResponse,
    'feedback': feedback,
    'createdAt': createdAt.toIso8601String(),
  };

  ScanResultModel copyWith({
    String? id,
    String? imageUrl,
    String? diagnosis,
    String? severity,
    String? confidence,
    String? recommendation,
    String? rawResponse,
    String? feedback,
    DateTime? createdAt,
  }) {
    return ScanResultModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      diagnosis: diagnosis ?? this.diagnosis,
      severity: severity ?? this.severity,
      confidence: confidence ?? this.confidence,
      recommendation: recommendation ?? this.recommendation,
      rawResponse: rawResponse ?? this.rawResponse,
      feedback: feedback ?? this.feedback,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ── MOCK DATA ──────────────────────────────────────────────────────
  static final List<ScanResultModel> mockHistory = [
    ScanResultModel(
      id: 'scan-001',
      imageUrl: 'mock://scan_001',
      diagnosis: 'Bercak Daun Coklat (Brown Spot)',
      severity: 'Sedang',
      confidence: '89%',
      recommendation: '''• Potong dan buang daun yang terinfeksi segera
• Kurangi kelembapan dengan perbaiki sirkulasi udara
• Aplikasikan fungisida berbahan aktif mancozeb atau iprodion
• Hindari menyiram dari atas — siram di pangkal tanaman
• Ulangi penyemprotan setiap 7-10 hari selama 3 minggu''',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ScanResultModel(
      id: 'scan-002',
      imageUrl: 'mock://scan_002',
      diagnosis: 'Serangan Wereng Coklat',
      severity: 'Parah',
      confidence: '94%',
      recommendation: '''• Segera lakukan aplikasi insektisida sistemik (imidakloprid/tiametoksam)
• Atur sistem pengairan — genangi sawah 5-7 cm selama 1 minggu
• Gunakan varietas tahan wereng untuk musim berikutnya
• Pasang lampu perangkap di malam hari
• Konsultasi dengan PPL terdekat untuk penanganan lanjutan''',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ScanResultModel(
      id: 'scan-003',
      imageUrl: 'mock://scan_003',
      diagnosis: 'Kekurangan Nitrogen (N)',
      severity: 'Ringan',
      confidence: '76%',
      recommendation: '''• Tambahkan pupuk Urea (46% N) dengan dosis 200 kg/ha
• Bagi pemupukan menjadi 3 kali: tanam, 30 HST, dan 60 HST
• Pertimbangkan pupuk organik cair sebagai suplemen
• Cek pH tanah — idealnya 5.5-7.0 untuk penyerapan N optimal''',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  static ScanResultModel get mockSingle => mockHistory.first;
}
