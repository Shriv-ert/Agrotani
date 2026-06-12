<p align="center">
  <img src="docs/assets/agrotani-logo-placeholder.png" alt="Agrotani Logo" width="200"/>
</p>

<h1 align="center">🌾 AGROTANI — Smart Farming AI Assistant</h1>

<p align="center">
  <em>Platform Cerdas Berbasis AI untuk Membantu Petani Indonesia Mendeteksi Penyakit Tanaman, Mendapatkan Diagnosis Akurat, Rekomendasi Tindakan, dan Konsultasi Pertanian Real-Time</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Mobile%20%7C%20Web-brightgreen" alt="Platform"/>
  <img src="https://img.shields.io/badge/AI%20Engine-Google%20Gemini-blue" alt="AI Engine"/>
  <img src="https://img.shields.io/badge/Status-In%20Development-orange" alt="Status"/>
  <img src="https://img.shields.io/badge/License-MIT-yellow" alt="License"/>
  <img src="https://img.shields.io/badge/Language-Bahasa%20Indonesia-red" alt="Language"/>
</p>

---

## 📋 Daftar Isi

1. [Ringkasan Eksekutif](#-ringkasan-eksekutif)
2. [Latar Belakang & Masalah](#-latar-belakang--masalah)
3. [Visi & Misi](#-visi--misi)
4. [Target Pengguna](#-target-pengguna)
5. [Fitur Utama](#-fitur-utama)
   - [Plant Scanner (Pemindai Tanaman)](#1-plant-scanner--pemindai-tanaman)
   - [AI Diagnosis Engine](#2-ai-diagnosis-engine)
   - [AI Recommendation System](#3-ai-recommendation-system)
   - [Smart Urgency System](#4-smart-urgency-system)
   - [FarmerBot — Chatbot Petani](#5-farmerbot--chatbot-petani)
6. [Fitur Tambahan & Rekomendasi](#-fitur-tambahan--rekomendasi)
7. [Arsitektur Sistem](#-arsitektur-sistem)
   - [High-Level Architecture](#high-level-architecture)
   - [Backend Architecture](#backend-architecture)
   - [AI/ML Pipeline](#aiml-pipeline)
   - [Database Schema](#database-schema)
   - [API Design](#api-design)
8. [Desain UI/UX](#-desain-uiux)
   - [Design Philosophy](#design-philosophy)
   - [Screen Flow & Wireframes](#screen-flow--wireframes)
   - [Component Library](#component-library)
9. [AI & Prompt Engineering Strategy](#-ai--prompt-engineering-strategy)
   - [Gemini Integration Architecture](#gemini-integration-architecture)
   - [Prompt Templates](#prompt-templates)
   - [Context Management](#context-management)
   - [Response Formatting](#response-formatting)
10. [Tech Stack](#-tech-stack)
11. [Alur Kerja Pengguna (User Flow)](#-alur-kerja-pengguna-user-flow)
12. [Deployment & Infrastructure](#-deployment--infrastructure)
13. [Keamanan & Privasi](#-keamanan--privasi)
14. [Roadmap Pengembangan](#-roadmap-pengembangan)
15. [Monetisasi & Bisnis Model](#-monetisasi--bisnis-model)
16. [Metrik & KPI](#-metrik--kpi)
17. [Tim & Kontribusi](#-tim--kontribusi)
18. [FAQ](#-faq)
19. [Lisensi](#-lisensi)

---

## 🎯 Ringkasan Eksekutif

**Agrotani** adalah platform cerdas berbasis AI yang dirancang khusus untuk petani Indonesia. Platform ini mengintegrasikan teknologi **Google Gemini LLM** dengan **computer vision** dan **knowledge base pertanian** untuk memberikan solusi end-to-end bagi permasalahan pertanian — mulai dari deteksi penyakit tanaman, diagnosis kondisi lahan, rekomendasi tindakan, hingga konsultasi pertanian interaktif.

### Mengapa Agrotani?

| Aspek | Kondisi Saat Ini | Solusi Agrotani |
|-------|-------------------|-----------------|
| Deteksi Penyakit | Petani mengandalkan pengalaman atau menunggu petugas PPL datang | Scan foto tanaman → hasil diagnosis instan < 10 detik |
| Konsultasi | Harus pergi ke dinas pertanian atau menunggu penyuluh | Chatbot AI 24/7 dalam Bahasa Indonesia |
| Rekomendasi Pupuk | Trial & error, sering salah dosis | Rekomendasi presisi berdasarkan kondisi tanaman + tanah + cuaca |
| Peringatan Dini | Tidak ada sistem peringatan; kerugian baru diketahui saat panen | Smart Urgency System dengan notifikasi proaktif |
| Pencatatan | Manual di buku/kertas, sering hilang | Digital farm journal otomatis |

### Value Proposition

```
"Setiap petani mendapat akses ke pengetahuan ahli pertanian,
 kapan saja, di mana saja, hanya dengan smartphone."
```

---

## 🌍 Latar Belakang & Masalah

### Kondisi Pertanian Indonesia

Indonesia adalah negara agraris dengan **lebih dari 33 juta petani** (BPS, 2023). Namun, sektor pertanian menghadapi berbagai tantangan kritis:

1. **Kehilangan Hasil Panen akibat Penyakit Tanaman**
   - Rata-rata **20-40% hasil panen** hilang karena serangan hama dan penyakit yang terlambat ditangani
   - Petani sering tidak mampu mengidentifikasi jenis penyakit secara akurat
   - Keterlambatan penanganan 3-5 hari bisa berarti kehilangan seluruh lahan

2. **Keterbatasan Akses ke Ahli Pertanian**
   - Rasio penyuluh pertanian terhadap petani sangat timpang: **1 penyuluh : 800+ petani**
   - Banyak daerah terpencil yang tidak terjangkau oleh petugas penyuluh
   - Waktu respons yang lambat, sering kali berhari-hari

3. **Penggunaan Pestisida & Pupuk yang Tidak Tepat**
   - Penggunaan berlebihan yang merusak lingkungan dan kesehatan
   - Biaya produksi membengkak karena pemborosan bahan
   - Residu kimia pada hasil panen yang membahayakan konsumen

4. **Kurangnya Literasi Digital di Kalangan Petani**
   - Mayoritas petani berusia 40+ tahun dengan literasi digital rendah
   - Aplikasi pertanian yang ada terlalu kompleks dan tidak user-friendly
   - Bahasa interface sering menggunakan istilah teknis yang tidak dipahami

5. **Perubahan Iklim & Ketidakpastian Cuaca**
   - Pola tanam tradisional tidak lagi relevan
   - Serangan hama dan penyakit muncul di luar musim
   - Petani membutuhkan adaptasi real-time yang tidak tersedia

### Pain Points Utama Petani

```
🔴 CRITICAL    : "Tanaman saya tiba-tiba menguning, saya tidak tahu ini penyakit apa"
🟠 HIGH        : "Saya tidak tahu harus kasih pupuk apa dan berapa dosisnya"
🟡 MEDIUM      : "Kapan waktu yang tepat untuk menyemprot pestisida?"
🔵 INFORMATIVE : "Tanaman apa yang cocok untuk musim ini di daerah saya?"
```

---

## 🚀 Visi & Misi

### Visi

> *"Menjadi platform AI pertanian #1 di Indonesia yang memberdayakan setiap petani dengan teknologi cerdas untuk meningkatkan produktivitas, mengurangi kerugian, dan memajukan kesejahteraan petani."*

### Misi

1. **Demokratisasi Pengetahuan Pertanian** — Membuat pengetahuan ahli pertanian dapat diakses oleh siapa saja melalui teknologi AI
2. **Pencegahan Lebih Baik dari Pengobatan** — Memberikan sistem peringatan dini yang proaktif untuk mencegah kerugian besar
3. **Pertanian Presisi yang Terjangkau** — Menghadirkan precision farming yang selama ini hanya dinikmati pertanian skala besar ke petani kecil
4. **Keberlanjutan Lingkungan** — Mengurangi penggunaan bahan kimia berlebihan melalui rekomendasi yang tepat sasaran
5. **Inklusivitas** — Merancang aplikasi yang dapat digunakan oleh petani dari berbagai latar belakang literasi digital

---

## 👥 Target Pengguna

### Persona Utama

#### 1. Pak Harto — Petani Padi Tradisional (55 tahun)
```
📱 Device     : Smartphone Android murah (RAM 2-3 GB)
🌐 Internet   : Koneksi tidak stabil, sering offline
📚 Literasi   : Dasar — bisa WhatsApp, YouTube
🌾 Kebutuhan  : Deteksi penyakit padi, rekomendasi pupuk sederhana
💡 Harapan    : "Saya ingin tahu tanaman saya kenapa dan harus ngapain"
```

#### 2. Mbak Sari — Petani Muda Hortikultura (28 tahun)
```
📱 Device     : Smartphone Android mid-range
🌐 Internet   : Koneksi stabil, familiar dengan apps
📚 Literasi   : Menengah — bisa mengoperasikan berbagai aplikasi
🌾 Kebutuhan  : Manajemen kebun sayur, optimasi hasil panen
💡 Harapan    : "Saya ingin tahu cara meningkatkan kualitas dan kuantitas panen"
```

#### 3. Mas Budi — Pemilik Usaha Pertanian Skala Menengah (35 tahun)
```
📱 Device     : Smartphone Android flagship / iOS
🌐 Internet   : Koneksi stabil, multi-device
📚 Literasi   : Tinggi — terbiasa dengan dashboard dan analytics
🌾 Kebutuhan  : Monitoring multi-lahan, analisis ROI, pelaporan
💡 Harapan    : "Saya butuh data dan analytics untuk scaling bisnis pertanian saya"
```

### Persona Sekunder

| Persona | Kebutuhan | Fitur Utama |
|---------|-----------|-------------|
| Penyuluh Pertanian | Monitoring kesehatan tanaman di wilayah binaan | Dashboard multi-petani, laporan area |
| Mahasiswa Pertanian | Referensi belajar dan riset | Knowledge base, histori diagnosis |
| Toko Pertanian | Rekomendasi produk yang tepat untuk pelanggan | Integrasi katalog produk |
| Dinas Pertanian | Data persebaran penyakit tanaman | Heatmap & analytics regional |

---

## 🔧 Fitur Utama

### 1. Plant Scanner — Pemindai Tanaman

#### Deskripsi
Fitur inti Agrotani yang memungkinkan petani memfoto tanaman yang bermasalah menggunakan kamera smartphone. Sistem kemudian menganalisis gambar menggunakan **Gemini Vision API** untuk mengidentifikasi penyakit, hama, defisiensi nutrisi, atau kondisi abnormal lainnya.

#### Alur Kerja Detail

```
┌──────────────┐     ┌───────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   📷 Ambil   │────▶│  🔍 Pre-      │────▶│  🤖 Gemini       │────▶│  📊 Hasil        │
│   Foto       │     │  Processing   │     │  Vision API      │     │  Analisis        │
│   Tanaman    │     │  & Validasi   │     │  + Context       │     │  + Confidence    │
└──────────────┘     └───────────────┘     └──────────────────┘     └──────────────────┘
       │                     │                      │                        │
       ▼                     ▼                      ▼                        ▼
  • Camera native       • Cek kualitas         • Prompt engineering     • Nama penyakit
  • Gallery upload        gambar                 dengan context         • Tingkat keparahan
  • Multi-angle         • Crop & enhance         pertanian             • Visual indicator
    capture             • Validasi: apakah      • Multi-modal           • Confidence score
                          ini tanaman?            analysis               • Next steps
```

#### Spesifikasi Teknis

| Parameter | Spesifikasi |
|-----------|-------------|
| Format Gambar | JPEG, PNG, WebP |
| Resolusi Minimum | 640 x 480 px |
| Resolusi Maksimum | 4096 x 4096 px |
| Ukuran File Maks | 10 MB |
| Waktu Proses | < 10 detik (target) |
| Mode Offline | Caching hasil sebelumnya, queue untuk sync |
| Multi-foto | Mendukung hingga 5 foto per sesi scan |

#### Fitur Scanner Lanjutan

1. **Smart Capture Guide**
   - Overlay guide di kamera untuk memastikan foto yang diambil optimal
   - Deteksi otomatis apakah pencahayaan cukup
   - Saran: "Dekatkan kamera ke bagian daun yang bermasalah"

2. **Multi-Angle Scan**
   - Petani bisa mengambil beberapa foto dari sudut berbeda
   - Sistem menggabungkan informasi dari semua foto untuk diagnosis lebih akurat
   - Mendukung foto daun (atas/bawah), batang, buah, dan akar

3. **Historical Comparison**
   - Bandingkan foto hari ini dengan foto sebelumnya
   - Tracking perkembangan penyakit dari waktu ke waktu
   - Grafik visual progress kondisi tanaman

4. **Scan Tanah (Future Feature)**
   - Analisis warna dan tekstur tanah dari foto
   - Estimasi awal kondisi pH dan kelembaban
   - Rekomendasi apakah perlu tes lab

#### Pre-Processing Pipeline

```python
# Pseudocode: Image Pre-Processing Pipeline

class ImagePreProcessor:
    def process(self, image: Image) -> ProcessedImage:
        # Step 1: Validasi format dan ukuran
        self.validate_format(image)
        self.validate_size(image)
        
        # Step 2: Deteksi apakah gambar berisi tanaman
        is_plant = self.detect_plant_presence(image)
        if not is_plant:
            raise InvalidImageError("Gambar tidak terdeteksi sebagai tanaman")
        
        # Step 3: Auto-enhancement
        enhanced = self.auto_enhance(image)
        # - Brightness adjustment
        # - Contrast enhancement  
        # - Noise reduction
        
        # Step 4: Smart crop ke area yang relevan
        cropped = self.smart_crop(enhanced)
        
        # Step 5: Generate metadata
        metadata = {
            "capture_time": datetime.now(),
            "gps_location": self.get_gps(image),
            "weather_context": self.fetch_weather(gps),
            "device_info": self.get_device_info()
        }
        
        return ProcessedImage(cropped, metadata)
```

---

### 2. AI Diagnosis Engine

#### Deskripsi
Setelah gambar diproses oleh scanner, AI Diagnosis Engine akan menganalisis dan memberikan diagnosis lengkap tentang kondisi tanaman. Engine ini ditenagai oleh **Gemini LLM** yang di-augment dengan **knowledge base pertanian Indonesia** yang komprehensif.

#### Tingkat Diagnosis

```
┌─────────────────────────────────────────────────────────────────┐
│                    AI DIAGNOSIS ENGINE                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Level 1: IDENTIFIKASI                                         │
│  ├── Jenis penyakit/hama/defisiensi                            │
│  ├── Nama ilmiah dan nama lokal                                │
│  └── Confidence score (0-100%)                                  │
│                                                                 │
│  Level 2: ASSESSMENT                                           │
│  ├── Tingkat keparahan (Ringan/Sedang/Parah/Kritis)            │
│  ├── Stadium penyakit                                          │
│  ├── Area yang terinfeksi (estimasi %)                         │
│  └── Potensi penyebaran                                        │
│                                                                 │
│  Level 3: KONTEKS                                              │
│  ├── Penyebab umum (cuaca, hama, nutrisi, dll)                 │
│  ├── Faktor risiko di lokasi petani                            │
│  ├── Hubungan dengan penyakit lain                             │
│  └── Riwayat penyakit serupa di daerah tersebut                │
│                                                                 │
│  Level 4: PROGNOSIS                                            │
│  ├── Prediksi perkembangan jika tidak ditangani                │
│  ├── Estimasi dampak pada hasil panen                          │
│  ├── Timeline kritis                                           │
│  └── Kemungkinan penyebaran ke tanaman lain                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

#### Output Diagnosis — Contoh

```json
{
  "diagnosis": {
    "primary": {
      "name": "Blast (Blas)",
      "scientific_name": "Magnaporthe oryzae",
      "local_names": ["Blas", "Potong Leher"],
      "confidence": 87.5,
      "category": "Penyakit Jamur"
    },
    "differential_diagnosis": [
      {
        "name": "Bercak Coklat (Brown Spot)",
        "confidence": 12.3
      }
    ],
    "severity": {
      "level": "SEDANG",
      "scale": 6,
      "max_scale": 10,
      "infected_area_percent": 35,
      "description": "Penyakit sudah menyebar ke sekitar 35% area daun. Perlu penanganan segera dalam 2-3 hari ke depan."
    },
    "prognosis": {
      "without_treatment": "Dalam 5-7 hari, penyakit dapat menyebar ke 70% area dan menyebabkan gagal panen pada petak ini.",
      "with_treatment": "Dengan penanganan tepat, penyakit dapat ditekan dan hasil panen masih bisa diselamatkan 60-80%.",
      "spread_risk": "TINGGI - dapat menyebar ke petak tetangga melalui angin dan air",
      "critical_window_hours": 72
    }
  }
}
```

#### Sistem Scoring Keparahan

| Skor | Level | Warna | Deskripsi | Urgensi Tindakan |
|------|-------|-------|-----------|------------------|
| 1-2 | Sangat Ringan | 🟢 Hijau | Gejala awal, hampir tidak terlihat | Monitoring rutin |
| 3-4 | Ringan | 🟡 Kuning | Gejala terlihat di beberapa daun | Tindakan preventif dalam 1 minggu |
| 5-6 | Sedang | 🟠 Oranye | Menyebar ke 30-50% area | Tindakan kuratif dalam 2-3 hari |
| 7-8 | Parah | 🔴 Merah | Menyebar luas, 50-80% area | Tindakan darurat dalam 24 jam |
| 9-10 | Kritis | ⚫ Hitam | Kerusakan masif, > 80% area | Evaluasi total, mungkin perlu replanting |

---

### 3. AI Recommendation System

#### Deskripsi
Berdasarkan hasil diagnosis, sistem ini memberikan **rekomendasi tindakan yang spesifik, actionable, dan kontekstual** — disesuaikan dengan kondisi petani, lokasi, musim, dan ketersediaan sumber daya.

#### Kategori Rekomendasi

```
┌─────────────────────────────────────────────────────┐
│           AI RECOMMENDATION SYSTEM                  │
├─────────────────────────────────────────────────────┤
│                                                     │
│  🧪 KIMIAWI (Chemical)                              │
│  ├── Fungisida / Insektisida / Herbisida            │
│  ├── Nama produk spesifik yang tersedia lokal       │
│  ├── Dosis yang tepat per tangki/hektar             │
│  ├── Cara aplikasi (semprot, tabur, rendam)         │
│  ├── Jadwal aplikasi                                │
│  └── ⚠️ Peringatan: masa tunggu panen              │
│                                                     │
│  🌱 ORGANIK (Organic)                               │
│  ├── Pestisida nabati (DIY dari bahan lokal)        │
│  ├── Agen biologis (trichoderma, beauveria, dll)    │
│  ├── Cara pembuatan step-by-step                    │
│  └── Kelebihan & kekurangan vs kimiawi              │
│                                                     │
│  🔧 KULTURAL (Cultural Practice)                    │
│  ├── Perbaikan drainase / irigasi                   │
│  ├── Pengaturan jarak tanam                         │
│  ├── Rotasi tanaman                                 │
│  ├── Sanitasi lahan                                 │
│  └── Pemangkasan                                    │
│                                                     │
│  🌡️ NUTRISI (Nutrition)                             │
│  ├── Pupuk yang dibutuhkan (N, P, K, mikro)         │
│  ├── Dosis per hektar / per pohon                   │
│  ├── Metode pemupukan                               │
│  └── Jadwal pemupukan optimal                       │
│                                                     │
│  🛡️ PREVENTIF (Prevention)                          │
│  ├── Tindakan pencegahan untuk musim depan          │
│  ├── Varietas tahan penyakit                        │
│  ├── Perlakuan benih                                │
│  └── Kalender perlindungan tanaman                  │
│                                                     │
└─────────────────────────────────────────────────────┘
```

#### Contoh Output Rekomendasi

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 REKOMENDASI TINDAKAN — Blast Padi (Sedang)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ⏰ TINDAKAN SEGERA (dalam 24-48 jam):

  1. Semprotkan fungisida berbahan aktif Trisiklazol
     💊 Produk: Beam 75 WP atau Nativo
     📏 Dosis: 1.5 gram per liter air
     💧 Volume semprot: 400-600 liter/hektar
     🕐 Waktu: Pagi hari (06:00-09:00) saat tidak hujan
     ⚠️ Gunakan APD (masker, sarung tangan)

  2. Kurangi pemberian pupuk Nitrogen (Urea)
     📏 Kurangi 50% dari dosis normal
     📝 Kelebihan N meningkatkan kerentanan blast

  3. Atur air sawah
     💧 Pertahankan genangan 3-5 cm
     🚫 Jangan biarkan sawah kering

  ─────────────────────────────────────────────────

  🌱 ALTERNATIF ORGANIK:

  1. Buat larutan pestisida nabati:
     • 250 gram bawang putih, haluskan
     • Rendam dalam 1 liter air selama 24 jam
     • Saring, tambahkan 5 ml sabun cair
     • Semprotkan ke tanaman yang terinfeksi

  ─────────────────────────────────────────────────

  📅 JADWAL TINDAK LANJUT:
  • Hari ke-3  : Evaluasi perkembangan gejala
  • Hari ke-7  : Semprot ulang jika gejala masih ada
  • Hari ke-14 : Scan ulang untuk monitoring
  • Hari ke-21 : Evaluasi hasil penanganan

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### Fitur Rekomendasi Cerdas

1. **Context-Aware Recommendations**
   - Menyesuaikan dengan musim dan cuaca saat ini
   - Mempertimbangkan riwayat tanaman dan lahan petani
   - Mengecek ketersediaan produk di toko pertanian terdekat

2. **Budget-Aware Suggestions**
   - Memberikan opsi dari yang termurah sampai paling efektif
   - Estimasi biaya per hektar
   - ROI calculation: biaya penanganan vs potensi kerugian

3. **Eco-Friendly Rating**
   - Setiap rekomendasi diberi rating dampak lingkungan
   - Prioritas pada solusi organik dan ramah lingkungan
   - Label khusus untuk rekomendasi yang aman untuk pertanian organik

---

### 4. Smart Urgency System

#### Deskripsi
Sistem peringatan dini cerdas yang secara proaktif memberitahu petani tentang **tingkat urgensi masalah** dan **timeline kritis** untuk mengambil tindakan. Sistem ini tidak menunggu petani bertanya — ia aktif memberikan notifikasi.

#### Mekanisme Kerja

```
┌─────────────────────────────────────────────────────────────────┐
│                  SMART URGENCY SYSTEM                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  INPUT:                                                        │
│  ├── Hasil diagnosis terbaru                                   │
│  ├── Data cuaca real-time & forecast                           │
│  ├── Riwayat scan petani                                       │
│  ├── Data penyakit di area sekitar                             │
│  ├── Kalender tanam & fase pertumbuhan                         │
│  └── Kondisi lingkungan (kelembaban, suhu)                     │
│                                                                 │
│  PROSES:                                                       │
│  ├── Risk assessment model                                     │
│  ├── Spread prediction algorithm                               │
│  ├── Weather impact analysis                                   │
│  └── Historical pattern matching                               │
│                                                                 │
│  OUTPUT:                                                       │
│  ├── 🚨 Alert level (INFO / WARNING / URGENT / CRITICAL)      │
│  ├── ⏰ Time window untuk tindakan                             │
│  ├── 📊 Prediksi penyebaran                                   │
│  ├── 📱 Push notification ke petani                            │
│  └── 📍 Area impact map                                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

#### Tingkat Alert

```
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║  🟢 INFO                                                     ║
║  "Tanaman Anda terlihat sehat. Lakukan scan rutin            ║
║   7 hari lagi untuk monitoring."                             ║
║  ➤ Tidak perlu tindakan khusus                              ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  🟡 WARNING                                                  ║
║  "Terdeteksi gejala awal [Nama Penyakit] pada tanaman Anda. ║
║   Masih tahap ringan. Lakukan penanganan dalam 5-7 hari."   ║
║  ➤ Rekomendasi tindakan preventif                           ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  🟠 URGENT                                                   ║
║  "Penyakit [Nama] sudah pada tahap sedang dan diprediksi     ║
║   akan menyebar ke 70% lahan dalam 3 hari. Segera lakukan   ║
║   penanganan!"                                               ║
║  ➤ Notifikasi berulang + rekomendasi tindakan kuratif       ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  🔴 CRITICAL                                                 ║
║  "⚠️ DARURAT! Hujan lebat 3 hari berturut-turut akan        ║
║   mempercepat penyebaran [penyakit] di lahan Anda.          ║
║   Tindakan HARUS diambil HARI INI."                         ║
║  ➤ Notifikasi prioritas + panduan darurat step-by-step      ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

#### Skenario Smart Urgency

**Skenario 1: Prediksi Penyebaran Penyakit**
```
📅 Hari 1  : Petani scan → Blast ringan terdeteksi (skor 3/10)
📊 Analisis: Cuaca minggu depan = hujan + kelembaban tinggi
🤖 Prediksi: Jika tidak ditangani, penyakit akan meningkat ke skor 7/10
             dalam 5 hari karena kondisi cuaca mendukung penyebaran
📱 Alert   : URGENT — "Kondisi cuaca akan memperburuk penyakit blast.
             Segera lakukan penyemprotan fungisida sebelum musim hujan 
             dimulai (dalam 2 hari)."
```

**Skenario 2: Area-Wide Alert**
```
📊 Data    : 15 petani di Kecamatan X melaporkan gejala serupa
🤖 Analisis: Kemungkinan outbreak penyakit di area tersebut
📱 Alert   : BROADCAST — "Perhatian petani di Kecamatan X!
             Terdeteksi outbreak [penyakit] di area Anda.
             Lakukan pengecekan tanaman dan langkah preventif segera."
```

**Skenario 3: Reminder Tindak Lanjut**
```
📅 Hari 1  : Petani mendapat rekomendasi semprot fungisida
📅 Hari 3  : 📱 "Hari ini jadwal evaluasi pasca-penyemprotan.
             Apakah gejala sudah berkurang? Scan ulang tanaman Anda."
📅 Hari 7  : 📱 "Jadwal penyemprotan kedua jika diperlukan.
             Bagaimana kondisi tanaman Anda?"
```

---

### 5. FarmerBot — Chatbot Petani

#### Deskripsi
Asisten virtual AI yang bisa diajak "ngobrol" layaknya konsultasi dengan ahli pertanian. FarmerBot memahami **Bahasa Indonesia sehari-hari** (termasuk bahasa daerah dasar) dan menjawab dalam bahasa yang mudah dipahami petani.

#### Kemampuan FarmerBot

```
┌─────────────────────────────────────────────────────────────────┐
│                      🤖 FARMERBOT                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  💬 Tanya Jawab Umum                                           │
│  ├── "Pupuk apa yang cocok untuk padi umur 30 hari?"           │
│  ├── "Kapan waktu yang tepat untuk panen jagung?"              │
│  ├── "Berapa jarak tanam ideal untuk cabai?"                   │
│  └── "Kenapa daun tomat saya menggulung?"                      │
│                                                                 │
│  📊 Analisis & Konsultasi                                      │
│  ├── Konsultasi lanjutan dari hasil scan                       │
│  ├── Perbandingan produk pupuk/pestisida                       │
│  ├── Kalkulasi kebutuhan bahan per luas lahan                  │
│  └── Analisis biaya produksi                                   │
│                                                                 │
│  📅 Perencanaan                                                │
│  ├── Jadwal tanam berdasarkan musim & lokasi                   │
│  ├── Rekomendasi tanaman berdasarkan kondisi tanah             │
│  ├── Kalender pemupukan & perawatan                            │
│  └── Estimasi hasil panen                                      │
│                                                                 │
│  🏪 Informasi Pasar                                            │
│  ├── Harga komoditas terkini                                   │
│  ├── Tren pasar untuk perencanaan tanam                        │
│  ├── Info toko pertanian terdekat                              │
│  └── Program bantuan pemerintah                                │
│                                                                 │
│  🌤️ Informasi Cuaca                                            │
│  ├── Prakiraan cuaca untuk lokasi petani                       │
│  ├── Rekomendasi aktivitas berdasarkan cuaca                   │
│  ├── Peringatan cuaca ekstrem                                  │
│  └── Kalender musim tanam                                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

#### Contoh Percakapan FarmerBot

```
👨‍🌾 Petani  : "Bot, tanaman padi saya kok daunnya ada bercak coklat ya?"

🤖 FarmerBot: "Wah, bercak coklat di daun padi bisa disebabkan beberapa hal, Pak.
              Biar saya bantu lebih akurat, coba fotokan daunnya ya!
              
              Tapi dari deskripsi Bapak, kemungkinan bisa:
              
              1. Brown Spot (Bercak Coklat) — biasanya bercak oval berwarna 
                 coklat dengan tepi kuning
              2. Blast — bercak berbentuk belah ketupat dengan ujung lancip
              3. Kekurangan Kalium — daun menguning dari ujung
              
              Apakah Bapak mau foto daunnya supaya saya bisa kasih 
              diagnosis yang lebih pasti? 📸"

👨‍🌾 Petani  : "Iya bot, ini saya foto ya"
              [Mengirim foto]

🤖 FarmerBot: "Terima kasih fotonya, Pak! 🔍
              
              Dari analisis foto, tanaman Bapak kemungkinan besar kena
              Brown Spot (Bercak Coklat) dengan tingkat keparahan SEDANG.
              
              Penyebabnya biasanya karena:
              • Kekurangan unsur Kalium (K)
              • Kelembaban tinggi
              • Benih yang kurang sehat
              
              Apa Bapak mau saya kasih rekomendasi penanganannya? 💡"

👨‍🌾 Petani  : "Iya bot, kasih tau caranya"

🤖 FarmerBot: "Baik Pak, ini yang perlu dilakukan:
              
              ✅ LANGKAH 1 (Hari ini):
              Semprotkan fungisida berbahan aktif Mancozeb 
              Dosis: 2 gram per liter air
              Waktu: pagi hari sebelum jam 9
              
              ✅ LANGKAH 2 (Besok):
              Tambahkan pupuk KCl (Kalium)
              Dosis: 50 kg per hektar
              Caranya: ditabur merata
              
              ✅ LANGKAH 3 (3 hari lagi):
              Scan ulang tanaman untuk lihat perkembangan
              
              ⚠️ PENTING:
              Pakai masker dan sarung tangan saat menyemprot ya Pak!
              
              Ada yang mau ditanyakan lagi? 😊"
```

#### Fitur FarmerBot Lanjutan

1. **Voice Input & Output** (Rencana Pengembangan)
   - Petani bisa bertanya dengan suara (Speech-to-Text)
   - Jawaban bisa didengarkan (Text-to-Speech) dalam Bahasa Indonesia
   - Sangat berguna untuk petani yang kurang nyaman mengetik

2. **Contextual Memory**
   - FarmerBot mengingat tanaman apa yang ditanam petani
   - Mengingat riwayat masalah dan solusi sebelumnya
   - Memberikan saran yang lebih personal seiring waktu

3. **Quick Reply Buttons**
   - Tombol cepat untuk pertanyaan umum
   - Mengurangi kebutuhan mengetik
   - Contoh: "🌾 Jadwal Pupuk" | "🐛 Ada Hama" | "📷 Scan Tanaman"

4. **Multi-Language Support** (Rencana Pengembangan)
   - Bahasa Indonesia (utama)
   - Bahasa Jawa, Sunda, Madura (bertahap)
   - Bahasa sederhana / informal yang natural bagi petani

---

## ✨ Fitur Tambahan & Rekomendasi

### 6. Digital Farm Journal (Buku Tani Digital)

```
┌──────────────────────────────────────────────┐
│         📓 BUKU TANI DIGITAL                 │
├──────────────────────────────────────────────┤
│                                              │
│  Catatan otomatis per lahan:                 │
│  ├── 📷 Foto tanaman (timeline)             │
│  ├── 🧪 Hasil diagnosis & rekomendasi       │
│  ├── 💊 Riwayat aplikasi pupuk/pestisida    │
│  ├── 🌧️ Data cuaca harian                   │
│  ├── 💰 Pencatatan biaya & pendapatan       │
│  ├── 📊 Grafik pertumbuhan tanaman          │
│  └── 📅 Kalender aktivitas pertanian        │
│                                              │
│  Manfaat:                                    │
│  ├── Tracking progress musim demi musim      │
│  ├── Analisis ROI per jenis tanaman          │
│  ├── Data untuk pengajuan kredit pertanian   │
│  └── Referensi untuk musim tanam berikutnya  │
│                                              │
└──────────────────────────────────────────────┘
```

### 7. Community Forum — Komunitas Petani

- **Diskusi antar petani** — berbagi pengalaman dan tips
- **Leaderboard** — petani dengan diagnosis terbanyak, kontributor aktif
- **Expert Corner** — kolom khusus dari dosen/ahli pertanian
- **Marketplace** — jual beli hasil panen antar petani (future feature)

### 8. Weather Intelligence

- Integrasi dengan **BMKG API** untuk data cuaca akurat
- Prakiraan cuaca khusus pertanian (bukan cuaca umum)
- Rekomendasi aktivitas berdasarkan cuaca:
  ```
  🌤️ Cerah      → Waktu yang baik untuk penyemprotan
  🌧️ Akan hujan → Tunda penyemprotan, siapkan drainase
  🌡️ Suhu tinggi → Tambah frekuensi penyiraman
  💨 Angin kencang → Waspada penyebaran penyakit melalui udara
  ```

### 9. Crop Calendar (Kalender Tanam Cerdas)

- **Kalender tanam otomatis** berdasarkan jenis tanaman, lokasi, dan musim
- **Pengingat aktivitas**: "Hari ini jadwal pemupukan ke-2"
- **Milestone tracking**: fase bibit → vegetatif → generatif → panen
- Integrasi dengan data cuaca untuk penyesuaian jadwal real-time

### 10. Market Price Tracker

- Harga komoditas pertanian real-time dari berbagai pasar
- Prediksi tren harga menggunakan AI
- Rekomendasi waktu jual optimal
- Informasi pembeli/pengepul di area sekitar

### 11. Soil Health Profile

- Profil kesehatan tanah per lahan
- Input manual atau dari hasil lab tanah
- Rekomendasi perbaikan tanah jangka panjang
- Rotasi tanaman yang optimal untuk menjaga kesuburan

### 12. IoT Integration (Future Feature)

- Koneksi dengan sensor tanah (pH, kelembaban, suhu)
- Monitoring otomatis kondisi lahan 24/7
- Automated alert berdasarkan data sensor
- Dashboard monitoring real-time

---

## 🏗 Arsitektur Sistem

### High-Level Architecture

```
┌──────────────────────────────────────────────────────────────────────────┐
│                           CLIENT LAYER                                  │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌──────────────┐   │
│  │  📱 Mobile  │  │  💻 Web     │  │  🔔 Push    │  │  📡 IoT      │   │
│  │  App        │  │  Dashboard  │  │  Notif      │  │  Gateway     │   │
│  │  (Flutter)  │  │  (Next.js)  │  │  (FCM)      │  │  (MQTT)      │   │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └──────┬───────┘   │
│         │                │                │                 │            │
└─────────┼────────────────┼────────────────┼─────────────────┼────────────┘
          │                │                │                 │
          ▼                ▼                ▼                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                         API GATEWAY LAYER                               │
│                     (Kong / AWS API Gateway)                            │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │  Rate Limiting │ Auth (JWT) │ Request Routing │ Load Balancing  │   │
│  └──────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────┬───────────────────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                        BACKEND SERVICE LAYER                            │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐             │
│  │  🔐 Auth       │  │  📷 Scanner    │  │  🤖 AI         │             │
│  │  Service       │  │  Service       │  │  Orchestrator  │             │
│  │                │  │                │  │  Service       │             │
│  │  • Register    │  │  • Upload      │  │                │             │
│  │  • Login       │  │  • PreProcess  │  │  • Diagnosis   │             │
│  │  • Profile     │  │  • Validate    │  │  • Recommend   │             │
│  │  • Token       │  │  • Store       │  │  • Urgency     │             │
│  └────────────────┘  └────────────────┘  │  • ChatBot     │             │
│                                          └────────┬───────┘             │
│  ┌────────────────┐  ┌────────────────┐           │                     │
│  │  📊 Analytics  │  │  🔔 Notif      │           │                     │
│  │  Service       │  │  Service       │           │                     │
│  │                │  │                │           ▼                     │
│  │  • Farm Stats  │  │  • Push        │  ┌────────────────┐             │
│  │  • Reports     │  │  • Email       │  │  🧠 Gemini      │             │
│  │  • Insights    │  │  • SMS         │  │  Integration   │             │
│  └────────────────┘  │  • In-App      │  │  Layer         │             │
│                      └────────────────┘  │                │             │
│  ┌────────────────┐  ┌────────────────┐  │  • Prompt Mgmt │             │
│  │  🌤️ Weather    │  │  💬 Community  │  │  • Context     │             │
│  │  Service       │  │  Service       │  │  • Response    │             │
│  │                │  │                │  │    Parsing     │             │
│  │  • BMKG API    │  │  • Forum       │  │  • Rate Limit  │             │
│  │  • Forecast    │  │  • Q&A         │  │  • Caching     │             │
│  │  • Alerts      │  │  • Sharing     │  └────────────────┘             │
│  └────────────────┘  └────────────────┘                                 │
│                                                                          │
└──────────────────────────────┬───────────────────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                          DATA LAYER                                     │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐             │
│  │  🐘 PostgreSQL │  │  📦 Redis      │  │  ☁️ Cloud       │             │
│  │                │  │  Cache         │  │  Storage       │             │
│  │  • Users       │  │                │  │  (GCS/S3)      │             │
│  │  • Farms       │  │  • Sessions    │  │                │             │
│  │  • Diagnoses   │  │  • AI Cache    │  │  • Images      │             │
│  │  • History     │  │  • Rate Limit  │  │  • Models      │             │
│  │  • Community   │  │  • Leaderboard │  │  • Exports     │             │
│  └────────────────┘  └────────────────┘  └────────────────┘             │
│                                                                          │
│  ┌────────────────┐  ┌────────────────┐                                 │
│  │  📊 ClickHouse │  │  🔍 Elastic    │                                 │
│  │  (Analytics)   │  │  Search        │                                 │
│  │                │  │                │                                 │
│  │  • Event logs  │  │  • Knowledge   │                                 │
│  │  • Metrics     │  │    Base search │                                 │
│  │  • Aggregation │  │  • Forum       │                                 │
│  └────────────────┘  └────────────────┘                                 │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

### Backend Architecture — Microservices Detail

#### Service Communication Pattern

```
                    ┌──────────────────────┐
                    │   Message Queue      │
                    │   (RabbitMQ / Kafka)  │
                    └──────┬───────────────┘
                           │
          ┌────────────────┼────────────────┐
          │                │                │
          ▼                ▼                ▼
   ┌──────────┐    ┌──────────┐    ┌──────────────┐
   │ Scanner  │───▶│ AI Orch  │───▶│ Notification │
   │ Service  │    │ Service  │    │ Service      │
   └──────────┘    └──────────┘    └──────────────┘
                        │
                        ▼
                ┌──────────────┐
                │ Gemini API   │
                │ (External)   │
                └──────────────┘
```

**Pola Komunikasi:**
- **Synchronous**: REST API untuk request-response langsung (auth, profile)
- **Asynchronous**: Message queue untuk proses berat (AI analysis, notifications)
- **Event-Driven**: Event bus untuk update real-time (urgency alerts)

#### Tech Stack per Service

| Service | Language | Framework | Database | Notes |
|---------|----------|-----------|----------|-------|
| Auth Service | TypeScript | NestJS / Express | PostgreSQL | JWT + Refresh Token |
| Scanner Service | Python | FastAPI | PostgreSQL + GCS | Image processing |
| AI Orchestrator | Python | FastAPI | Redis + PostgreSQL | Core AI logic |
| Notification Service | TypeScript | NestJS | Redis | FCM, Email, SMS |
| Weather Service | TypeScript | Express | Redis (cache) | External API proxy |
| Analytics Service | Python | FastAPI | ClickHouse | Data aggregation |
| Community Service | TypeScript | NestJS | PostgreSQL + Elastic | Forum & social |

### AI/ML Pipeline

```
┌──────────────────────────────────────────────────────────────────┐
│                     AI/ML PIPELINE                               │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────┐    ┌──────────┐    ┌───────────┐    ┌──────────┐  │
│  │  IMAGE   │───▶│  PRE-    │───▶│  GEMINI   │───▶│  POST-   │  │
│  │  INPUT   │    │  PROCESS │    │  VISION   │    │  PROCESS │  │
│  └─────────┘    └──────────┘    └───────────┘    └──────────┘  │
│                      │               │                │         │
│                      ▼               ▼                ▼         │
│              ┌──────────────┐ ┌───────────┐  ┌──────────────┐  │
│              │ • Resize     │ │ • Multi-  │  │ • Parse JSON │  │
│              │ • Enhance    │ │   modal   │  │ • Validate   │  │
│              │ • Validate   │ │   prompt  │  │ • Enrich     │  │
│              │ • EXIF data  │ │ • Context │  │ • Localize   │  │
│              │ • Compress   │ │   inject  │  │ • Format     │  │
│              └──────────────┘ └───────────┘  └──────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              KNOWLEDGE BASE AUGMENTATION                 │   │
│  │                                                          │   │
│  │  ┌────────────────┐  ┌────────────────┐                  │   │
│  │  │ 📚 Plant       │  │ 🗺️ Regional    │                  │   │
│  │  │ Disease DB     │  │ Context DB     │                  │   │
│  │  │                │  │                │                  │   │
│  │  │ • 500+ jenis   │  │ • Pola penyakit│                  │   │
│  │  │   penyakit     │  │   per daerah   │                  │   │
│  │  │ • 200+ hama    │  │ • Ketersediaan │                  │   │
│  │  │ • 50+ jenis    │  │   produk lokal │                  │   │
│  │  │   tanaman      │  │ • Musim tanam  │                  │   │
│  │  └────────────────┘  │   per wilayah  │                  │   │
│  │                      └────────────────┘                  │   │
│  │  ┌────────────────┐  ┌────────────────┐                  │   │
│  │  │ 🧪 Treatment   │  │ 📊 Historical  │                  │   │
│  │  │ Protocol DB    │  │ Success DB     │                  │   │
│  │  │                │  │                │                  │   │
│  │  │ • Dosis pupuk  │  │ • Tingkat      │                  │   │
│  │  │ • Cara aplikasi│  │   keberhasilan │                  │   │
│  │  │ • Masa tunggu  │  │   per treatment│                  │   │
│  │  │ • Alternatif   │  │ • Feedback     │                  │   │
│  │  │   organik      │  │   petani       │                  │   │
│  │  └────────────────┘  └────────────────┘                  │   │
│  │                                                          │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### Database Schema

#### Entity Relationship Diagram

```
┌──────────────┐     ┌──────────────────┐     ┌──────────────────┐
│    users     │     │     farms        │     │    farm_plots    │
├──────────────┤     ├──────────────────┤     ├──────────────────┤
│ id (PK)      │────▶│ id (PK)          │────▶│ id (PK)          │
│ phone        │     │ user_id (FK)     │     │ farm_id (FK)     │
│ name         │     │ name             │     │ name             │
│ email        │     │ location_lat     │     │ crop_type        │
│ avatar_url   │     │ location_lng     │     │ area_hectare     │
│ province     │     │ address          │     │ planting_date    │
│ district     │     │ total_area       │     │ expected_harvest │
│ created_at   │     │ soil_type        │     │ current_phase    │
│ updated_at   │     │ elevation        │     │ status           │
└──────────────┘     │ created_at       │     │ created_at       │
                     └──────────────────┘     └──────┬───────────┘
                                                      │
                                                      ▼
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   scan_sessions  │     │   diagnoses      │     │  recommendations │
├──────────────────┤     ├──────────────────┤     ├──────────────────┤
│ id (PK)          │────▶│ id (PK)          │────▶│ id (PK)          │
│ plot_id (FK)     │     │ session_id (FK)  │     │ diagnosis_id(FK) │
│ user_id (FK)     │     │ disease_name     │     │ type (chemical/  │
│ images[] (urls)  │     │ scientific_name  │     │   organic/       │
│ scan_type        │     │ confidence       │     │   cultural/      │
│ weather_data     │     │ severity_score   │     │   nutrition)     │
│ gps_location     │     │ severity_level   │     │ title            │
│ device_info      │     │ infected_area_%  │     │ description      │
│ status           │     │ prognosis        │     │ products[]       │
│ created_at       │     │ raw_ai_response  │     │ dosage           │
└──────────────────┘     │ created_at       │     │ method           │
                         └──────────────────┘     │ schedule         │
                                                  │ priority         │
┌──────────────────┐     ┌──────────────────┐     │ estimated_cost   │
│  urgency_alerts  │     │  chat_sessions   │     │ eco_rating       │
├──────────────────┤     ├──────────────────┤     │ created_at       │
│ id (PK)          │     │ id (PK)          │     └──────────────────┘
│ user_id (FK)     │     │ user_id (FK)     │
│ diagnosis_id(FK) │     │ context          │     ┌──────────────────┐
│ alert_level      │     │ status           │     │  farm_activities  │
│ message          │     │ created_at       │     ├──────────────────┤
│ action_deadline  │     │ updated_at       │     │ id (PK)          │
│ is_read          │     └────────┬─────────┘     │ plot_id (FK)     │
│ is_acted         │              │               │ activity_type    │
│ spread_prediction│              ▼               │ description      │
│ weather_factor   │     ┌──────────────────┐     │ products_used[]  │
│ created_at       │     │  chat_messages   │     │ cost             │
└──────────────────┘     ├──────────────────┤     │ notes            │
                         │ id (PK)          │     │ photo_url        │
                         │ session_id (FK)  │     │ weather_data     │
                         │ role (user/bot)  │     │ created_at       │
                         │ content          │     └──────────────────┘
                         │ attachments[]    │
                         │ created_at       │
                         └──────────────────┘
```

### API Design

#### RESTful API Endpoints

```
BASE URL: https://api.agrotani.id/v1

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🔐 AUTHENTICATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

POST   /auth/register          → Daftar akun baru (phone + OTP)
POST   /auth/login             → Login dengan phone + OTP
POST   /auth/refresh           → Refresh access token
POST   /auth/logout            → Logout & invalidate token
GET    /auth/profile           → Ambil profil pengguna
PUT    /auth/profile           → Update profil

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🌾 FARM MANAGEMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

GET    /farms                  → List semua lahan petani
POST   /farms                  → Tambah lahan baru
GET    /farms/:id              → Detail lahan
PUT    /farms/:id              → Update info lahan
DELETE /farms/:id              → Hapus lahan

GET    /farms/:id/plots        → List petak di lahan
POST   /farms/:id/plots        → Tambah petak
GET    /farms/:id/plots/:pid   → Detail petak
PUT    /farms/:id/plots/:pid   → Update petak

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📷 SCANNER
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

POST   /scan                   → Upload foto & mulai analisis
GET    /scan/:id               → Ambil hasil scan
GET    /scan/:id/status        → Cek status proses scan
GET    /scan/history           → Riwayat scan
POST   /scan/:id/feedback      → Feedback akurasi diagnosis

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🤖 AI SERVICES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

GET    /diagnosis/:id          → Detail diagnosis
GET    /diagnosis/:id/recommendations → Rekomendasi dari diagnosis
POST   /diagnosis/:id/followup → Follow-up diagnosis

GET    /urgency/alerts         → List semua alert aktif
PUT    /urgency/alerts/:id/read     → Tandai alert sudah dibaca
PUT    /urgency/alerts/:id/acted    → Tandai alert sudah ditindak

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  💬 CHATBOT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

POST   /chat/sessions          → Mulai sesi chat baru
GET    /chat/sessions          → List sesi chat
GET    /chat/sessions/:id      → Detail sesi + messages
POST   /chat/sessions/:id/messages → Kirim pesan
DELETE /chat/sessions/:id      → Hapus sesi chat

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🌤️ WEATHER
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

GET    /weather/current        → Cuaca saat ini (by location)
GET    /weather/forecast       → Prakiraan 7 hari
GET    /weather/farming-advice → Saran aktivitas berdasarkan cuaca

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📊 ANALYTICS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

GET    /analytics/dashboard     → Dashboard data petani
GET    /analytics/reports       → Laporan per musim/periode
GET    /analytics/insights      → AI-generated insights
```

#### WebSocket API (Real-time)

```
WS    /ws/chat                → Real-time chat dengan FarmerBot
WS    /ws/scan-progress       → Live progress scan hasil
WS    /ws/alerts              → Real-time urgency alerts
```

---

## 🎨 Desain UI/UX

### Design Philosophy

#### Prinsip Desain Agrotani

1. **Simplicity First (Kesederhanaan)**
   - Interface harus intuitif untuk pengguna dengan literasi digital rendah
   - Maksimal 3 langkah untuk fitur utama (scan, diagnosis, rekomendasi)
   - Gunakan ikon besar dan jelas, minimkan teks

2. **Accessibility (Aksesibilitas)**
   - Font besar dan mudah dibaca (minimum 16sp)
   - Kontras warna tinggi untuk penggunaan di luar ruangan
   - Dukungan mode gelap untuk penggunaan malam hari
   - Target sentuhan minimum 48x48dp

3. **Offline-First Mindset**
   - UI harus tetap fungsional tanpa koneksi internet
   - Feedback jelas ketika dalam mode offline
   - Queue actions untuk di-sync ketika online

4. **Trust & Empathy**
   - Bahasa yang ramah dan tidak menggurui
   - Visual yang familiar bagi petani (warna hijau, ikon pertanian)
   - Confidence score yang transparan (bukan black box)

#### Color Palette

```
┌──────────────────────────────────────────────────┐
│               AGROTANI COLOR SYSTEM              │
├──────────────────────────────────────────────────┤
│                                                  │
│  PRIMARY                                         │
│  ██████  #2E7D32  Forest Green (Primary)        │
│  ██████  #4CAF50  Green (Primary Light)         │
│  ██████  #1B5E20  Dark Green (Primary Dark)     │
│                                                  │
│  SECONDARY                                       │
│  ██████  #FF8F00  Amber (Accent)                │
│  ██████  #FFB300  Gold (Highlight)              │
│                                                  │
│  SEMANTIC                                        │
│  ██████  #4CAF50  Sehat / Aman                  │
│  ██████  #FFC107  Perhatian / Warning           │
│  ██████  #FF9800  Waspada / Urgent              │
│  ██████  #F44336  Bahaya / Critical             │
│                                                  │
│  NEUTRAL                                         │
│  ██████  #FAFAFA  Background Light              │
│  ██████  #121212  Background Dark               │
│  ██████  #424242  Text Primary                  │
│  ██████  #757575  Text Secondary                │
│                                                  │
│  EARTH TONES                                     │
│  ██████  #795548  Soil Brown                    │
│  ██████  #8D6E63  Clay                          │
│  ██████  #A1887F  Sand                          │
│                                                  │
└──────────────────────────────────────────────────┘
```

#### Typography

```
Font Keluarga:
├── Primary   : "Plus Jakarta Sans" (heading, UI elements)
├── Secondary : "Inter" (body text, content)
└── Monospace : "JetBrains Mono" (data, kode produk)

Ukuran:
├── H1 : 28sp / Bold    — Judul halaman
├── H2 : 24sp / SemiBold — Sub-judul
├── H3 : 20sp / SemiBold — Section title
├── Body : 16sp / Regular — Teks utama
├── Caption : 14sp / Regular — Info tambahan
└── Small : 12sp / Regular — Label, tag
```

### Screen Flow & Wireframes

#### App Navigation Structure

```
┌─────────────────────────────────────────────────────────┐
│                    BOTTOM NAVIGATION                     │
├────────────┬────────────┬────────────┬──────────────────┤
│  🏠 Home   │  📷 Scan   │  💬 Chat   │  👤 Profil      │
└────────────┴────────────┴────────────┴──────────────────┘

Detail per tab:

🏠 HOME
├── Dashboard ringkasan
├── Weather widget
├── Alert aktif (urgency)
├── Scan terakhir
├── Tips harian
└── Quick action buttons

📷 SCAN
├── Camera view + guide overlay
├── Gallery picker
├── Multi-photo mode
├── Scan history
└── Results → Diagnosis → Recommendations

💬 CHAT (FarmerBot)
├── Chat interface
├── Quick reply buttons
├── Photo attachment
├── Voice input (future)
└── Chat history

👤 PROFIL
├── Info petani
├── Daftar lahan
├── Riwayat diagnosis
├── Pengaturan
├── Buku tani digital
└── Statistik
```

#### Screen 1: Splash & Onboarding

```
┌────────────────────────────────────┐
│                                    │
│                                    │
│          🌾                        │
│        AGROTANI                    │
│                                    │
│   "Asisten Cerdas Petani"         │
│                                    │
│                                    │
│         [Mulai] ────────────────▶  │
│                                    │
│   Sudah punya akun? [Masuk]       │
│                                    │
└────────────────────────────────────┘

ONBOARDING (3 slides):

Slide 1: "📷 Foto Tanaman Anda"
→ "Cukup foto tanaman yang bermasalah, AI kami akan menganalisis dan memberikan diagnosis"

Slide 2: "🤖 Konsultasi Kapan Saja"  
→ "Tanya apa saja tentang pertanian, FarmerBot siap membantu 24/7"

Slide 3: "🔔 Peringatan Dini"
→ "Dapatkan notifikasi penting tentang kondisi tanaman dan cuaca di lahan Anda"
```

#### Screen 2: Home Dashboard

```
┌────────────────────────────────────┐
│ ☀️ Selamat Pagi, Pak Harto!   🔔  │
├────────────────────────────────────┤
│                                    │
│ ┌────────────────────────────────┐ │
│ │  🌤️ Cuaca Hari Ini            │ │
│ │  Cerah Berawan · 28°C         │ │
│ │  💧 Kelembaban: 78%           │ │
│ │  ✅ Baik untuk penyemprotan    │ │
│ └────────────────────────────────┘ │
│                                    │
│ ⚠️ PERINGATAN AKTIF (1)           │
│ ┌────────────────────────────────┐ │
│ │ 🟠 URGENT                      │ │
│ │ Blast padi di petak A perlu    │ │
│ │ disemprot hari ini!            │ │
│ │ [Lihat Detail]  [Sudah Ditangani] │ │
│ └────────────────────────────────┘ │
│                                    │
│ 📊 RINGKASAN LAHAN                │
│ ┌──────────┐  ┌──────────┐        │
│ │ 🌾 Petak A│  │ 🌽 Petak B│        │
│ │ Padi     │  │ Jagung   │        │
│ │ 🟡 Sedang │  │ 🟢 Sehat  │        │
│ │ HST: 45  │  │ HST: 20  │        │
│ └──────────┘  └──────────┘        │
│                                    │
│ 🔍 SCAN TERAKHIR                  │
│ ┌────────────────────────────────┐ │
│ │ 📷 Padi Petak A · 2 hari lalu │ │
│ │ Blast (Blas) · Sedang · 87%   │ │
│ │ [Lihat Hasil]                  │ │
│ └────────────────────────────────┘ │
│                                    │
│ 💡 TIPS HARI INI                  │
│ "Cuaca cerah hari ini cocok untuk  │
│  melakukan penyemprotan fungisida" │
│                                    │
├────────────────────────────────────┤
│  🏠    📷 [SCAN]    💬    👤     │
└────────────────────────────────────┘
```

#### Screen 3: Scanner

```
┌────────────────────────────────────┐
│  ← Scan Tanaman                   │
├────────────────────────────────────┤
│                                    │
│  ┌────────────────────────────────┐│
│  │                                ││
│  │     ┌──────────────────┐      ││
│  │     │                  │      ││
│  │     │   CAMERA VIEW    │      ││
│  │     │                  │      ││
│  │     │  ┌──────────┐   │      ││
│  │     │  │  Focus   │   │      ││
│  │     │  │  Guide   │   │      ││
│  │     │  └──────────┘   │      ││
│  │     │                  │      ││
│  │     └──────────────────┘      ││
│  │                                ││
│  │  💡 "Arahkan ke bagian daun   ││
│  │      yang bermasalah"         ││
│  └────────────────────────────────┘│
│                                    │
│  Pilih tanaman:                    │
│  [🌾 Padi] [🌽 Jagung] [🌶 Cabai] │
│  [🍅 Tomat] [🥒 Timun] [Lainnya]  │
│                                    │
│  Pilih bagian:                     │
│  [🍃 Daun] [🌿 Batang] [🍎 Buah]  │
│  [🌱 Akar] [🌾 Bulir]             │
│                                    │
│         ┌──────┐                   │
│         │  📷  │     🖼️ Gallery   │
│         │ SCAN │                   │
│         └──────┘                   │
│                                    │
├────────────────────────────────────┤
│  🏠    📷 [SCAN]    💬    👤     │
└────────────────────────────────────┘
```

#### Screen 4: Hasil Diagnosis

```
┌────────────────────────────────────┐
│  ← Hasil Analisis                  │
├────────────────────────────────────┤
│                                    │
│  ┌────────────────────────────────┐│
│  │  📷 [Foto tanaman yang discan] ││
│  │     Padi · Petak A · Daun     ││
│  └────────────────────────────────┘│
│                                    │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│  📋 DIAGNOSIS                      │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                    │
│  🔴 Blast (Blas)                   │
│  Magnaporthe oryzae                │
│                                    │
│  Confidence: ████████░░ 87%        │
│                                    │
│  Keparahan: ██████░░░░ SEDANG (6/10)│
│  Area terinfeksi: ~35%             │
│                                    │
│  ┌────────────────────────────────┐│
│  │ ⚠️ PERHATIAN                   ││
│  │ Jika tidak ditangani dalam    ││
│  │ 3 hari, penyakit dapat        ││
│  │ menyebar ke 70% area dan      ││
│  │ menyebabkan gagal panen!      ││
│  └────────────────────────────────┘│
│                                    │
│  📖 TENTANG PENYAKIT INI          │
│  Blast adalah penyakit padi yang   │
│  disebabkan oleh jamur. Gejalanya  │
│  berupa bercak coklat berbentuk...│
│  [Baca Selengkapnya]               │
│                                    │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│  💊 REKOMENDASI TINDAKAN          │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                    │
│  ✅ Langkah 1: Semprot Fungisida  │
│  📦 Beam 75 WP · 1.5 gr/liter    │
│  💰 Est. Rp 85.000/hektar        │
│  [Lihat Detail]                    │
│                                    │
│  ✅ Langkah 2: Kurangi Urea 50%  │
│  [Lihat Detail]                    │
│                                    │
│  🌱 Alternatif Organik            │
│  [Lihat Opsi Organik]             │
│                                    │
│  📅 Jadwal Tindak Lanjut          │
│  [Atur Pengingat]                  │
│                                    │
│  ─────────────────────────────────│
│  [💬 Tanya FarmerBot]             │
│  [📤 Bagikan Hasil]               │
│  [📷 Scan Ulang]                  │
│                                    │
├────────────────────────────────────┤
│  🏠    📷 [SCAN]    💬    👤     │
└────────────────────────────────────┘
```

#### Screen 5: FarmerBot Chat

```
┌────────────────────────────────────┐
│  ← FarmerBot 🤖                🗑️ │
├────────────────────────────────────┤
│                                    │
│  ┌──────────────────────────────┐  │
│  │ 🤖 Halo Pak Harto! 👋       │  │
│  │ Saya FarmerBot, asisten     │  │
│  │ pertanian Anda.              │  │
│  │                              │  │
│  │ Apa yang bisa saya bantu    │  │
│  │ hari ini?                    │  │
│  └──────────────────────────────┘  │
│                                    │
│         ┌──────────────────────┐   │
│         │ Tanaman padi saya    │   │
│         │ kok daunnya kuning   │   │
│         │ ya?                  │   │
│         └──────────────────────┘   │
│                                    │
│  ┌──────────────────────────────┐  │
│  │ 🤖 Daun padi menguning bisa │  │
│  │ disebabkan beberapa hal:    │  │
│  │                              │  │
│  │ 1. Kekurangan Nitrogen      │  │
│  │ 2. Terlalu banyak air       │  │
│  │ 3. Penyakit Tungro          │  │
│  │                              │  │
│  │ Untuk diagnosis yang lebih  │  │
│  │ akurat, coba foto daunnya   │  │
│  │ ya Pak! 📸                  │  │
│  └──────────────────────────────┘  │
│                                    │
│  Quick Replies:                    │
│  [📸 Kirim Foto] [🌾 Jadwal Pupuk]│
│  [🐛 Ada Hama]   [🌤️ Cek Cuaca]  │
│                                    │
├────────────────────────────────────┤
│  📷  🎤  [Ketik pesan...] [➤]    │
├────────────────────────────────────┤
│  🏠    📷 [SCAN]    💬    👤     │
└────────────────────────────────────┘
```

### Component Library

#### Reusable UI Components

```
AGROTANI COMPONENT LIBRARY
══════════════════════════

1. AgroCard
   ├── ScanResultCard      — Menampilkan hasil scan ringkas
   ├── AlertCard           — Kartu urgency alert
   ├── WeatherCard         — Widget cuaca
   ├── PlotCard            — Info petak lahan
   └── TipCard             — Tips harian

2. AgroButton
   ├── PrimaryButton       — CTA utama (hijau)
   ├── SecondaryButton     — Aksi sekunder (outline)
   ├── DangerButton        — Aksi berbahaya (merah)
   ├── FloatingActionButton — FAB scan (kamera)
   └── QuickReplyButton    — Tombol cepat chat

3. AgriIndicator
   ├── SeverityBadge       — Badge level keparahan
   ├── ConfidenceBar       — Progress bar confidence
   ├── HealthScore         — Skor kesehatan tanaman
   └── UrgencyTimer        — Countdown timer urgensi

4. AgriChart
   ├── GrowthTimeline      — Timeline pertumbuhan
   ├── SeverityGraph       — Grafik keparahan
   ├── WeatherChart        — Grafik cuaca
   └── CostBreakdown       — Pie chart biaya

5. AgriInput
   ├── SearchField         — Pencarian
   ├── ChatInput           — Input pesan chat
   ├── PhotoPicker         — Pemilih foto
   └── CropSelector        — Pemilih jenis tanaman

6. AgriModal
   ├── DiagnosisDetail     — Detail diagnosis full
   ├── RecommendationSheet — Bottom sheet rekomendasi  
   ├── AlertDialog         — Dialog peringatan
   └── ConfirmAction       — Konfirmasi tindakan
```

---

## 🧠 AI & Prompt Engineering Strategy

### Gemini Integration Architecture

Karena Agrotani menggunakan **Google Gemini LLM** sebagai AI engine utama, strategi prompt engineering menjadi sangat krusial. Berikut arsitektur integrasi Gemini:

```
┌────────────────────────────────────────────────────────────────┐
│                  GEMINI INTEGRATION LAYER                      │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │                  PROMPT MANAGER                          │ │
│  │                                                          │ │
│  │  ┌──────────┐  ┌───────────┐  ┌──────────────────────┐ │ │
│  │  │ System   │  │ Context   │  │ Task-Specific        │ │ │
│  │  │ Prompt   │  │ Builder   │  │ Prompt Templates     │ │ │
│  │  │ (Base)   │  │           │  │                      │ │ │
│  │  └──────────┘  └───────────┘  │ • Diagnosis Prompt   │ │ │
│  │                               │ • Recommendation     │ │ │
│  │                               │ • Urgency Assessment │ │ │
│  │                               │ • Chat/Conversation  │ │ │
│  │                               │ • Weather Analysis   │ │ │
│  │                               └──────────────────────┘ │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │                  CONTEXT ENRICHMENT                      │ │
│  │                                                          │ │
│  │  User Context ──────────────────────────────────────┐   │ │
│  │  ├── Lokasi petani (provinsi, kabupaten)             │   │ │
│  │  ├── Jenis tanaman yang ditanam                      │   │ │
│  │  ├── Riwayat diagnosis sebelumnya                    │   │ │
│  │  ├── Fase pertumbuhan tanaman saat ini               │   │ │
│  │  └── Preferensi (organik/konvensional)               │   │ │
│  │                                                      │   │ │
│  │  Environmental Context ─────────────────────────────┘   │ │
│  │  ├── Data cuaca real-time                               │ │
│  │  ├── Musim saat ini                                     │ │
│  │  ├── Riwayat penyakit di area tersebut                  │ │
│  │  └── Jenis tanah & elevasi                              │ │
│  │                                                          │ │
│  │  Knowledge Base Context ────────────────────────────────│ │
│  │  ├── Database penyakit tanaman Indonesia                │ │
│  │  ├── Protokol penanganan standar                        │ │
│  │  ├── Data produk pertanian yang tersedia                │ │
│  │  └── Regulasi pestisida Indonesia                       │ │
│  │                                                          │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │                  RESPONSE PARSER                         │ │
│  │                                                          │ │
│  │  Raw AI Response ──▶ Validation ──▶ Structured Data     │ │
│  │                                                          │ │
│  │  • JSON schema validation                               │ │
│  │  • Confidence threshold check                           │ │
│  │  • Hallucination detection                              │ │
│  │  • Local language adaptation                            │ │
│  │  • Safety content filtering                             │ │
│  │                                                          │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### Prompt Templates

#### 1. System Prompt (Base Identity)

```
SYSTEM PROMPT — AGROTANI AI ENGINE
═══════════════════════════════════

Kamu adalah AgroAI, asisten pertanian cerdas yang dikembangkan oleh Agrotani 
untuk membantu petani Indonesia. Kamu memiliki pengetahuan mendalam tentang:

1. Penyakit dan hama tanaman di Indonesia
2. Teknik budidaya berbagai komoditas pertanian
3. Pupuk, pestisida, dan bahan pertanian
4. Kondisi iklim dan cuaca Indonesia
5. Praktik pertanian berkelanjutan

ATURAN PENTING:
• Selalu jawab dalam Bahasa Indonesia yang sederhana dan mudah dipahami
• Gunakan bahasa sehari-hari, hindari jargon teknis yang berlebihan
• Jika menggunakan istilah teknis, berikan penjelasan sederhana
• Selalu berikan tingkat keyakinan (confidence) pada diagnosis
• Jangan pernah memberikan rekomendasi yang berbahaya
• Jika tidak yakin, katakan "Saya kurang yakin" dan sarankan konsultasi ahli
• Prioritaskan solusi yang tersedia dan terjangkau bagi petani
• Berikan alternatif organik jika memungkinkan
• Selalu ingatkan tentang keselamatan (APD, masa tunggu panen, dll)
• Gunakan emoji untuk membuat respons lebih ramah dan mudah di-scan

FORMAT RESPONS:
Selalu strukturkan respons dalam format yang konsisten dan mudah dibaca.
Gunakan heading, bullet points, dan emoji untuk organisasi.
```

#### 2. Diagnosis Prompt Template

```
DIAGNOSIS PROMPT
════════════════

[SYSTEM]
{base_system_prompt}

Kamu sedang melakukan diagnosis penyakit tanaman berdasarkan gambar yang 
diberikan oleh petani.

[CONTEXT]
- Jenis tanaman: {crop_type}
- Bagian yang difoto: {plant_part}
- Lokasi petani: {location}
- Cuaca saat ini: {weather_data}
- Musim: {season}
- Usia tanaman (HST): {days_after_planting}
- Riwayat penyakit sebelumnya: {disease_history}
- Fase pertumbuhan: {growth_phase}

[TASK]
Analisis gambar tanaman berikut dan berikan diagnosis dalam format JSON:

{
  "primary_diagnosis": {
    "name": "nama penyakit/hama/defisiensi",
    "scientific_name": "nama ilmiah",
    "local_names": ["nama lokal 1", "nama lokal 2"],
    "confidence_percent": 0-100,
    "category": "Penyakit Jamur/Bakteri/Virus/Hama/Defisiensi/Lainnya"
  },
  "differential_diagnosis": [
    {"name": "...", "confidence_percent": 0-100}
  ],
  "severity": {
    "level": "SANGAT_RINGAN/RINGAN/SEDANG/PARAH/KRITIS",
    "score": 1-10,
    "infected_area_percent": 0-100,
    "description": "deskripsi kondisi dalam bahasa sederhana"
  },
  "causes": ["penyebab 1", "penyebab 2"],
  "prognosis": {
    "without_treatment": "prediksi jika tidak ditangani",
    "with_treatment": "prediksi jika ditangani",
    "spread_risk": "RENDAH/SEDANG/TINGGI",
    "critical_window_days": number
  },
  "explanation": "penjelasan penyakit dalam bahasa sederhana untuk petani"
}

[IMPORTANT RULES]
• Jika gambar tidak jelas atau bukan tanaman, set confidence < 30% dan 
  jelaskan bahwa diperlukan foto yang lebih baik
• Jangan pernah memberikan confidence > 95% untuk diagnosis dari foto saja
• Selalu berikan differential diagnosis minimal 1 kemungkinan lain
• Pertimbangkan konteks lokasi dan cuaca dalam diagnosis
```

#### 3. Recommendation Prompt Template

```
RECOMMENDATION PROMPT
═════════════════════

[SYSTEM]
{base_system_prompt}

Kamu memberikan rekomendasi penanganan berdasarkan diagnosis yang sudah 
dilakukan. Rekomendasi harus PRAKTIS, SPESIFIK, dan TERJANGKAU.

[CONTEXT]
- Diagnosis: {diagnosis_result}
- Luas lahan: {area_hectare} hektar
- Budget petani: {budget_range}
- Preferensi: {organic_preference}
- Ketersediaan produk lokal: {local_products}
- Cuaca mendatang: {weather_forecast}

[TASK]
Berikan rekomendasi penanganan dalam format JSON:

{
  "immediate_actions": [
    {
      "step": 1,
      "action": "deskripsi tindakan",
      "product": "nama produk spesifik",
      "active_ingredient": "bahan aktif",
      "dosage": "dosis per liter/hektar",
      "application_method": "cara aplikasi",
      "timing": "kapan dilakukan",
      "estimated_cost_per_hectare": number,
      "safety_notes": ["catatan keselamatan"]
    }
  ],
  "organic_alternatives": [...],
  "cultural_practices": [...],
  "nutrition_adjustments": [...],
  "prevention_measures": [...],
  "follow_up_schedule": [
    {"day": 3, "action": "evaluasi gejala"},
    {"day": 7, "action": "semprot ulang jika perlu"}
  ],
  "total_estimated_cost": {
    "chemical": number,
    "organic": number,
    "currency": "IDR"
  },
  "expected_outcome": "hasil yang diharapkan dalam bahasa sederhana"
}

[IMPORTANT RULES]
• Gunakan nama produk yang benar-benar tersedia di Indonesia
• Berikan dosis yang akurat sesuai label produk
• Selalu sertakan peringatan keselamatan
• Prioritaskan efektivitas namun pertimbangkan biaya
• Sertakan masa tunggu panen jika menggunakan pestisida
```

#### 4. Urgency Assessment Prompt Template

```
URGENCY ASSESSMENT PROMPT
═════════════════════════

[SYSTEM]
{base_system_prompt}

Kamu melakukan analisis urgensi berdasarkan diagnosis, data cuaca, 
dan faktor lingkungan untuk menentukan tingkat kegentingan dan 
prediksi perkembangan masalah.

[CONTEXT]
- Diagnosis: {diagnosis_result}
- Cuaca 7 hari ke depan: {weather_forecast}
- Kelembaban rata-rata: {humidity}
- Riwayat penyakit di area: {area_disease_history}
- Fase pertumbuhan: {growth_phase}
- Lahan tetangga: {neighboring_farm_data}

[TASK]
Berikan assessment urgensi dalam format JSON:

{
  "alert_level": "INFO/WARNING/URGENT/CRITICAL",
  "risk_score": 1-10,
  "message": "pesan alert untuk petani",
  "action_deadline_hours": number,
  "spread_prediction": {
    "day_1": "prediksi hari 1",
    "day_3": "prediksi hari 3",
    "day_7": "prediksi hari 7"
  },
  "weather_impact": "dampak cuaca terhadap penyakit",
  "area_risk": "risiko penyebaran ke lahan tetangga",
  "notification_frequency": "seberapa sering notif dikirim"
}
```

#### 5. FarmerBot Conversation Prompt Template

```
FARMERBOT CONVERSATION PROMPT
═════════════════════════════

[SYSTEM]
{base_system_prompt}

Kamu adalah FarmerBot, teman ngobrol petani yang ramah dan membantu.
Cara komunikasimu:
• Panggil pengguna dengan "Pak/Bu {nama}"
• Gunakan bahasa santai tapi tetap informatif
• Gunakan emoji untuk membuat percakapan lebih hangat
• Jika petani mengirim foto, analisis dan berikan diagnosis
• Jika tidak yakin, ajak untuk melakukan scan foto
• Ingat konteks percakapan sebelumnya
• Berikan quick reply suggestions di akhir respons

[USER CONTEXT]
- Nama: {user_name}
- Tanaman: {user_crops}
- Lokasi: {user_location}
- Riwayat percakapan: {conversation_history}
- Hasil scan terakhir: {last_scan_result}

[CONVERSATION]
{chat_messages}

[RESPONSE FORMAT]
Berikan respons natural dalam bahasa Indonesia yang mudah dipahami.
Di akhir respons, berikan 2-3 opsi quick reply yang relevan.

Format quick replies:
QUICK_REPLIES: ["opsi 1", "opsi 2", "opsi 3"]
```

### Context Management

#### Conversation Memory Strategy

```
┌──────────────────────────────────────────────────────────────┐
│                  CONTEXT MANAGEMENT                          │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  SHORT-TERM CONTEXT (Per Session)                           │
│  ├── Current conversation messages (sliding window: 20)     │
│  ├── Active diagnosis context                               │
│  ├── Current weather data                                   │
│  └── User's current intent/task                             │
│                                                              │
│  MEDIUM-TERM CONTEXT (Per User)                             │
│  ├── Last 10 diagnoses and results                          │
│  ├── User's farm profile (crops, area, location)            │
│  ├── Treatment history and outcomes                         │
│  └── Frequently asked questions                             │
│                                                              │
│  LONG-TERM CONTEXT (Knowledge Base)                         │
│  ├── Plant disease database (500+ entries)                  │
│  ├── Treatment protocols                                    │
│  ├── Regional agricultural data                             │
│  ├── Product database (pupuk, pestisida)                    │
│  └── Best practices by crop type                            │
│                                                              │
│  CONTEXT INJECTION STRATEGY:                                │
│  ┌─────────────────────────────────────────┐                │
│  │ System Prompt (base, always included)   │ ~500 tokens    │
│  │ + User Context (personalized)           │ ~200 tokens    │
│  │ + Task Template (specific to action)    │ ~300 tokens    │
│  │ + Knowledge Base (RAG retrieved)        │ ~500 tokens    │
│  │ + Conversation History (recent)         │ ~1000 tokens   │
│  │ + Current Input (user's message/image)  │ variable       │
│  │ ─────────────────────────────────────── │                │
│  │ = Total Context per Request             │ ~2500+ tokens  │
│  └─────────────────────────────────────────┘                │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### Response Formatting

#### Post-Processing Pipeline

```python
# Pseudocode: Response Post-Processing

class ResponseProcessor:
    def process(self, raw_response: str, task_type: TaskType) -> FormattedResponse:
        
        # Step 1: Parse JSON dari response Gemini
        parsed = self.parse_json(raw_response)
        
        # Step 2: Validasi schema
        validated = self.validate_schema(parsed, task_type.schema)
        
        # Step 3: Hallucination check
        # - Cek apakah nama penyakit ada di knowledge base
        # - Cek apakah nama produk benar-benar ada
        # - Cek apakah dosis masuk akal
        checked = self.hallucination_check(validated)
        
        # Step 4: Safety filter
        # - Pastikan tidak ada rekomendasi berbahaya
        # - Cek masa tunggu panen
        # - Validasi dosis tidak melebihi batas
        safe = self.safety_filter(checked)
        
        # Step 5: Localization
        # - Sesuaikan nama produk dengan ketersediaan lokal
        # - Konversi satuan jika perlu
        # - Tambahkan konteks regional
        localized = self.localize(safe, user_location)
        
        # Step 6: Format untuk UI
        formatted = self.format_for_ui(localized, task_type)
        
        return formatted
```

#### Handling Uncertainty

```
CONFIDENCE LEVELS & UI TREATMENT:
═════════════════════════════════

≥ 80% : ✅ "Dengan keyakinan tinggi, tanaman Anda terdeteksi..."
        → Tampilkan diagnosis utama dengan rekomendasi lengkap

60-79% : ⚡ "Kemungkinan besar tanaman Anda mengalami..."
         → Tampilkan diagnosis utama + differential + saran verifikasi

40-59% : ❓ "Beberapa kemungkinan yang kami deteksi..."
         → Tampilkan beberapa opsi diagnosis + saran foto ulang

< 40%  : 📸 "Kami membutuhkan foto yang lebih jelas..."
         → Saran pengambilan foto ulang + tips foto yang baik
         → Opsi untuk langsung konsultasi dengan FarmerBot
```

---

## 💻 Tech Stack

### Frontend (Mobile)

| Komponen | Teknologi | Alasan |
|----------|-----------|--------|
| Framework | **Flutter** | Cross-platform (Android + iOS), performa native, single codebase |
| State Management | **Riverpod** | Reactive, testable, scalable |
| Local DB | **Hive / Isar** | Offline-first, cepat, lightweight |
| Camera | **camera** package | Kontrol kamera native |
| Image Processing | **image** package | Resize, crop, enhance sebelum upload |
| HTTP Client | **Dio** | Interceptors, retry, caching |
| Push Notification | **firebase_messaging** | FCM untuk push notif |
| Charts | **fl_chart** | Grafik dan visualisasi data |
| Maps | **google_maps_flutter** | Peta lahan dan lokasi |

### Frontend (Web Dashboard)

| Komponen | Teknologi | Alasan |
|----------|-----------|--------|
| Framework | **Next.js 14+** | SSR, App Router, great DX |
| UI Library | **Shadcn/ui** | Beautiful, accessible components |
| Styling | **Tailwind CSS** | Utility-first, responsive |
| Charts | **Recharts** | Data visualization |
| Maps | **Leaflet / Mapbox** | Heatmap area penyakit |
| State | **Zustand** | Simple global state |
| Forms | **React Hook Form + Zod** | Type-safe forms |

### Backend

| Komponen | Teknologi | Alasan |
|----------|-----------|--------|
| Runtime | **Node.js (TS)** + **Python (FastAPI)** | TS untuk API umum, Python untuk AI pipeline |
| API Framework | **NestJS / Express** | Production-ready, modular |
| AI Service | **FastAPI** | Async, kencang, python ecosystem |
| Database | **PostgreSQL** | Relational, JSONB support, mature |
| Cache | **Redis** | Session, AI response cache, rate limit |
| Message Queue | **RabbitMQ / Bull** | Async processing, job queue |
| File Storage | **Google Cloud Storage** | Scalable, CDN, Gemini integration |
| Search | **ElasticSearch / Meilisearch** | Full-text search knowledge base |
| Analytics | **ClickHouse** | Columnar DB untuk analytics berat |

### AI & ML

| Komponen | Teknologi | Alasan |
|----------|-----------|--------|
| LLM | **Google Gemini Pro / Flash** | Multi-modal (text + image), bahasa Indonesia |
| Vision | **Gemini Vision** | Analisis gambar tanaman |
| Embeddings | **Gemini Embeddings** | Vector search knowledge base |
| Prompt Management | **Custom (in-house)** | Versi management, A/B testing |
| RAG | **LangChain / LlamaIndex** | Knowledge base retrieval |
| Vector DB | **Pinecone / Chroma** | Embedding storage untuk RAG |

### Infrastructure & DevOps

| Komponen | Teknologi | Alasan |
|----------|-----------|--------|
| Cloud | **Google Cloud Platform** | Integrasi seamless dengan Gemini |
| Container | **Docker + Kubernetes** | Containerization & orchestration |
| CI/CD | **GitHub Actions** | Automated build, test, deploy |
| Monitoring | **Grafana + Prometheus** | System & app monitoring |
| Logging | **ELK Stack** | Centralized logging |
| CDN | **CloudFlare** | Global CDN, DDoS protection |
| SSL | **Let's Encrypt** | Free SSL certificates |

---

## 🔄 Alur Kerja Pengguna (User Flow)

### Flow 1: Pertama Kali Menggunakan Agrotani

```
┌───────────┐    ┌────────────┐    ┌──────────────┐    ┌───────────┐
│  Download  │───▶│  Splash &  │───▶│  Registrasi  │───▶│  Setup    │
│  App       │    │  Onboarding│    │  (Phone+OTP) │    │  Profil   │
└───────────┘    └────────────┘    └──────────────┘    └─────┬─────┘
                                                              │
                                                              ▼
┌───────────┐    ┌────────────┐    ┌──────────────┐    ┌───────────┐
│  Ready!   │◀───│  Tutorial  │◀───│  Tambah      │◀───│  Pilih    │
│  Dashboard│    │  Interaktif│    │  Lahan       │    │  Tanaman  │
└───────────┘    └────────────┘    └──────────────┘    └───────────┘

Detail Setup Profil:
├── Nama lengkap
├── Nomor HP (sudah dari registrasi)
├── Provinsi & Kabupaten
├── Jenis tanaman yang ditanam (multi-select)
├── Luas lahan (estimasi)
└── Preferensi: Organik / Konvensional / Campuran
```

### Flow 2: Scan & Diagnosis

```
┌──────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────┐
│  Tap      │───▶│  Pilih       │───▶│  Ambil       │───▶│  Review  │
│  "Scan"   │    │  Tanaman &   │    │  Foto        │    │  Foto    │
│           │    │  Bagian      │    │  (Kamera/    │    │  & Kirim │
│           │    │              │    │   Gallery)   │    │          │
└──────────┘    └──────────────┘    └──────────────┘    └────┬─────┘
                                                              │
                                                              ▼
                                                       ┌──────────┐
                                                       │  Loading  │
                                                       │  "Sedang  │
                                                       │  mengana- │
                                                       │  lisis..."│
                                                       └────┬─────┘
                                                            │
              ┌─────────────────────────────────────────────┼──────────────┐
              │                                             │              │
              ▼                                             ▼              ▼
       ┌──────────┐                                  ┌──────────┐  ┌──────────┐
       │ Diagnosis │                                  │ Rekomen- │  │ Set      │
       │ Result    │─────────────────────────────────▶│ dasi     │  │ Urgency  │
       │           │                                  │ Tindakan │  │ Alert    │
       └──────────┘                                  └──────────┘  └──────────┘
              │
              ▼
       ┌──────────────────────────────────────┐
       │  USER ACTIONS:                       │
       │  • 💬 Tanya FarmerBot (konsultasi)  │
       │  • 📤 Bagikan ke grup WhatsApp      │
       │  • 📅 Set pengingat tindak lanjut   │
       │  • 📷 Scan ulang (angle berbeda)    │
       │  • 👍/👎 Feedback akurasi          │
       └──────────────────────────────────────┘
```

### Flow 3: Interaksi dengan FarmerBot

```
┌──────────┐    ┌──────────────┐    ┌──────────────┐
│  Tap      │───▶│  Chat        │───▶│  Ketik       │
│  "Chat"   │    │  Interface   │    │  Pertanyaan  │
│           │    │  Opens       │    │  / Kirim Foto│
└──────────┘    └──────────────┘    └──────┬───────┘
                                           │
              ┌────────────────────────────┘
              │
              ▼
       ┌──────────────────────────────────────────┐
       │  GEMINI processes:                        │
       │  1. Understand user intent                │
       │  2. Inject relevant context               │
       │  3. Retrieve from knowledge base          │
       │  4. Generate response                     │
       │  5. Post-process & format                 │
       └──────────────────────┬───────────────────┘
                              │
                              ▼
       ┌──────────────────────────────────────────┐
       │  Response displayed:                      │
       │  • Jawaban informatif                    │
       │  • Quick reply buttons                   │
       │  • Link ke scan jika relevan             │
       │  • Referensi dari knowledge base         │
       └──────────────────────────────────────────┘
```

### Flow 4: Urgency Alert Lifecycle

```
TRIGGER                    NOTIFICATION               ACTION
═══════                    ════════════               ═══════

Diagnosis baru    ───▶    Push Notif      ───▶    Lihat detail
Severity ≥ 6              "🟠 URGENT:              Buka rekomendasi
                           Tanaman padi              Tandai sudah ditangani
                           perlu ditangani!"

Weather alert     ───▶    Push Notif      ───▶    Cek prakiraan cuaca
Cuaca buruk               "🌧️ PERINGATAN:          Sesuaikan jadwal
                           Hujan lebat 3 hari       Siapkan drainase
                           ke depan!"

Follow-up due    ───▶    In-App + Push   ───▶    Scan ulang
Jadwal evaluasi           "📅 Hari ini jadwal      Update status
                           evaluasi pasca-
                           penyemprotan"

Area outbreak    ───▶    Broadcast Notif  ───▶    Cek tanaman
Banyak laporan            "⚠️ Outbreak              Tindakan preventif
di area yang sama          [penyakit] di            Lapor jika ada gejala
                           area Anda!"
```

---

## ☁️ Deployment & Infrastructure

### Cloud Architecture (Google Cloud Platform)

```
┌──────────────────────────────────────────────────────────────────────┐
│                        GOOGLE CLOUD PLATFORM                        │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────────┐     ┌──────────────────────────────────┐  │
│  │  Cloud CDN           │     │  Cloud Load Balancer             │  │
│  │  (Static assets,     │     │  (SSL termination,               │  │
│  │   cached responses)  │     │   traffic distribution)          │  │
│  └──────────┬───────────┘     └──────────────┬───────────────────┘  │
│             │                                │                       │
│             │     ┌──────────────────────────┤                       │
│             │     │                          │                       │
│             ▼     ▼                          ▼                       │
│  ┌──────────────────────┐     ┌──────────────────────────────────┐  │
│  │  Cloud Run /         │     │  Google Kubernetes Engine (GKE)  │  │
│  │  Cloud Functions     │     │                                  │  │
│  │                      │     │  ┌────────┐ ┌────────┐          │  │
│  │  • Serverless        │     │  │  Auth  │ │Scanner │          │  │
│  │    functions         │     │  │Service │ │Service │          │  │
│  │  • Image processing  │     │  └────────┘ └────────┘          │  │
│  │  • Webhook handlers  │     │  ┌────────┐ ┌────────┐          │  │
│  │                      │     │  │  AI    │ │ Notif  │          │  │
│  └──────────────────────┘     │  │Orchest.│ │Service │          │  │
│                                │  └────────┘ └────────┘          │  │
│                                └──────────────┬──────────────────┘  │
│                                               │                      │
│  ┌────────────────────────────────────────────┼──────────────────┐   │
│  │                  DATA LAYER                │                  │   │
│  │                                            ▼                  │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────────────────┐       │   │
│  │  │Cloud SQL │  │Memorystore│  │Cloud Storage         │       │   │
│  │  │(Postgres)│  │(Redis)   │  │(Images, Models)      │       │   │
│  │  └──────────┘  └──────────┘  └──────────────────────┘       │   │
│  │                                                              │   │
│  │  ┌──────────┐  ┌──────────────────────────────────┐         │   │
│  │  │Firestore │  │Vertex AI / Gemini API            │         │   │
│  │  │(Real-time│  │(LLM, Vision, Embeddings)         │         │   │
│  │  │  data)   │  │                                  │         │   │
│  │  └──────────┘  └──────────────────────────────────┘         │   │
│  │                                                              │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │                  MONITORING & LOGGING                        │   │
│  │                                                              │   │
│  │  Cloud Monitoring │ Cloud Logging │ Error Reporting          │   │
│  │  Cloud Trace      │ Cloud Profiler│ Uptime Checks           │   │
│  │                                                              │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

### Environment Strategy

| Environment | Tujuan | URL | Auto-Deploy |
|-------------|--------|-----|-------------|
| Development | Pengembangan fitur | dev-api.agrotani.id | Push ke `develop` |
| Staging | Testing & QA | staging-api.agrotani.id | Merge ke `staging` |
| Production | Live untuk pengguna | api.agrotani.id | Release tag |

### Scaling Strategy

```
AUTO-SCALING CONFIGURATION:
══════════════════════════

Service Level:
├── Min instances: 2 (always running)
├── Max instances: 50 (peak load)
├── Scale trigger: CPU > 70% or Memory > 80%
├── Cool-down period: 300 seconds
└── Health check interval: 30 seconds

Database:
├── PostgreSQL: Cloud SQL with read replicas
├── Redis: Cluster mode for high availability
└── Connection pooling: PgBouncer (100 connections/instance)

AI Service:
├── Rate limit: 1000 requests/minute (Gemini API)
├── Batch processing: Group similar requests
├── Response caching: 1-hour TTL for similar images
└── Fallback: Graceful degradation when AI service is down
```

---

## 🔐 Keamanan & Privasi

### Security Measures

```
┌──────────────────────────────────────────────────────────────┐
│                    SECURITY ARCHITECTURE                     │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  AUTHENTICATION                                              │
│  ├── Phone-based OTP login (SMS/WhatsApp)                   │
│  ├── JWT access token (15 min TTL)                          │
│  ├── Refresh token (30 days, rotating)                      │
│  ├── Device fingerprinting                                   │
│  └── Rate limiting: 5 OTP requests per hour                 │
│                                                              │
│  AUTHORIZATION                                               │
│  ├── Role-based access control (RBAC)                       │
│  │   ├── Farmer (basic)                                     │
│  │   ├── Premium Farmer (extended)                          │
│  │   ├── Extension Worker (multi-farm view)                 │
│  │   └── Admin (full access)                                │
│  └── Resource-level permissions (own data only)             │
│                                                              │
│  DATA PROTECTION                                             │
│  ├── Encryption at rest (AES-256)                           │
│  ├── Encryption in transit (TLS 1.3)                        │
│  ├── PII data masking in logs                               │
│  ├── Regular data backup (daily)                            │
│  └── GDPR-compliant data deletion                           │
│                                                              │
│  API SECURITY                                                │
│  ├── Rate limiting per user/IP                              │
│  ├── Request size limits                                    │
│  ├── Input validation & sanitization                        │
│  ├── CORS configuration                                     │
│  ├── SQL injection prevention (ORM)                         │
│  └── XSS protection                                         │
│                                                              │
│  IMAGE SECURITY                                              │
│  ├── Virus/malware scanning on upload                       │
│  ├── EXIF data stripping (GPS privacy)                      │
│  ├── Image format validation                                │
│  ├── Size & dimension limits                                │
│  └── Signed URLs for private access                         │
│                                                              │
│  INFRASTRUCTURE                                              │
│  ├── DDoS protection (CloudFlare)                           │
│  ├── WAF (Web Application Firewall)                         │
│  ├── VPC for internal services                              │
│  ├── Secret management (GCP Secret Manager)                 │
│  └── Regular security audits                                │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### Privacy Policy Highlights

1. **Data Petani Adalah Milik Petani**
   - Foto tanaman hanya digunakan untuk diagnosis, tidak dijual
   - Petani bisa menghapus semua datanya kapan saja
   - Data lokasi hanya digunakan untuk konteks cuaca & rekomendasi

2. **Anonymized Analytics**
   - Data agregat untuk pemetaan penyakit tanaman (tanpa identitas petani)
   - Digunakan untuk meningkatkan akurasi AI dan sistem peringatan

3. **Third-Party Sharing**
   - Tidak ada penjualan data ke pihak ketiga
   - Sharing data ke Gemini API sesuai kebijakan Google
   - Opsi opt-out untuk penggunaan data dalam pelatihan model

---

## 🗺 Roadmap Pengembangan

### Phase 1: MVP (Minimum Viable Product) — Bulan 1-3

```
MILESTONE 1: Foundation (Bulan 1)
═════════════════════════════════
✅ Setup project & infrastructure
✅ Auth system (phone + OTP)
✅ Basic user profile
✅ Farm & plot management
✅ Image upload pipeline
✅ Basic Gemini integration
✅ Database schema & migrations

MILESTONE 2: Core Features (Bulan 2)
═════════════════════════════════════
✅ Plant Scanner (camera + gallery)
✅ AI Diagnosis Engine (basic)
✅ AI Recommendation System (basic)
✅ Scan history
✅ Basic dashboard

MILESTONE 3: MVP Launch (Bulan 3)
═════════════════════════════════
✅ FarmerBot (basic chatbot)
✅ Push notifications
✅ Offline mode (basic)
✅ UI polish & testing
✅ Beta launch ke 100 petani
✅ Feedback collection
```

### Phase 2: Enhancement — Bulan 4-6

```
MILESTONE 4: Intelligence (Bulan 4)
════════════════════════════════════
□ Smart Urgency System
□ Weather integration (BMKG)
□ Improved prompt engineering
□ Multi-photo diagnosis
□ Knowledge base expansion (200+ penyakit)

MILESTONE 5: Engagement (Bulan 5)
═════════════════════════════════
□ Digital Farm Journal
□ Crop Calendar
□ Activity reminders
□ Diagnosis accuracy improvement
□ Community forum (basic)

MILESTONE 6: Growth (Bulan 6)
═════════════════════════════
□ Premium features
□ Analytics dashboard
□ Regional disease heatmap
□ Public launch
□ Marketing campaign
□ Target: 10,000 pengguna aktif
```

### Phase 3: Scale — Bulan 7-12

```
MILESTONE 7: Advanced AI (Bulan 7-8)
═════════════════════════════════════
□ Voice input/output (Speech-to-Text)
□ Multi-language (Jawa, Sunda)
□ AI accuracy > 85%
□ Soil analysis (foto)
□ Predictive analytics

MILESTONE 8: Ecosystem (Bulan 9-10)
═══════════════════════════════════
□ Marketplace integration
□ Market price tracker
□ Toko pertanian partnership
□ Extension worker dashboard
□ Government data integration

MILESTONE 9: Innovation (Bulan 11-12)
═════════════════════════════════════
□ IoT sensor integration
□ Drone imagery analysis
□ Satellite crop monitoring
□ AI model fine-tuning
□ Target: 100,000 pengguna aktif
```

### Phase 4: National Scale — Tahun 2+

```
□ Ekspansi ke seluruh Indonesia (34 provinsi)
□ Partnership dengan Kementerian Pertanian
□ Integration with SIMPI (Sistem Informasi Pertanian Indonesia)
□ AI model yang di-fine-tune dengan data Indonesia
□ White-label solution untuk perusahaan agribisnis
□ API marketplace untuk developer pertanian
□ Target: 1,000,000 pengguna aktif
```

---

## 💰 Monetisasi & Bisnis Model

### Revenue Streams

```
┌──────────────────────────────────────────────────────────────┐
│                   BUSINESS MODEL CANVAS                      │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  FREE TIER (Petani Kecil)                                   │
│  ├── 5 scan per bulan                                       │
│  ├── Basic FarmerBot chat (20 pesan/hari)                   │
│  ├── 1 lahan                                                │
│  ├── Basic weather info                                     │
│  └── Community forum access                                 │
│                                                              │
│  PREMIUM TIER — Rp 29.900/bulan                             │
│  ├── Unlimited scan                                         │
│  ├── Unlimited FarmerBot chat                               │
│  ├── Multi-lahan management                                 │
│  ├── Smart Urgency alerts                                   │
│  ├── Digital Farm Journal                                   │
│  ├── Crop Calendar                                          │
│  ├── Detailed analytics                                     │
│  ├── Priority AI processing                                 │
│  └── Weather forecast 14 hari                               │
│                                                              │
│  ENTERPRISE TIER — Custom pricing                           │
│  ├── Multi-user accounts                                    │
│  ├── Custom dashboard                                       │
│  ├── API access                                             │
│  ├── White-label option                                     │
│  ├── Dedicated support                                      │
│  └── Custom AI training                                     │
│                                                              │
│  ADDITIONAL REVENUE                                         │
│  ├── Sponsored product recommendations (non-intrusive)      │
│  ├── Partnership with toko pertanian                        │
│  ├── Data analytics for agribusiness (anonymized)           │
│  ├── Government partnerships (subsidi/program)              │
│  └── Marketplace commission (future)                        │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### Unit Economics (Estimasi)

```
PER USER PER MONTH:
═══════════════════

Revenue (Premium):     Rp 29.900
──────────────────────────────
Costs:
├── Gemini API (~30 scans):  Rp  5.000
├── Cloud infrastructure:     Rp  2.000
├── SMS/OTP:                  Rp    500
├── Storage (images):         Rp  1.000
├── Support & maintenance:    Rp  3.000
├── Marketing (amortized):    Rp  5.000
└── Total Cost:               Rp 16.500
──────────────────────────────
Gross Margin:                 Rp 13.400 (44.8%)
```

---

## 📊 Metrik & KPI

### Product Metrics

| Metric | Target (3 bulan) | Target (6 bulan) | Target (12 bulan) |
|--------|-------------------|-------------------|-------------------|
| MAU (Monthly Active Users) | 1,000 | 10,000 | 100,000 |
| DAU/MAU Ratio | 30% | 35% | 40% |
| Scans per User per Month | 5 | 8 | 12 |
| Chat Messages per User/Day | 3 | 5 | 8 |
| Conversion Free→Premium | 5% | 8% | 12% |
| Retention (D30) | 40% | 50% | 60% |
| NPS Score | 30 | 50 | 70 |

### AI Quality Metrics

| Metric | Target (MVP) | Target (6 bulan) | Target (12 bulan) |
|--------|-------------|-------------------|-------------------|
| Diagnosis Accuracy (Top-1) | 70% | 80% | 85% |
| Diagnosis Accuracy (Top-3) | 85% | 90% | 95% |
| Average Response Time | < 15s | < 10s | < 5s |
| User Satisfaction (diagnosis) | 3.5/5 | 4.0/5 | 4.5/5 |
| Recommendation Helpfulness | 70% | 80% | 85% |
| False Positive Rate | < 15% | < 10% | < 5% |

### Technical Metrics

| Metric | Target |
|--------|--------|
| API Uptime | 99.5% |
| API Response Time (p95) | < 2s |
| AI Processing Time (p95) | < 15s |
| Error Rate | < 1% |
| Crash-Free Sessions | > 99% |

---

## 👨‍💻 Tim & Kontribusi

### Struktur Tim yang Dibutuhkan

```
CORE TEAM (MVP):
════════════════

🎯 Product Manager (1)
├── Product roadmap & prioritization
├── User research & persona management
└── Stakeholder communication

📱 Mobile Developer (2)
├── Flutter development
├── Camera & image handling
└── Offline-first architecture

🖥️ Backend Developer (2)
├── API development (NestJS)
├── Database design & optimization
└── Cloud infrastructure

🤖 AI/ML Engineer (1)
├── Gemini integration
├── Prompt engineering & optimization
├── Knowledge base curation
└── Response quality monitoring

🎨 UI/UX Designer (1)
├── User research & testing
├── Interface design
├── Design system maintenance
└── Accessibility audit

🧪 QA Engineer (1)
├── Manual & automated testing
├── AI response quality testing
└── Performance testing

EXTENDED TEAM (Post-MVP):
═════════════════════════

📊 Data Analyst (1)
├── User behavior analysis
├── AI metrics monitoring
└── Business intelligence

🌾 Agricultural Expert / Consultant (1-2)
├── Knowledge base validation
├── Diagnosis accuracy verification
├── Content curation
└── Partnership with research institutions

📢 Growth / Marketing (1)
├── User acquisition
├── Community management
├── Partnership development
└── Content marketing
```

### Kontribusi Open Source

Agrotani berkomitmen untuk berkontribusi ke ekosistem open source:

1. **Knowledge Base Pertanian Indonesia** — Database terbuka penyakit dan hama tanaman Indonesia
2. **Prompt Engineering Templates** — Template prompt untuk domain pertanian
3. **Indonesian Agricultural NLP Dataset** — Dataset bahasa pertanian Indonesia
4. **Plant Disease Image Dataset** — Dataset gambar penyakit tanaman tropis

---

## ❓ FAQ

### Untuk Petani

**Q: Apakah Agrotani gratis?**
> A: Ya! Agrotani menyediakan fitur dasar secara gratis, termasuk 5 scan per bulan dan akses ke FarmerBot. Untuk fitur lengkap, tersedia paket Premium dengan harga terjangkau.

**Q: Bagaimana jika saya tidak punya internet?**
> A: Agrotani tetap bisa digunakan untuk melihat riwayat diagnosis, buku tani digital, dan kalender tanam. Foto yang diambil saat offline akan otomatis dianalisis begitu terhubung ke internet.

**Q: Seberapa akurat diagnosis Agrotani?**
> A: Agrotani memiliki tingkat akurasi 70-85% tergantung kualitas foto dan jenis penyakit. Kami selalu menampilkan tingkat keyakinan agar Anda bisa memutuskan apakah perlu konsultasi lebih lanjut.

**Q: Apakah foto saya aman?**
> A: Ya! Foto Anda dienkripsi dan hanya digunakan untuk diagnosis. Kami tidak menjual data Anda ke pihak ketiga.

**Q: Tanaman apa saja yang didukung?**
> A: Saat ini kami mendukung padi, jagung, cabai, tomat, kedelai, bawang, dan terus bertambah. FarmerBot bisa menjawab pertanyaan tentang tanaman apa pun.

**Q: Apakah bisa dipakai di HP jadul?**
> A: Agrotani dirancang untuk bisa berjalan di smartphone Android dengan RAM minimal 2 GB dan Android 6.0 ke atas.

### Untuk Developer

**Q: Bagaimana cara berkontribusi?**
> A: Lihat [CONTRIBUTING.md](./CONTRIBUTING.md) untuk panduan kontribusi. Kami menerima kontribusi dalam bentuk kode, knowledge base, dan testing.

**Q: Apakah API Agrotani tersedia untuk publik?**
> A: API publik direncanakan untuk Phase 3. Saat ini masih dalam tahap pengembangan internal.

**Q: Tech stack apa yang digunakan?**
> A: Flutter (mobile), Next.js (web), NestJS + FastAPI (backend), PostgreSQL (database), Google Gemini (AI). Detail lengkap ada di bagian [Tech Stack](#-tech-stack).

### Untuk Stakeholder

**Q: Apa yang membedakan Agrotani dari aplikasi pertanian lain?**
> A: Agrotani mengintegrasikan AI diagnosis real-time + chatbot + sistem peringatan dini dalam satu platform. Dirancang khusus untuk petani Indonesia dengan bahasa dan konteks lokal.

**Q: Berapa biaya pengembangan yang dibutuhkan?**
> A: MVP (3 bulan) diestimasi membutuhkan biaya Rp 300-500 juta (tim + infrastruktur). Detail bisa didiskusikan lebih lanjut.

**Q: Bagaimana rencana monetisasi?**
> A: Model freemium (gratis + premium), partnership B2B dengan perusahaan agribisnis, dan data analytics. Detail di bagian [Monetisasi](#-monetisasi--bisnis-model).

**Q: Target market size?**
> A: Indonesia memiliki 33+ juta petani, dengan pertumbuhan smartphone penetration di pedesaan. TAM estimasi Rp 10 triliun/tahun untuk layanan pertanian digital.

---

## 📜 Lisensi

```
MIT License

Copyright (c) 2026 Agrotani

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```

---

## 📞 Kontak & Link

| Platform | Link |
|----------|------|
| 🌐 Website | [www.agrotani.id](https://www.agrotani.id) |
| 📧 Email | hello@agrotani.id |
| 📱 Play Store | Coming Soon |
| 🍎 App Store | Coming Soon |
| 💬 WhatsApp | +62-XXX-XXXX-XXXX |
| 📷 Instagram | @agrotani.id |

---

<p align="center">
  <strong>🌾 Agrotani — Memberdayakan Petani dengan Teknologi AI 🤖</strong>
</p>

<p align="center">
  <em>Built with ❤️ for Indonesian Farmers</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Made%20in-Indonesia%20🇮🇩-red" alt="Made in Indonesia"/>
</p>
