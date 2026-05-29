# 🔍 REVIEW: Agrotani — Iterasi & Improvement untuk Realisasi

> **Reviewer Role**: Product & Technical Reviewer  
> **Dokumen yang di-review**: [README.md](file:///home/vert/Project/Agrotani/README.md)  
> **Tanggal Review**: 28 Mei 2026  
> **Tujuan**: Mengidentifikasi gap, kelemahan, dan peluang improvement agar ide Agrotani dapat **benar-benar terealisasi** di dunia nyata.

---

## 📊 Ringkasan Review

| Kategori | Jumlah Item | Prioritas Tertinggi |
|----------|-------------|---------------------|
| [1. Gap Kritis & Missing Pieces](#1--gap-kritis--missing-pieces) | 12 item | 🔴 5 Critical |
| [2. Improvement Arsitektur & Teknis](#2--improvement-arsitektur--teknis) | 14 item | 🔴 4 Critical |
| [3. Fitur Baru yang Harus Ditambahkan](#3--fitur-baru-yang-harus-ditambahkan) | 16 item | 🟠 8 High |
| [4. Improvement AI & Prompt Engineering](#4--improvement-ai--prompt-engineering) | 11 item | 🔴 3 Critical |
| [5. Improvement UX untuk Petani Nyata](#5--improvement-ux-untuk-petani-nyata) | 13 item | 🔴 4 Critical |
| [6. Improvement Bisnis & Go-to-Market](#6--improvement-bisnis--go-to-market) | 10 item | 🟠 5 High |
| [7. Risiko & Mitigasi](#7--risiko--mitigasi) | 9 item | 🔴 4 Critical |
| [8. Prioritas Eksekusi](#8--prioritas-eksekusi--apa-yang-harus-dikerjakan-duluan) | Reordering | — |
| **TOTAL** | **85 item** | |

---

## 1. 🚨 Gap Kritis & Missing Pieces

Bagian-bagian yang **hilang** atau **tidak cukup detail** di README saat ini, yang akan menjadi blocker jika tidak ditambahkan.

### 1.1 🔴 Tidak Ada Strategi Offline yang Konkret

**Masalah**: README menyebutkan "offline-first" berulang kali, tapi **tidak ada desain teknis bagaimana offline bekerja**. Ini kritis karena target user utama (Pak Harto) punya koneksi tidak stabil.

**Yang harus ditambahkan**:
- [ ] Arsitektur offline-first yang jelas: apa yang di-cache lokal, apa yang butuh internet
- [ ] Strategi sync conflict resolution (petani scan offline, lalu sync → bagaimana jika ada conflict?)
- [ ] Local-first database design (SQLite/Hive di device → sync ke cloud)
- [ ] Compressed AI model lokal untuk diagnosis dasar tanpa internet (TensorFlow Lite / ONNX)
- [ ] Ukuran cache dan storage budget (HP Pak Harto cuma 32 GB storage, mungkin tersisa 3-5 GB)
- [ ] Queue system: foto yang diambil offline masuk antrian, diproses saat online

**Rekomendasi konkret**:
```
OFFLINE CAPABILITY MATRIX:
═════════════════════════

Fitur                     | Offline? | Cara Kerja Offline
─────────────────────────────────────────────────────────
Ambil foto tanaman        | ✅ Ya    | Disimpan lokal, masuk queue
Diagnosis AI (Gemini)     | ❌ Tidak | Butuh API call → queue
Diagnosis AI (Basic)      | ✅ Ya    | TFLite model lokal (top-10 penyakit umum)
Lihat riwayat scan        | ✅ Ya    | Cached di local DB
FarmerBot chat            | ❌ Tidak | Butuh API → tampilkan FAQ offline
Kalender tanam            | ✅ Ya    | Fully local setelah setup
Cuaca                     | 🟡 Partial | Cache forecast 3 hari terakhir
Buku tani digital         | ✅ Ya    | Local-first, sync saat online
Push notification         | ❌ Tidak | Butuh koneksi
```

---

### 1.2 🔴 Tidak Ada Strategi Data Collection & Knowledge Base

**Masalah**: README menyebutkan "knowledge base 500+ penyakit" tapi **tidak menjelaskan dari mana datanya**. Ini bukan fitur yang bisa di-code — ini butuh riset dan kurasi nyata.

**Yang harus ditambahkan**:
- [ ] Sumber data penyakit tanaman: dari mana? Siapa yang mengkurasi?
  - BPTPH (Balai Perlindungan Tanaman Pangan dan Hortikultura)
  - Jurnal penelitian IPB, UGM, UNPAD
  - FAO Crop Disease Database
  - PlantVillage dataset (open source)
- [ ] Pipeline kurasi data: raw data → validasi ahli → format JSON → masuk knowledge base
- [ ] Siapa "agricultural expert" yang memvalidasi? Perlu MoU dengan fakultas pertanian
- [ ] Strategi update knowledge base: penyakit baru muncul, produk baru tersedia
- [ ] Dataset gambar penyakit tanaman Indonesia — ini **tidak ada** di PlantVillage yang kebanyakan data US/EU
- [ ] Budget dan timeline untuk data collection (ini bisa 2-4 bulan sendiri)

---

### 1.3 🔴 Tidak Ada Strategi Validasi Akurasi AI

**Masalah**: README klaim target akurasi 70-85% tapi **tidak ada mekanisme untuk mengukur dan memvalidasi** akurasi tersebut.

**Yang harus ditambahkan**:
- [ ] Ground truth dataset: siapa yang melabeli "ini benar blast, bukan brown spot"?
- [ ] Validation pipeline: setiap N diagnosis, di-review oleh ahli pertanian
- [ ] A/B testing framework untuk prompt engineering (prompt A vs prompt B → mana yang lebih akurat?)
- [ ] Feedback loop: user feedback ("diagnosis ini benar/salah") → masuk training data
- [ ] Benchmark protocol: test set 1000 gambar yang sudah dilabeli → ukur precision/recall
- [ ] Disclaimer legal: "Ini bukan pengganti konsultasi ahli pertanian" — perlu di-highlight

---

### 1.4 🔴 Tidak Ada Error Handling & Edge Cases

**Masalah**: README hanya menjelaskan happy path. Dunia nyata penuh edge cases.

**Yang harus ditambahkan**:
- [ ] Apa yang terjadi jika Gemini API down? Fallback strategy?
- [ ] Apa yang terjadi jika foto buram / gelap / bukan tanaman?
- [ ] Apa yang terjadi jika tanaman punya multiple penyakit sekaligus?
- [ ] Apa yang terjadi jika petani mengirim foto tanaman yang tidak ada di database?
- [ ] Apa yang terjadi jika rekomendasi produk tidak tersedia di daerah petani?
- [ ] Rate limiting: petani free tier habis kuota → UX-nya bagaimana?
- [ ] Gemini response yang tidak sesuai format JSON → retry? fallback?
- [ ] Timeout handling: scan sudah 30 detik belum selesai → user experience?

---

### 1.5 🔴 Tidak Ada Strategi Testing & QA yang Spesifik

**Masalah**: Tidak ada detail bagaimana memastikan aplikasi bekerja dengan benar sebelum ke tangan petani.

**Yang harus ditambahkan**:
- [ ] Unit test strategy untuk setiap service
- [ ] Integration test untuk AI pipeline (mock Gemini response)
- [ ] End-to-end test untuk user flow kritis
- [ ] **Field testing protocol**: uji coba di sawah nyata, bukan di lab
- [ ] Usability testing dengan petani asli (bukan developer yang role-play jadi petani)
- [ ] Performance testing pada HP low-end (RAM 2 GB, Android 6)
- [ ] Network condition testing (2G, 3G, intermittent connection)

---

### 1.6 🟠 Tidak Ada Multi-Tenancy & Data Isolation Strategy

**Masalah**: Jika nantinya ada enterprise client (agribisnis, dinas pertanian), bagaimana data mereka diisolasi?

**Yang harus ditambahkan**:
- [ ] Tenant isolation di database level
- [ ] Separate storage bucket per enterprise tenant
- [ ] Admin dashboard per tenant
- [ ] Billing per tenant

---

### 1.7 🟠 Tidak Ada Internationalization (i18n) Strategy yang Detail

**Masalah**: Disebutkan akan mendukung bahasa Jawa/Sunda/Madura tapi tidak ada strategi teknis.

**Yang harus ditambahkan**:
- [ ] i18n framework di Flutter (intl package, arb files)
- [ ] Translation management workflow
- [ ] Bagaimana prompt Gemini di-adjust per bahasa?
- [ ] Fallback: jika terjemahan belum tersedia → tampilkan Bahasa Indonesia

---

### 1.8 🟠 Notification Strategy Terlalu Sederhana

**Masalah**: Cuma disebutkan "push notification" tapi petani di daerah sering tidak bisa terima push notif karena HP di-optimize battery.

**Yang harus ditambahkan**:
- [ ] **WhatsApp Business API integration** — ini lebih reliable daripada push notif untuk petani
- [ ] **SMS fallback** untuk area tanpa internet stabil
- [ ] Notification preference: petani pilih mau dihubungi via apa
- [ ] Do Not Disturb hours (petani tidur jam 8 malam, bangun jam 4 subuh)
- [ ] Notification grouping agar tidak spam

---

### 1.9 🟡 Tidak Ada Accessibility untuk Disabilitas

**Yang harus ditambahkan**:
- [ ] Screen reader support (TalkBack/VoiceOver)
- [ ] High contrast mode
- [ ] Adjustable font size
- [ ] Haptic feedback untuk interaksi penting

---

### 1.10 🟡 Tidak Ada Data Migration Strategy

**Yang harus ditambahkan**:
- [ ] Bagaimana jika skema database berubah di update berikutnya?
- [ ] Versioning API: v1 → v2 migration path
- [ ] Local database migration di device petani saat app update

---

### 1.11 🟡 Tidak Ada Compliance & Regulasi

**Yang harus ditambahkan**:
- [ ] UU PDP (Undang-Undang Perlindungan Data Pribadi) Indonesia — wajib comply
- [ ] Peraturan Menteri Pertanian tentang rekomendasi pestisida — tidak boleh sembarangan merekomendasikan
- [ ] Disclaimer bahwa ini bukan pengganti sertifikasi/izin dari dinas terkait
- [ ] Terms of Service yang jelas tentang liability (jika rekomendasi AI salah → siapa tanggung jawab?)

---

### 1.12 🟡 Tidak Ada Logging & Audit Trail Strategy

**Yang harus ditambahkan**:
- [ ] Apa yang di-log: setiap scan, setiap diagnosis, setiap rekomendasi
- [ ] Retention policy: berapa lama log disimpan
- [ ] Audit trail: jika ada komplain, bisa trace balik apa yang terjadi
- [ ] AI response logging: simpan raw Gemini response untuk debugging & improvement

---

## 2. 🔧 Improvement Arsitektur & Teknis

### 2.1 🔴 Arsitektur Terlalu Complex untuk MVP

**Masalah**: README mendesain arsitektur enterprise-level (Kubernetes, microservices, ClickHouse, ElasticSearch, dll) untuk MVP yang target 100 user. Ini akan **membunuh velocity development**.

**Improvement**:
- [ ] **MVP (Bulan 1-3): Monolith dulu, bukan microservices**
  ```
  REKOMENDASI ARSITEKTUR PER PHASE:
  
  MVP (100 users):
  ├── Single NestJS/FastAPI app (monolith)
  ├── PostgreSQL saja (tanpa Redis, tanpa ClickHouse)
  ├── Firebase untuk auth + push notif + storage
  ├── Gemini API langsung
  └── Deploy di Cloud Run (serverless, pay-per-use)
  
  Growth (10K users):
  ├── Mulai pisahkan AI service
  ├── Tambah Redis untuk caching
  ├── Add message queue (Bull)
  └── Masih Cloud Run
  
  Scale (100K+ users):
  ├── Full microservices
  ├── GKE / Kubernetes
  ├── ClickHouse untuk analytics
  └── ElasticSearch untuk search
  ```
- [ ] Gunakan Firebase untuk MVP (Auth, Firestore, Storage, FCM) — lebih cepat develop
- [ ] Jangan pakai Kubernetes sebelum 50K users — overkill dan mahal

---

### 2.2 🔴 Tech Stack Terlalu Banyak Bahasa

**Masalah**: Mix TypeScript (NestJS) + Python (FastAPI) di backend → 2 runtime, 2 build system, 2 deployment pipeline. Tim kecil akan kewalahan.

**Improvement**:
- [ ] **Pilih satu**: Python saja (FastAPI untuk semua) ATAU TypeScript saja (NestJS untuk semua)
- [ ] Rekomendasi: **Python FastAPI saja** karena:
  - AI/ML ecosystem Python lebih kuat
  - Gemini SDK Python lebih mature
  - Image processing library Python lebih lengkap (Pillow, OpenCV)
  - Satu bahasa = lebih sedikit context switching
- [ ] Jika tetap mau TypeScript untuk non-AI routes, gunakan monorepo (Turborepo) agar sharing types

---

### 2.3 🔴 Database Schema Kurang Lengkap

**Masalah**: Schema di README tidak mencakup beberapa entitas penting.

**Yang harus ditambahkan**:
- [ ] Tabel `knowledge_base_entries` — untuk menyimpan data penyakit yang jadi RAG context
- [ ] Tabel `products` — database produk pertanian (pupuk, pestisida) dengan harga & ketersediaan
- [ ] Tabel `feedback` — user feedback pada diagnosis (benar/salah/tidak tahu)
- [ ] Tabel `notification_preferences` — preferensi notifikasi per user
- [ ] Tabel `prompt_versions` — version control untuk prompt templates
- [ ] Tabel `ai_logs` — raw request/response ke Gemini untuk debugging
- [ ] Tabel `weather_cache` — cache data cuaca per lokasi
- [ ] Tabel `user_devices` — tracking device petani untuk multi-device support
- [ ] Soft delete (`deleted_at`) di semua tabel — jangan hard delete data petani
- [ ] Proper indexing strategy — query pattern yang sering: `WHERE user_id = X AND created_at > Y`

---

### 2.4 🔴 Tidak Ada Caching Strategy yang Detail

**Masalah**: Redis disebut tapi tidak ada detail apa yang di-cache dan berapa lama.

**Improvement**:
- [ ] Definisikan cache layers:
  ```
  CACHE STRATEGY:
  
  L1: In-Memory (per instance)
  ├── Hot prompt templates: TTL 1 jam
  ├── User session: TTL 15 menit
  └── Weather data: TTL 30 menit
  
  L2: Redis
  ├── AI response cache (hash gambar → diagnosis): TTL 24 jam
  ├── Knowledge base embeddings: TTL 7 hari
  ├── User profile: TTL 1 jam
  ├── Rate limit counters: TTL sesuai window
  └── Popular disease info: TTL 12 jam
  
  L3: CDN (CloudFlare)
  ├── Static assets: TTL 30 hari
  ├── Knowledge base images: TTL 7 hari
  └── App config: TTL 1 jam
  ```
- [ ] Cache invalidation strategy — kapan cache di-bust?
- [ ] Cache warming — pre-populate cache saat deployment

---

### 2.5 🟠 API Design Perlu Improvement

**Improvement**:
- [ ] Tambahkan API versioning yang konsisten (`/v1/`, `/v2/`)
- [ ] Tambahkan pagination di semua list endpoints (`?page=1&limit=20`)
- [ ] Tambahkan filtering & sorting (`?crop_type=padi&sort=created_at:desc`)
- [ ] Gunakan cursor-based pagination (bukan offset) untuk performa
- [ ] Tambahkan `ETag` / `If-Modified-Since` untuk bandwidth optimization (penting untuk koneksi lambat)
- [ ] Definisikan error response format yang konsisten:
  ```json
  {
    "error": {
      "code": "DIAGNOSIS_FAILED",
      "message": "Gambar tidak dapat dianalisis",
      "details": "Kualitas gambar terlalu rendah (resolusi 320x240)",
      "suggestion": "Coba ambil foto dari jarak lebih dekat dengan pencahayaan yang cukup",
      "retry_after_seconds": null
    }
  }
  ```
- [ ] Tambahkan health check endpoint (`/health`, `/ready`)
- [ ] Rate limit headers di response (`X-RateLimit-Remaining`, `X-RateLimit-Reset`)

---

### 2.6 🟠 WebSocket Perlu Dipertimbangkan Ulang

**Masalah**: WebSocket untuk chat dan scan progress → overhead untuk koneksi tidak stabil.

**Improvement**:
- [ ] Untuk chat: gunakan **Server-Sent Events (SSE)** untuk streaming response AI — lebih ringan, auto-reconnect
- [ ] Untuk scan progress: gunakan **polling dengan exponential backoff** — lebih reliable di koneksi jelek
- [ ] WebSocket hanya untuk fitur yang benar-benar butuh bidirectional real-time

---

### 2.7 🟠 Image Processing Pipeline Perlu Detail Lebih

**Improvement**:
- [ ] Definisikan compression strategy: foto 4MB dari kamera → compress ke berapa sebelum upload?
- [ ] Progressive upload: upload thumbnail dulu (instant feedback) → upload full resolution di background
- [ ] Batch upload optimization untuk multi-foto
- [ ] Client-side resize sebelum upload (hemat bandwidth petani)
- [ ] Format optimization: convert ke WebP (40% lebih kecil dari JPEG)

---

### 2.8 🟠 Monitoring & Alerting Kurang Spesifik

**Improvement**:
- [ ] Definisikan SLI/SLO:
  - API availability: 99.5% uptime
  - Scan response time: p95 < 15 detik
  - Chat response time: p95 < 5 detik
  - Error rate: < 1%
- [ ] Alert rules: kapan on-call di-ping?
- [ ] Business metrics monitoring: scan volume, chat volume, churn signals
- [ ] AI quality monitoring: confidence score distribution, user feedback trend

---

### 2.9 🟡 CI/CD Pipeline Perlu Detail

**Improvement**:
- [ ] Branch strategy: `main` → `staging` → `production`
- [ ] Auto-test pada setiap PR
- [ ] Staging deployment otomatis
- [ ] Production deployment dengan approval gate
- [ ] Rollback strategy jika deployment gagal
- [ ] Database migration sebagai bagian dari CI/CD
- [ ] Canary deployment untuk release berisiko

---

### 2.10 🟡 Mobile App Size Harus Diperhitungkan

**Masalah**: Flutter app + TFLite model + asset → bisa besar. Petani HP-nya storage kecil.

**Improvement**:
- [ ] Target app size: < 50 MB (install), < 30 MB (download dari Play Store)
- [ ] Gunakan app bundle (bukan APK) untuk split per arsitektur
- [ ] Lazy load TFLite model (download saat pertama kali butuh, bukan saat install)
- [ ] Compress semua asset (gambar, font)
- [ ] Implementasi storage management: auto-cleanup cache lama

---

### 2.11 🟡 Perlu Definisi Service Level untuk Gemini API

**Improvement**:
- [ ] Berapa biaya per request Gemini? Budget berapa per bulan?
- [ ] Gemini Flash vs Gemini Pro: kapan pakai yang mana?
  ```
  Gemini Flash (murah, cepat):
  ├── Chat responses
  ├── Simple Q&A
  └── Follow-up questions
  
  Gemini Pro (mahal, akurat):
  ├── Image diagnosis (vision)
  ├── Complex recommendation
  └── Urgency assessment
  ```
- [ ] Fallback ke Gemini Flash jika Pro rate-limited
- [ ] Cost estimation per user tier:
  - Free: ~$0.05/user/month
  - Premium: ~$0.15/user/month

---

### 2.12 🟡 Perlu API Gateway yang Lebih Pragmatis

**Masalah**: README menyebutkan Kong / AWS API Gateway — terlalu berat untuk MVP.

**Improvement**:
- [ ] MVP: gunakan Nginx reverse proxy atau Cloud Run langsung
- [ ] Growth: tambahkan rate limiting di application level (middleware)
- [ ] Scale: baru migrasi ke managed API gateway

---

### 2.13 🟡 Perlu Background Job Strategy

**Yang harus ditambahkan**:
- [ ] Job types: scan processing, notification sending, weather sync, analytics aggregation
- [ ] Retry strategy: berapa kali retry? exponential backoff?
- [ ] Dead letter queue: job yang gagal terus → ke mana?
- [ ] Job monitoring: dashboard untuk melihat status job

---

### 2.14 🟡 Perlu Content Delivery Strategy untuk Gambar

**Improvement**:
- [ ] CDN untuk gambar penyakit di knowledge base (di-serve dari edge)
- [ ] Thumbnail generation pipeline (gambar asli → thumbnail 150px untuk list view)
- [ ] Lazy loading gambar di app
- [ ] Signed URL dengan expiry untuk gambar diagnosis (privacy)

---

## 3. ✨ Fitur Baru yang Harus Ditambahkan

### 3.1 🟠 WhatsApp Integration (KRUSIAL)

**Mengapa penting**: 95%+ petani Indonesia sudah pakai WhatsApp. Jika bisa scan via WhatsApp, barrier to adoption hampir nol.

**Fitur**:
- [ ] Kirim foto tanaman ke nomor WhatsApp Agrotani → dapat diagnosis
- [ ] Tanya jawab via WhatsApp (seperti FarmerBot tapi di WhatsApp)
- [ ] Terima alert urgency via WhatsApp
- [ ] Gunakan WhatsApp Business API (Twilio / 360dialog)
- [ ] Ini bisa jadi **channel utama** sebelum petani download app

```
USER JOURNEY via WhatsApp:
══════════════════════════

Petani (WA): [Kirim foto daun padi yang sakit]

Agrotani Bot (WA): 
"📸 Foto diterima! Sedang menganalisis...

📋 HASIL DIAGNOSIS:
🔴 Blast (Blas) — Keyakinan 85%
⚠️ Tingkat: SEDANG (6/10)

💊 YANG HARUS DILAKUKAN:
1. Semprot Beam 75 WP (1.5 gr/liter)
2. Kurangi Urea 50%
3. Scan ulang 3 hari lagi

📲 Download app Agrotani untuk fitur lengkap:
[link]"
```

---

### 3.2 🟠 Sistem Referral & Gamifikasi

**Mengapa penting**: Petani saling kenal. Word of mouth adalah marketing terbaik di komunitas petani.

**Fitur**:
- [ ] Referral code: ajak teman → dapat scan gratis
- [ ] Badges & achievements:
  - 🌱 "Petani Pemula" — pertama kali scan
  - 🔍 "Detektif Tanaman" — 10 scan berhasil
  - 👨‍🏫 "Guru Tani" — bantu 5 petani lain di forum
  - 🏆 "Petani Cerdas" — 3 bulan berturut-turut tanaman sehat
- [ ] Leaderboard per desa/kecamatan
- [ ] Reward: kuota scan gratis, diskon produk partner

---

### 3.3 🟠 Mode Darurat (Emergency Mode)

**Mengapa penting**: Saat outbreak penyakit, petani butuh guidance cepat tanpa harus navigasi app.

**Fitur**:
- [ ] Tombol "DARURAT" di home screen → langsung buka kamera + fast diagnosis
- [ ] Skip semua pilihan (tanaman, bagian) → AI auto-detect
- [ ] Hasil langsung di-share ke grup tani di area tersebut
- [ ] Auto-notify penyuluh pertanian terdekat
- [ ] Panduan evakuasi/tindakan darurat step-by-step dengan gambar

---

### 3.4 🟠 Integrasi dengan Kelompok Tani (Poktan)

**Mengapa penting**: Petani Indonesia terorganisir dalam Kelompok Tani. Ini unit sosial yang sudah ada.

**Fitur**:
- [ ] Buat/join Kelompok Tani di app
- [ ] Dashboard per kelompok tani: ringkasan kesehatan semua lahan anggota
- [ ] Shared knowledge: diagnosis satu anggota bisa dilihat anggota lain (opt-in)
- [ ] Koordinasi pembelian input bersama (collective purchasing)
- [ ] Laporan kelompok tani untuk dinas pertanian

---

### 3.5 🟠 Sistem Pencatatan Biaya Produksi (Hitung Untung-Rugi)

**Mengapa penting**: Petani sering tidak tahu berapa sebenarnya untung/rugi mereka per musim.

**Fitur**:
- [ ] Input biaya: benih, pupuk, pestisida, tenaga kerja, sewa lahan, dll
- [ ] Input pendapatan: hasil panen × harga jual
- [ ] Hitung otomatis: profit/loss per musim per petak
- [ ] Tren antar musim: "Musim ini biaya pupuk naik 20%"
- [ ] Rekomendasi efisiensi: "Ganti ke pupuk organik bisa hemat Rp X/hektar"
- [ ] Export laporan PDF untuk kredit bank

---

### 3.6 🟠 Peta Sebaran Penyakit (Disease Heatmap) — Publik

**Mengapa penting**: Data crowdsourced dari semua petani bisa jadi early warning system nasional.

**Fitur**:
- [ ] Peta Indonesia dengan overlay penyakit yang dilaporkan
- [ ] Filter per jenis penyakit, per tanaman, per waktu
- [ ] Alert otomatis jika penyakit terdeteksi di radius X km dari lahan petani
- [ ] Data anonymized (tidak ada identitas petani yang terlihat)
- [ ] Bisa diakses oleh Dinas Pertanian untuk policy making
- [ ] Ini juga jadi value proposition untuk partnership dengan pemerintah

---

### 3.7 🟡 Sistem Rekomendasi Varietas Tanaman

**Fitur**:
- [ ] Input: lokasi, tipe tanah, musim, budget
- [ ] Output: varietas tanaman yang optimal
- [ ] Data dari Balitbangtan (Badan Litbang Pertanian)
- [ ] Pertimbangkan ketahanan terhadap penyakit lokal
- [ ] Informasi dimana beli benih varietas tersebut

---

### 3.8 🟡 Tutorial & Edukasi Pertanian

**Fitur**:
- [ ] Video tutorial singkat (< 3 menit) dalam Bahasa Indonesia
- [ ] Step-by-step guide bergambar untuk tindakan umum
- [ ] Quiz ringan setelah tutorial (gamifikasi)
- [ ] Konten dari ahli pertanian / universitas
- [ ] Bisa diakses offline (download untuk nonton nanti)

---

### 3.9 🟡 Integrasi Subsidi & Bantuan Pemerintah

**Fitur**:
- [ ] Info program subsidi pupuk terbaru
- [ ] Kelayakan: apakah petani ini eligible?
- [ ] Panduan cara daftar subsidi
- [ ] Tracking status pengajuan
- [ ] Kalender program pemerintah (Kartu Tani, PUPM, dll)

---

### 3.10 🟡 Mode Perbandingan (Compare Mode)

**Fitur**:
- [ ] Bandingkan 2 foto tanaman side-by-side (sebelum vs sesudah treatment)
- [ ] Progress tracker visual: scan hari 1 → scan hari 7 → scan hari 14
- [ ] AI assessment: "Kondisi membaik 30% dibanding scan terakhir"
- [ ] Ini juga memotivasi petani untuk rutin scan (engagement boost)

---

### 3.11 🟡 Export & Sharing yang Lebih Kuat

**Fitur**:
- [ ] Export hasil diagnosis sebagai gambar/card yang bisa di-share ke WhatsApp
- [ ] PDF report per musim tanam
- [ ] Share ke grup tani dengan satu tap
- [ ] Deep link: buka hasil scan langsung di app dari link yang di-share

---

### 3.12 🟡 Integrasi Google Maps untuk Pemetaan Lahan

**Fitur**:
- [ ] Petani bisa gambar batas lahan di peta (polygon)
- [ ] Hitung luas otomatis dari polygon
- [ ] Pin lokasi per petak
- [ ] Lihat lahan petani lain di sekitar (opt-in) untuk community features

---

### 3.13 🟡 Histori Harga Input Pertanian

**Fitur**:
- [ ] Tracking harga pupuk, pestisida di daerah petani
- [ ] Alert jika harga naik/turun signifikan
- [ ] Rekomendasi waktu beli optimal
- [ ] Perbandingan harga antar toko

---

### 3.14 🟡 Sistem Rating & Review Produk

**Fitur**:
- [ ] Petani bisa rate produk pupuk/pestisida yang dipakai
- [ ] Review: "Beam 75 WP bagus untuk blast, 4 hari sudah sembuh"
- [ ] Ranking produk per jenis penyakit
- [ ] Ini juga jadi data berharga untuk partnership dengan produsen

---

### 3.15 🟡 Asisten Kalkulasi Dosis

**Fitur**:
- [ ] Input: luas lahan + produk yang akan dipakai
- [ ] Output: jumlah produk yang dibutuhkan, jumlah air, biaya total
- [ ] Sesuaikan dengan tangki semprot yang dipakai (14L, 16L)
- [ ] Reminder: "Sudah saatnya semprot ulang"

---

### 3.16 🟡 Widget Home Screen

**Fitur**:
- [ ] Widget cuaca pertanian di home screen Android
- [ ] Widget alert urgency aktif
- [ ] Widget countdown ke panen
- [ ] Akses cepat scan tanpa buka app

---

## 4. 🧠 Improvement AI & Prompt Engineering

### 4.1 🔴 Prompt Engineering Perlu Guardrails Lebih Kuat

**Masalah**: Prompt saat ini tidak cukup melindungi dari hallucination dan jailbreak.

**Improvement**:
- [ ] Tambahkan **anti-hallucination guardrails**:
  ```
  TAMBAHAN DI SYSTEM PROMPT:
  
  BATASAN KETAT:
  • JANGAN PERNAH mengarang nama penyakit yang tidak ada
  • JANGAN PERNAH memberikan dosis di luar range standar label produk
  • Jika kamu tidak yakin, KATAKAN "Saya tidak yakin" — jangan mengarang
  • JANGAN merekomendasikan produk yang dilarang di Indonesia
  • Selalu cek: apakah penyakit ini memang bisa menyerang tanaman ini?
    (contoh: blast HANYA menyerang padi, bukan jagung)
  • Jika user menanyakan hal di luar pertanian, tolak dengan sopan
  ```
- [ ] Tambahkan **structured output enforcement** (Gemini JSON mode)
- [ ] Tambahkan **safety classifier** sebelum response dikirim ke user
- [ ] Implementasi **prompt injection protection**: filter input user dari prompt injection attempts

---

### 4.2 🔴 RAG (Retrieval Augmented Generation) Perlu Detail Implementasi

**Masalah**: RAG disebutkan tapi tidak ada detail arsitektur.

**Improvement**:
- [ ] Definisikan chunking strategy untuk knowledge base:
  ```
  KNOWLEDGE BASE CHUNKING:
  
  Per penyakit:
  ├── Chunk 1: Deskripsi & gejala (embedding terpisah)
  ├── Chunk 2: Penyebab & faktor risiko (embedding terpisah)
  ├── Chunk 3: Treatment protocol (embedding terpisah)
  ├── Chunk 4: Preventif & budidaya (embedding terpisah)
  └── Chunk 5: Produk & dosis (embedding terpisah)
  
  Retrieval: ambil top-K chunks yang relevan dengan query user
  ```
- [ ] Pilih vector DB yang pragmatis: **Chroma** (lokal, gratis) untuk MVP, Pinecone untuk scale
- [ ] Embedding strategy: Gemini Embeddings vs sentence-transformers
- [ ] Re-ranking: setelah retrieval, re-rank chunks untuk relevansi
- [ ] Evaluasi RAG quality: apakah context yang di-retrieve benar-benar membantu diagnosis?

---

### 4.3 🔴 Perlu Prompt Versioning & A/B Testing

**Improvement**:
- [ ] Setiap prompt template punya version number
- [ ] Deploy multiple prompt versions bersamaan (A/B test)
- [ ] Measure: prompt mana yang menghasilkan diagnosis lebih akurat?
- [ ] Rollback: jika prompt baru lebih jelek, rollback ke versi lama
- [ ] Log: setiap request catat prompt version yang digunakan

---

### 4.4 🟠 Multi-Modal Analysis Perlu Diperkuat

**Improvement**:
- [ ] Selain foto, minta input tambahan dari petani untuk meningkatkan akurasi:
  - "Apakah ada bau tidak biasa pada tanaman?"
  - "Apakah gejala muncul tiba-tiba atau bertahap?"
  - "Apakah tanaman tetangga juga kena?"
  - "Sudah berapa hari gejala muncul?"
- [ ] Guided interview mini (3-4 pertanyaan) sebelum/sesudah scan
- [ ] Kontribusi data ini ke prompt context → diagnosis lebih akurat

---

### 4.5 🟠 Perlu Confidence Calibration

**Masalah**: Gemini bisa over-confident (bilang 90% tapi salah) atau under-confident.

**Improvement**:
- [ ] Implementasi confidence calibration model:
  - Kumpulkan data: {Gemini confidence, actual accuracy}
  - Train simple calibration model
  - Adjust confidence sebelum ditampilkan ke user
- [ ] Jangan tampilkan angka confidence mentah dari Gemini — proses dulu
- [ ] Jika confidence < 50%, otomatis trigger follow-up questions

---

### 4.6 🟠 Perlu Gemini Model Selection Strategy

**Improvement**:
- [ ] Definisikan kapan pakai model mana:
  ```
  TASK → MODEL MAPPING:
  
  Image diagnosis         → Gemini 2.5 Pro (vision, highest accuracy)
  Chat conversation       → Gemini 2.5 Flash (fast, cheap)
  Urgency assessment      → Gemini 2.5 Pro (complex reasoning)
  Simple Q&A              → Gemini 2.5 Flash
  Translation             → Gemini 2.5 Flash
  Recommendation          → Gemini 2.5 Pro
  ```
- [ ] Auto-fallback: Pro → Flash jika rate limited
- [ ] Cost monitoring per model per day

---

### 4.7 🟠 Streaming Response untuk Chat

**Improvement**:
- [ ] FarmerBot harus streaming response (kata per kata muncul) — UX jauh lebih baik
- [ ] Gunakan SSE (Server-Sent Events) untuk streaming
- [ ] Loading indicator yang informatif: "FarmerBot sedang berpikir... 🤔"
- [ ] Jangan biarkan user menunggu > 5 detik tanpa feedback apapun

---

### 4.8 🟡 Perlu Few-Shot Examples di Prompt

**Improvement**:
- [ ] Tambahkan 2-3 contoh diagnosis yang benar di prompt template
- [ ] Contoh harus cover: diagnosis benar, diagnosis "tidak yakin", dan "bukan tanaman"
- [ ] Few-shot meningkatkan konsistensi output format

---

### 4.9 🟡 Perlu Specialized Prompts per Tanaman

**Improvement**:
- [ ] Prompt template spesifik per tanaman utama (padi, jagung, cabai, tomat)
- [ ] Setiap prompt include daftar penyakit umum tanaman tersebut
- [ ] Ini meningkatkan akurasi karena context lebih spesifik

---

### 4.10 🟡 Perlu Token Usage Tracking

**Improvement**:
- [ ] Track berapa token per request (input + output)
- [ ] Dashboard cost per user, per fitur, per hari
- [ ] Alert jika spending melebihi budget
- [ ] Optimasi: compress prompt tanpa kehilangan informasi
- [ ] Estimasi cost di README: berapa biaya Gemini API per 1000 scans?

---

### 4.11 🟡 Human-in-the-Loop untuk Kasus Sulit

**Improvement**:
- [ ] Jika AI confidence < 40%, eskalasi ke ahli manusia
- [ ] Network penyuluh/ahli pertanian volunteer yang bisa di-ping
- [ ] Petani mendapat notif: "Kasus Anda sedang di-review oleh ahli"
- [ ] Response dari ahli → jadi training data untuk AI

---

## 5. 👨‍🌾 Improvement UX untuk Petani Nyata

### 5.1 🔴 Onboarding Terlalu Panjang

**Masalah**: Setup profil di README butuh 7+ field (nama, HP, provinsi, kabupaten, tanaman, luas lahan, preferensi). Petani akan drop off.

**Improvement**:
- [ ] **Progressive profiling**: minta data minimal dulu, sisanya nanti
  ```
  ONBOARDING MINIMAL (< 1 menit):
  1. Nama (opsional, bisa "Pak/Bu" aja)
  2. Nomor HP → OTP
  3. Provinsi → auto-detect dari GPS
  4. SELESAI → langsung ke home
  
  PROFIL LENGKAP (isi nanti, kapan saja):
  - Kabupaten
  - Jenis tanaman
  - Luas lahan
  - Preferensi organik/konvensional
  ```
- [ ] Bisa langsung scan TANPA registrasi (trial mode)
- [ ] Daftar baru dipaksa setelah 2x scan (let them experience value first)

---

### 5.2 🔴 Font Size & Touch Target Perlu Lebih Besar

**Masalah**: 16sp masih kurang untuk petani 50+ tahun yang mungkin minus/silinder.

**Improvement**:
- [ ] Minimum body text: **18sp** (bukan 16sp)
- [ ] Heading: **24-32sp**
- [ ] Touch target: **56x56dp** (bukan 48x48dp)
- [ ] Fitur zoom text di settings
- [ ] Auto-detect system font size preference & respect it

---

### 5.3 🔴 Perlu Mode "Super Simple"

**Improvement**:
- [ ] Mode dengan hanya 2 tombol di home: "📷 SCAN" dan "💬 TANYA"
- [ ] Semua fitur lain disembunyikan di menu
- [ ] Default untuk user baru, bisa switch ke full mode
- [ ] Ini untuk Pak Harto yang cuma perlu scan dan tanya

---

### 5.4 🔴 Bahasa Harus Lebih Sederhana

**Masalah**: Contoh output di README masih terlalu teknis. "Magnaporthe oryzae", "kuratif", "differential diagnosis" — petani tidak paham.

**Improvement**:
- [ ] Dual-layer output:
  ```
  LAYER 1 (Selalu tampil — bahasa sederhana):
  "Tanaman padi Bapak kena penyakit BLAS. 
   Ini penyakit jamur yang biasa menyerang saat musim hujan.
   Kalau tidak diobati dalam 3 hari, bisa menyebar ke sebelahnya."
  
  LAYER 2 (Tap "Lihat Detail" — bahasa teknis):
  "Blast (Magnaporthe oryzae) — Penyakit jamur
   Confidence: 87% | Severity: 6/10 | Category: Fungal"
  ```
- [ ] Gunakan analogi yang familiar: "Ini seperti flu untuk tanaman"
- [ ] Hindari angka desimal: "87%" cukup, tidak perlu "87.5%"
- [ ] Gunakan warna & ikon lebih dari teks

---

### 5.5 🟠 Perlu Audio/Voice Support dari Awal

**Masalah**: Disebutkan sebagai "future feature" tapi ini seharusnya prioritas tinggi karena banyak petani lebih nyaman bicara daripada mengetik.

**Improvement**:
- [ ] Phase 1: Voice input (Speech-to-Text) — gunakan Google Speech API
- [ ] Phase 1: Text-to-Speech untuk jawaban FarmerBot (opsi, bukan default)
- [ ] Phase 2: Full voice mode — petani bisa interaksi tanpa membaca sama sekali
- [ ] Gunakan bahasa Indonesia yang natural (bukan formal)

---

### 5.6 🟠 Perlu Guided Scan Flow

**Masalah**: Saat ini petani harus pilih tanaman → pilih bagian → foto. Terlalu banyak langkah.

**Improvement**:
- [ ] **Quick Scan**: langsung foto → AI auto-detect tanaman & bagian
- [ ] **Guided Scan**: step-by-step dengan instruksi visual (untuk yang butuh panduan)
- [ ] AI auto-detect jenis tanaman dari foto (Gemini bisa ini)
- [ ] Jika AI tidak yakin, baru minta user konfirmasi

---

### 5.7 🟠 Loading State Harus Informatif & Menghibur

**Masalah**: "Sedang menganalisis..." → membosankan. Petani mungkin keluar app.

**Improvement**:
- [ ] Progress bar dengan tahapan:
  ```
  📷 Mengunggah foto...     ████░░░░░░ 30%
  🔍 Menganalisis gambar... ██████░░░░ 60%  
  🤖 AI sedang berpikir... ████████░░ 80%
  📋 Menyiapkan hasil...   ██████████ 100%
  ```
- [ ] Tips pertanian random selama loading: "Tahukah Anda? Padi butuh 2000-3000 liter air per kg beras"
- [ ] Animasi ilustrasi yang lucu/menarik
- [ ] Target: scan selesai sebelum user sempat bosan (< 8 detik)

---

### 5.8 🟠 Perlu Panic-Free UI untuk Alert Critical

**Masalah**: Alert "DARURAT! KRITIS!" bisa bikin petani panik dan malah tidak berbuat apa-apa.

**Improvement**:
- [ ] Tone alert harus tegas tapi tenang:
  ```
  ❌ BURUK: "⚠️ DARURAT! Tanaman Anda akan MATI dalam 3 hari!"
  ✅ BAIK: "Tanaman Anda butuh perhatian segera. Jangan khawatir, 
           masih bisa ditangani. Ikuti langkah ini hari ini:"
  ```
- [ ] Selalu sertakan action steps yang jelas
- [ ] Sertakan estimasi biaya penanganan (agar tidak takut mahal)
- [ ] Opsi "Hubungi Penyuluh" untuk kasus yang overwhelm

---

### 5.9 🟡 Perlu Night Mode yang Proper

**Improvement**:
- [ ] Auto dark mode berdasarkan waktu (petani sering cek HP subuh jam 4-5)
- [ ] Reduce blue light mode
- [ ] AMOLED black mode (hemat baterai di HP OLED murah)

---

### 5.10 🟡 Perlu Gesture-Based Navigation

**Improvement**:
- [ ] Swipe left pada scan result → lihat rekomendasi
- [ ] Swipe right → kembali
- [ ] Pull to refresh di semua list
- [ ] Long press pada scan → quick actions (share, rescan, delete)

---

### 5.11 🟡 Perlu Konfirmasi Sebelum Tindakan Penting

**Improvement**:
- [ ] Konfirmasi sebelum hapus data
- [ ] Konfirmasi sebelum mark alert sebagai "sudah ditangani"
- [ ] Undo button selama 5 detik setelah tindakan

---

### 5.12 🟡 Perlu Feedback Mechanism yang Mudah

**Improvement**:
- [ ] Setelah diagnosis: thumbs up / thumbs down (satu tap)
- [ ] Setelah rekomendasi berhasil: "Apakah tanaman sudah membaik?" (ya/tidak)
- [ ] Bug report: shake phone → otomatis buka form feedback
- [ ] Screenshot otomatis saat report bug

---

### 5.13 🟡 Perlu Empty State yang Ramah

**Improvement**:
- [ ] Saat belum ada scan: ilustrasi + "Yuk, foto tanaman pertama Anda! 📸"
- [ ] Saat belum ada lahan: "Tambah lahan dulu yuk, biar Agrotani bisa bantu lebih baik"
- [ ] Saat chat kosong: beberapa pertanyaan populer yang bisa di-tap langsung

---

## 6. 💼 Improvement Bisnis & Go-to-Market

### 6.1 🟠 Go-to-Market Strategy Belum Ada

**Yang harus ditambahkan**:
- [ ] **Channel Akuisisi**:
  1. Kerjasama dengan Kelompok Tani — demo langsung di lapangan
  2. Partnership dengan toko pertanian — QR code di toko
  3. YouTube channel — konten edukasi pertanian + promo app
  4. WhatsApp group forwarding — viral di grup tani
  5. Radio pedesaan — masih efektif di banyak daerah
- [ ] **First 100 Users Strategy**: 
  - Pilih 1 desa binaan, datangi langsung
  - Onboard satu per satu, bantu install & ajarkan
  - Kumpulkan feedback intensif
- [ ] **Pilot Area Selection**:
  - Pilih daerah dengan: koneksi internet cukup, ada penyuluh aktif, tanaman monokultur (lebih mudah test akurasi AI)
  - Rekomendasi: sentra padi Jawa Barat (Karawang, Subang, Indramayu)

---

### 6.2 🟠 Pricing Terlalu Mahal untuk Petani Kecil

**Masalah**: Rp 29.900/bulan itu besar untuk petani kecil yang pendapatan Rp 1-3 juta/bulan.

**Improvement**:
- [ ] **Revisi pricing**:
  ```
  GRATIS        : 10 scan/bulan (bukan 5), unlimited chat basic
  PETANI        : Rp 9.900/bulan — unlimited scan, advanced features
  KELOMPOK TANI : Rp 49.900/bulan — per kelompok (10 anggota), shared dashboard
  ENTERPRISE    : Custom — agribisnis, dinas pertanian
  ```
- [ ] Model per-musim: Rp 29.900/musim tanam (4 bulan) bukan per bulan
- [ ] Subsidi dari partnership dengan produsen pupuk/pestisida
- [ ] Free forever untuk petani subsisten (< 0.5 hektar)

---

### 6.3 🟠 Partnership Strategy Belum Detail

**Yang harus ditambahkan**:
- [ ] **Tier 1 — Produsen Pupuk/Pestisida** (Syngenta, BASF, Petrokimia Gresik):
  - Mereka bayar untuk product placement di rekomendasi
  - Data analytics: berapa banyak petani yang di-recommend produk mereka
  - Win-win: petani dapat rekomendasi akurat, produsen dapat channel distribusi
- [ ] **Tier 2 — Pemerintah/Dinas Pertanian**:
  - Data outbreak penyakit real-time (anonymized)
  - Dashboard monitoring wilayah
  - Channel distribusi info subsidi ke petani
- [ ] **Tier 3 — Institusi Akademik** (IPB, UGM, UNPAD):
  - Kolaborasi riset
  - Akses data untuk jurnal
  - Mahasiswa sebagai crowd-validator diagnosis
- [ ] **Tier 4 — Fintech Pertanian** (TaniFund, iGrow):
  - Data produksi petani untuk credit scoring
  - Integrasi pinjaman modal di app

---

### 6.4 🟠 Competitive Analysis Belum Ada

**Yang harus ditambahkan**:
- [ ] Analisis kompetitor:

| Kompetitor | Kelebihan | Kekurangan | Posisi Agrotani |
|------------|-----------|------------|-----------------|
| Plantix | AI diagnosis, global | Tidak localized Indonesia, UI complex | Localized + FarmerBot + urgency system |
| LISA (IPB) | Research-backed | Terbatas padi, bukan produk consumer | Lebih banyak tanaman, UX lebih baik |
| iCrop | Government-backed | Bukan AI, data entry manual | AI-powered, lebih engaging |
| TaniHub | Marketplace, established | Fokus commerce bukan diagnosis | Fokus diagnosis → upsell ke marketplace |

---

### 6.5 🟡 Unit Economics Terlalu Optimis

**Improvement**:
- [ ] Hitung ulang dengan asumsi konservatif:
  - Customer Acquisition Cost (CAC): field marketing di pedesaan itu mahal (transport, waktu)
  - Churn rate: petani mungkin cuma pakai saat musim tanam (4 bulan/tahun)
  - Gemini API cost akan naik seiring usage
- [ ] Break-even analysis: berapa user berbayar dibutuhkan untuk break even?
- [ ] Runway calculation: dengan dana X, bisa bertahan berapa bulan?

---

### 6.6 🟡 Investor Pitch Deck Belum Ada

**Yang harus ditambahkan**:
- [ ] Buat dokumen terpisah: `pitch_deck.md` atau presentasi
- [ ] Highlight: TAM/SAM/SOM, unit economics, competitive moat, team
- [ ] Competitive moat Agrotani: localized knowledge base Indonesia + WhatsApp integration + kelompok tani integration

---

### 6.7 🟡 Content Strategy Belum Ada

**Yang harus ditambahkan**:
- [ ] Blog/artikel pertanian (SEO untuk web)
- [ ] YouTube shorts — "Tips Petani 60 Detik"
- [ ] Instagram / TikTok — visual before/after treatment
- [ ] Content calendar: konten seasonal sesuai musim tanam

---

### 6.8 🟡 Support Strategy Belum Jelas

**Yang harus ditambahkan**:
- [ ] Bagaimana petani menghubungi support jika ada masalah?
- [ ] In-app support chat atau lewat WhatsApp?
- [ ] FAQ section di app (offline-accessible)
- [ ] Community-based support: petani senior bantu petani baru

---

### 6.9 🟡 Metrics Perlu Tambahan

**Yang harus ditambahkan**:
- [ ] **Outcome metrics** (bukan cuma usage metrics):
  - Berapa persen petani yang treatment-nya berhasil?
  - Berapa peningkatan hasil panen setelah pakai Agrotani?
  - Berapa pengurangan biaya pestisida?
  - Berapa cepat waktu response dibanding tanpa Agrotani?
- [ ] Ini yang convince investor dan pemerintah

---

### 6.10 🟡 Legal Entity & Perizinan

**Yang harus ditambahkan**:
- [ ] Bentuk badan hukum: PT atau CV?
- [ ] Izin Kominfo untuk aplikasi yang memproses data pribadi
- [ ] Terms of Service yang melindungi dari liability rekomendasi AI
- [ ] Asuransi profesional? (jika rekomendasi AI menyebabkan kerugian)

---

## 7. ⚠️ Risiko & Mitigasi

### 7.1 🔴 Risiko: AI Hallucination Menyebabkan Kerugian

**Skenario**: AI merekomendasikan pestisida yang salah → tanaman mati → petani rugi jutaan.

**Mitigasi**:
- [ ] Disclaimer wajib di setiap rekomendasi: "Hasil ini adalah rekomendasi AI, bukan pengganti konsultasi ahli"
- [ ] Validasi dosis terhadap database produk resmi sebelum ditampilkan
- [ ] Tombol "Tanya Ahli" selalu tersedia
- [ ] Log semua rekomendasi untuk audit trail
- [ ] Insurance / partnership dengan asosiasi petani untuk mitigasi risiko

---

### 7.2 🔴 Risiko: Ketergantungan pada Gemini API

**Skenario**: Google ubah harga Gemini 5x lipat, atau discontinue model tertentu.

**Mitigasi**:
- [ ] Abstraction layer: AI service tidak langsung call Gemini, tapi lewat interface
- [ ] Siapkan fallback ke model lain (Claude, Llama, dll)
- [ ] Negosiasi enterprise agreement dengan Google untuk pricing
- [ ] Long-term: fine-tune model open source (Llama 3) dengan data Indonesia

---

### 7.3 🔴 Risiko: Adopsi Rendah

**Skenario**: Petani tidak mau download app baru / tidak percaya AI.

**Mitigasi**:
- [ ] WhatsApp channel sebagai pintu masuk (zero barrier)
- [ ] Demo langsung di lapangan oleh penyuluh
- [ ] Success story dari petani lain (social proof)
- [ ] Mulai dari tokoh tani / ketua poktan (influencer lokal)
- [ ] Gratis tanpa batas untuk 6 bulan pertama (product-led growth)

---

### 7.4 🔴 Risiko: Kualitas Foto Petani Buruk

**Skenario**: Foto blur, gelap, sudut salah → diagnosis tidak akurat → user kecewa.

**Mitigasi**:
- [ ] Real-time camera quality check (sebelum foto diambil)
- [ ] Auto-reject foto yang tidak memenuhi standar + panduan retake
- [ ] "Smart flash" — suggest petani nyalakan flash jika gelap
- [ ] Contoh foto yang baik vs buruk di panduan scan
- [ ] AI tetap coba analisis + beri confidence rendah + saran foto ulang

---

### 7.5 🟠 Risiko: Koneksi Internet Tidak Stabil

**Mitigasi**:
- [ ] Offline diagnosis model (TFLite) untuk 10-20 penyakit paling umum
- [ ] Aggressive caching dan compression
- [ ] Retry mechanism dengan exponential backoff
- [ ] Graceful degradation: fitur tetap bekerja partial tanpa internet
- [ ] Download knowledge base saat WiFi untuk akses offline

---

### 7.6 🟠 Risiko: Abuse / Spam

**Skenario**: Orang iseng upload foto bukan tanaman, spam chat, dll.

**Mitigasi**:
- [ ] Image classifier: filter foto non-tanaman sebelum masuk AI pipeline
- [ ] Rate limiting yang ketat untuk free tier
- [ ] Report & block system
- [ ] CAPTCHA untuk registrasi (atau OTP sudah cukup)

---

### 7.7 🟠 Risiko: Data Privacy Breach

**Mitigasi**:
- [ ] Minimal data collection — hanya kumpulkan apa yang benar-benar dibutuhkan
- [ ] GPS hanya diambil saat scan (bukan tracking 24/7)
- [ ] Option untuk petani scan tanpa share lokasi
- [ ] Regular security audit
- [ ] Incident response plan jika terjadi breach

---

### 7.8 🟡 Risiko: Scaling Cost yang Tidak Terkontrol

**Mitigasi**:
- [ ] Cost monitoring dan alerting dari hari 1
- [ ] Budget cap per user per hari
- [ ] Cache agresif untuk reduce API calls
- [ ] Batasi fitur free tier secara realistis

---

### 7.9 🟡 Risiko: Kompetitor Established Masuk

**Mitigasi**:
- [ ] Build defensible moat: localized knowledge base, community, data network effect
- [ ] Move fast: get to market before competitors
- [ ] Partnership exclusive dengan poktan / dinas pertanian lokal
- [ ] Patent / IP protection untuk novel features (disease heatmap, urgency system)

---

## 8. 📋 Prioritas Eksekusi — Apa yang Harus Dikerjakan Duluan?

### Masalah Utama di Roadmap Saat Ini

README saat ini menargetkan terlalu banyak fitur di MVP. **Ini resep untuk gagal.**

### Rekomendasi: Ultra-Lean MVP

```
═══════════════════════════════════════════════════════════
  ULTRA-LEAN MVP (6 Minggu, 1-2 Developer)
═══════════════════════════════════════════════════════════

Minggu 1-2: Foundation
├── Flutter app boilerplate
├── Firebase Auth (phone + OTP)  
├── Single screen: Home + Camera
├── Cloud Functions untuk Gemini API call
└── Firebase Firestore untuk data

Minggu 3-4: Core Feature
├── Scan foto → kirim ke Gemini Vision → tampilkan diagnosis
├── Basic recommendation output
├── Scan history (Firestore)
└── Simple UI (bukan fancy, tapi fungsional)

Minggu 5-6: Polish & Launch
├── FarmerBot basic (Gemini chat)
├── Push notification (Firebase FCM)
├── UI polish
├── Field test dengan 10-20 petani nyata
└── Fix bugs dari field test

TIDAK TERMASUK di MVP:
✗ Microservices (pakai monolith)
✗ Kubernetes (pakai Cloud Run)
✗ Community forum
✗ Weather integration
✗ Crop calendar
✗ Analytics dashboard
✗ Marketplace
✗ IoT
✗ Multi-language
✗ Voice input/output
```

### Urutan Prioritas Setelah MVP

```
PRIORITY 1 (Bulan 2-3) — Validate & Improve Core
├── Improve AI accuracy berdasarkan user feedback
├── WhatsApp channel (biggest growth lever)
├── Offline basic support
├── Knowledge base: 50 penyakit utama (bukan 500)
└── Kumpulkan data: apa yang petani benar-benar butuhkan?

PRIORITY 2 (Bulan 4-6) — Engagement & Growth
├── Smart Urgency System
├── Weather integration
├── Buku Tani Digital (basic)
├── Kelompok Tani feature
├── Gamifikasi & referral
└── Target: 1,000 pengguna

PRIORITY 3 (Bulan 7-9) — Monetization & Scale
├── Premium tier launch
├── Partnership dengan produsen pupuk
├── Disease heatmap
├── Crop calendar
├── Voice input
└── Target: 10,000 pengguna

PRIORITY 4 (Bulan 10-12) — Ecosystem
├── Marketplace integration
├── Subsidi info integration
├── Enterprise dashboard
├── Multi-language
├── IoT exploration
└── Target: 50,000 pengguna
```

---

## 🎯 Kesimpulan Review

### 3 Hal yang Paling Kritis untuk Diperbaiki

| # | Item | Mengapa Kritis | Effort |
|---|------|----------------|--------|
| 1 | **Simplify arsitektur MVP** | Arsitektur saat ini terlalu complex → development akan lambat, biaya tinggi, team overwhelmed | Redesign dokumen |
| 2 | **Strategi offline & WhatsApp** | Tanpa ini, 70% target user tidak bisa pakai app | Medium |
| 3 | **Knowledge base & data pipeline** | Tanpa data penyakit yang valid, AI tidak berguna → garbage in garbage out | High |

### 3 Fitur Baru yang Paling Berdampak

| # | Fitur | Mengapa Berdampak | Effort |
|---|-------|-------------------|--------|
| 1 | **WhatsApp Integration** | Zero barrier, 95% petani sudah pakai WA, bisa jadi viral channel | Medium |
| 2 | **Mode Super Simple** | Unlock adopsi untuk petani literasi digital rendah (mayoritas target) | Low |
| 3 | **Kelompok Tani Integration** | Network effect, social proof, bulk adoption via komunitas existing | Medium |

### Rekomendasi Terakhir

> **Jangan bangun pesawat sebelum bisa bikin layang-layang yang terbang.**
>
> README saat ini mendesain pesawat Boeing 787. Yang dibutuhkan sekarang adalah layang-layang yang bisa terbang — aplikasi sederhana yang petani **benar-benar pakai** dan **benar-benar terbantu**. Setelah itu baru iterasi dan scale.
>
> Start small. Ship fast. Learn from real farmers. Iterate.

---

*Review ini dibuat untuk memastikan Agrotani tidak hanya jadi dokumen indah, tapi benar-benar menjadi produk yang membantu petani Indonesia.*
