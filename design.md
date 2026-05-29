# 🎨 DESIGN REVIEW: Agrotani MVP — Perspektif Desainer + Petani

> **Peran**: UI/UX Designer yang mereview MVP.md
> **Sudut pandang**: Saya membayangkan diri sebagai **Pak Harto, 52 tahun**, petani padi di Karawang, HP Redmi 9A (layar 6.53", RAM 2GB), mata mulai rabun, jari kasar dan besar, sering di sawah siang hari (layar susah dilihat), sinyal 3G kadang hilang.
> **Pertanyaan utama**: _"Apakah app ini bisa saya pakai tanpa diajari berkali-kali?"_

---

## 📋 Daftar Isi

1. [Hal yang Sudah Baik](#1--hal-yang-sudah-baik)
2. [Masalah Kritis — Harus Diperbaiki](#2--masalah-kritis--harus-diperbaiki)
3. [Hal yang Perlu Ditambahkan](#3--hal-yang-perlu-ditambahkan)
4. [Hal yang Perlu Dihapus / Disederhanakan](#4--hal-yang-perlu-dihapus--disederhanakan)
5. [Wireframe per Screen — Revisi](#5--wireframe-per-screen--revisi)
6. [Design System yang Diperbarui](#6--design-system-yang-diperbarui)
7. [Panduan Copywriting](#7--panduan-copywriting--bahasa-di-app)
8. [Checklist Design Final](#8--checklist-design-final)

---

## 1. ✅ Hal yang Sudah Baik

Sebelum kritik, ini yang sudah benar di MVP:

| Aspek | Apa yang Baik | Catatan |
|-------|---------------|---------|
| Fokus | Cuma 4 fitur. Tidak overload | Petani tidak butuh 20 menu |
| Warna Primary | Hijau (#2E7D32) = familiar untuk petani | Warna sawah, alam, pertanian |
| Bottom Navigation | 4 tab saja, tidak berlebihan | Mudah dijangkau ibu jari |
| Quick Reply di chat | Petani tidak perlu mikir mau ngetik apa | Sangat penting dipertahankan |
| Loading state direncanakan | Petani butuh tau "app lagi ngapain" | Jangan pernah blank screen |

**Tapi...** hal-hal baik ini belum cukup. Ada banyak yang harus diperbaiki.

---

## 2. 🔴 Masalah Kritis — Harus Diperbaiki

### 2.1 Auth: Email + Password itu MUSUH Petani

**Masalah di MVP saat ini:**
MVP pakai `POST /auth/register { name, email, password }`. Ini artinya petani harus:
1. Punya email (banyak petani 50+ tahun **tidak punya email**)
2. Bikin password (dan harus ingat)
3. Ketik email yang formatnya rumit (petani sering typo `@` dan `.com`)

**Ini satu-satunya hal yang bisa bikin petani langsung uninstall app.**

**Solusi — tetap pakai JWT tapi ubah input:**
```
OPSI 1 (Rekomendasi — paling realistis untuk MVP):
├── Register/Login pakai NOMOR HP saja
├── Verifikasi: skip OTP di MVP, langsung trust (ini demo bukan production)
├── Backend tetap JWT, tapi identifier-nya nomor HP bukan email
├── Petani cuma perlu ketik: Nama + No HP → Selesai
│
│   ┌──────────────────────────────────┐
│   │       🌾 AGROTANI                │
│   │                                  │
│   │  Nama Anda:                      │
│   │  ┌────────────────────────────┐  │
│   │  │ Harto                     │  │
│   │  └────────────────────────────┘  │
│   │                                  │
│   │  Nomor HP:                       │
│   │  ┌────────────────────────────┐  │
│   │  │ 0812-3456-7890            │  │
│   │  └────────────────────────────┘  │
│   │                                  │
│   │  ┌────────────────────────────┐  │
│   │  │        MASUK  →           │  │
│   │  └────────────────────────────┘  │
│   │                                  │
│   └──────────────────────────────────┘
│
│   → Pertama kali: auto-register
│   → Sudah pernah: auto-login
│   → 1 tombol. 2 field. Selesai.

OPSI 2 (Kalau mau lebih cepat lagi):
├── Google Sign-In (satu tap)
├── Tapi banyak petani HP-nya Google account disetup oleh anaknya
└── Jadi kurang reliable. Nomor HP lebih universal.
```

**Perubahan di Prisma schema:**
```diff
model User {
  id        String   @id @default(uuid())
  name      String
- email     String   @unique
- password  String
+ phone     String   @unique
  createdAt DateTime @default(now())
}
```

**Ini 0 effort tambahan tapi impact-nya BESAR.** Ubah dari email+password ke nomor HP saja.

---

### 2.2 Font 16sp itu KURANG BESAR

**Masalah:** MVP bilang "Font minimal 16sp". Untuk developer muda berumur 20an, 16sp itu cukup. Untuk Pak Harto yang matanya mulai rabun dan lagi di sawah tengah hari (silau), **16sp itu kayak semut.**

**Solusi — naikkan standar minimum:**
```
FONT SIZE BARU:
├── Judul screen  : 24sp Bold
├── Sub-judul     : 20sp SemiBold
├── Body text     : 18sp Regular      ← naik dari 16sp
├── Caption/label : 15sp Regular
├── Tombol text   : 18sp SemiBold
└── Input hint    : 16sp Regular (ini satu-satunya yang 16sp)
```

**Aturan tambahan:**
- Jangan pernah pakai font di bawah 14sp di manapun
- Di hasil diagnosis, nama penyakit harus **24sp Bold** (ini info paling penting)
- Angka keparahan/confidence harus besar dan berwarna

---

### 2.3 Tombol 48dp MASIH KURANG

**Masalah:** 48dp itu standar Google Material Design untuk jari normal. Jari petani itu besar, kasar, kadang basah (habis megang tanaman). 48dp sering miss-tap.

**Solusi:**
```
TOUCH TARGET BARU:
├── Tombol utama (CTA)  : 56dp tinggi, full width
├── Icon button          : 52x52dp
├── List item (tappable) : 72dp tinggi minimum
├── Bottom nav item      : 64dp tinggi
├── Quick reply chip     : 44dp tinggi, padding horizontal 20dp
└── Spacing antar tombol : minimal 12dp (biar ga salah tekan)
```

---

### 2.4 Tidak Ada Panduan Foto (Camera Guide)

**Masalah:** Di MVP, scan screen cuma "kamera + gallery picker". Petani buka kamera → bingung → foto asal-asalan → hasilnya jelek → AI salah diagnosis → petani kecewa → uninstall.

**Foto yang baik itu 50% dari akurasi diagnosis.**

**Solusi — tambah Camera Guidance:**
```
┌──────────────────────────────────┐
│  ← Scan Tanaman                  │
│                                  │
│  ┌──────────────────────────────┐│
│  │                              ││
│  │        CAMERA VIEW           ││
│  │                              ││
│  │     ┌────────────────┐       ││
│  │     │   ╔══════════╗ │       ││
│  │     │   ║  Arahkan ║ │       ││
│  │     │   ║  daun ke ║ │       ││
│  │     │   ║  kotak   ║ │       ││
│  │     │   ║  ini     ║ │       ││
│  │     │   ╚══════════╝ │       ││
│  │     └────────────────┘       ││
│  │                              ││
│  │  💡 "Dekatkan ke bagian     ││
│  │      yang bermasalah"        ││
│  └──────────────────────────────┘│
│                                  │
│  ┌──────┐              ┌──────┐ │
│  │  📷  │              │ 🖼️  │ │
│  │ FOTO │              │Galeri│ │
│  └──────┘              └──────┘ │
│                                  │
│  Tips: Pastikan cahaya cukup ☀️  │
└──────────────────────────────────┘
```

**Yang ditambahkan:**
- Overlay kotak fokus (guide frame) di tengah kamera
- Teks instruksi di bawah camera view, font besar
- Tips singkat: "Pastikan cahaya cukup" / "Foto dari jarak 15-20 cm"
- Auto-detect: kalau terlalu gelap → tampilkan warning "Terlalu gelap ⚠️"

---

### 2.5 Hasil Diagnosis Terlalu "Flat"

**Masalah:** MVP cuma bilang tampilkan "Card diagnosis (nama penyakit, keparahan, confidence)". Tapi tidak dijelaskan **hierarki visual**-nya. Kalau semua info ditampilkan rata, petani bingung mana yang penting.

**Solusi — hierarki visual yang jelas:**
```
┌──────────────────────────────────┐
│  ← Hasil Scan                    │
│                                  │
│  ┌──────────────────────────────┐│
│  │ 📸 [Foto yang discan]       ││
│  │ Hari ini, 14:32             ││
│  └──────────────────────────────┘│
│                                  │
│  ┌──────────────────────────────┐│
│  │                              ││
│  │  ⬤  BLAS (Blast)            ││  ← 24sp BOLD, warna sesuai severity
│  │                              ││
│  │  Keparahan: ██████░░░░       ││  ← Progress bar visual, BUKAN angka
│  │             SEDANG           ││
│  │                              ││
│  │  Tanaman Bapak kena          ││  ← Bahasa sederhana, 18sp
│  │  penyakit jamur. Kalau       ││
│  │  tidak diobati, bisa         ││
│  │  menyebar dalam 3 hari.     ││
│  │                              ││
│  └──────────────────────────────┘│
│                                  │
│  ┌──────────────────────────────┐│
│  │  💊 YANG HARUS DILAKUKAN    ││  ← Section header hijau
│  │                              ││
│  │  1️⃣ Semprot fungisida       ││  ← Step-by-step, numbered
│  │     Beam 75 WP               ││
│  │     1.5 gram per liter air   ││
│  │                              ││
│  │  2️⃣ Kurangi pupuk Urea 50%  ││
│  │                              ││
│  │  3️⃣ Scan lagi 3 hari        ││
│  │     kemudian                  ││
│  │                              ││
│  └──────────────────────────────┘│
│                                  │
│  ┌──────────────────────────────┐│
│  │ 💬 Masih bingung?           ││
│  │ [Tanya FarmerBot →]          ││  ← Langsung buka chat dengan
│  └──────────────────────────────┘│    konteks diagnosis ini
│                                  │
│  Diagnosis ini membantu?         │
│  [👍 Ya] [👎 Tidak]             │  ← Feedback, 1 tap
│                                  │
├──────────────────────────────────┤
│  🏠    📷    💬    👤           │
└──────────────────────────────────┘
```

**Prinsip hierarki:**
1. **Paling atas**: Foto (konteks visual)
2. **Paling besar**: Nama penyakit (info utama)
3. **Visual**: Keparahan pakai progress bar + warna, BUKAN angka persen
4. **Bahasa manusia**: Penjelasan singkat, bukan istilah latin
5. **Actionable**: Langkah-langkah yang bisa dilakukan sekarang
6. **Escape hatch**: "Masih bingung? Tanya FarmerBot"
7. **Feedback**: Thumbs up/down, satu tap

---

### 2.6 Home Screen Terlalu Kosong

**Masalah:** MVP cuma rencana: "Widget scan terakhir, tombol quick scan, tips harian, statistik sederhana." Ini terlalu generic. Home screen adalah **kesan pertama setiap kali buka app**.

**Solusi — Home yang langsung berguna:**
```
┌──────────────────────────────────┐
│                                  │
│  Halo, Pak Harto! 👋            │  ← Sapaan personal, 20sp
│  Apa kabar tanaman hari ini?     │  ← 16sp, abu-abu
│                                  │
│  ╔══════════════════════════════╗│
│  ║  📷 SCAN TANAMAN            ║│  ← TOMBOL PALING BESAR
│  ║                              ║│     Hijau, 72dp tinggi
│  ║  Foto tanaman yang sakit →   ║│     Ini CTA #1
│  ╚══════════════════════════════╝│
│                                  │
│  ╔══════════════════════════════╗│
│  ║  💬 TANYA FARMERBOT         ║│  ← TOMBOL KEDUA
│  ║                              ║│     Putih + border hijau
│  ║  Mau tanya soal pertanian →  ║│     56dp tinggi
│  ╚══════════════════════════════╝│
│                                  │
│  ── Scan Terakhir ──────────────│
│                                  │
│  ┌──────────────────────────────┐│
│  │ 📸 Padi · Blas · SEDANG     ││  ← Tile scan terakhir
│  │ 2 hari lalu    [Lihat →]    ││     Tap = buka detail
│  └──────────────────────────────┘│
│  ┌──────────────────────────────┐│
│  │ 📸 Jagung · Sehat · BAIK    ││
│  │ 5 hari lalu    [Lihat →]    ││
│  └──────────────────────────────┘│
│                                  │
│  ── 💡 Tips Hari Ini ───────────│
│  ┌──────────────────────────────┐│
│  │ "Penyemprotan paling baik   ││
│  │  dilakukan pagi sebelum     ││
│  │  jam 9 atau sore setelah    ││
│  │  jam 4."                    ││
│  └──────────────────────────────┘│
│                                  │
├──────────────────────────────────┤
│  🏠    📷    💬    👤           │
└──────────────────────────────────┘
```

**Kenapa layout ini lebih baik:**
- 2 tombol besar di atas = petani langsung tau "saya bisa ngapain"
- Scan terakhir = petani bisa cek lagi hasil kemarin tanpa cari-cari
- Tips = konten yang berguna, bikin app terasa "hidup"
- **Tidak ada statistik/angka** di home. Petani tidak butuh "Total scan: 5"

---

## 3. 🟢 Hal yang Perlu Ditambahkan

### 3.1 Splash Screen + Branding

**Saat ini:** Tidak disebutkan di MVP.

**Tambahkan:**
```
┌──────────────────────────────────┐
│                                  │
│                                  │
│                                  │
│            🌾                    │
│          AGROTANI                │  ← Logo + nama, 32sp
│                                  │
│    Asisten Cerdas Petani         │  ← Tagline, 16sp
│                                  │
│         ◽◽◽ loading              │
│                                  │
│                                  │
└──────────────────────────────────┘

Durasi: 2 detik → auto ke home (jika sudah login) atau login screen
```

Splash penting karena:
- Kasih kesan profesional (bukan app abal-abal)
- Waktu untuk load data awal
- Brand recognition

---

### 3.2 Onboarding Pertama Kali (First Time Only)

**Saat ini:** Tidak ada. Petani langsung dilempar ke login screen.

**Tambahkan 2 slide saja (jangan banyak-banyak):**
```
Slide 1:
┌──────────────────────────────────┐
│                                  │
│        📸 → 🤖 → 💊            │  ← Ilustrasi/ikon besar
│                                  │
│   "Foto Tanaman yang Sakit,     │
│    Langsung Dapat Solusi"        │
│                                  │
│            ● ○                   │
│                                  │
│  ┌────────────────────────────┐  │
│  │      LANJUT  →             │  │
│  └────────────────────────────┘  │
│  Lewati                          │
└──────────────────────────────────┘

Slide 2:
┌──────────────────────────────────┐
│                                  │
│            💬                    │
│                                  │
│   "Bingung Soal Tanaman?        │
│    Tanya FarmerBot Kapan Saja"   │
│                                  │
│            ○ ●                   │
│                                  │
│  ┌────────────────────────────┐  │
│  │      MULAI  →              │  │
│  └────────────────────────────┘  │
└──────────────────────────────────┘
```

2 slide. Bukan 5. Petani tidak sabar baca tutorial panjang.

---

### 3.3 Empty States yang Manusiawi

**Saat ini:** MVP menyebutkan "empty states" tapi tidak ada detail.

**Contoh empty state yang baik:**
```
Riwayat Scan (kosong):
┌──────────────────────────────────┐
│                                  │
│          📸                      │
│    Belum ada scan                │
│                                  │
│    Yuk, foto tanaman             │
│    Anda yang pertama!            │
│                                  │
│  ┌────────────────────────────┐  │
│  │   📷  Scan Sekarang       │  │
│  └────────────────────────────┘  │
└──────────────────────────────────┘

Chat (kosong):
┌──────────────────────────────────┐
│                                  │
│          🤖                      │
│    Halo! Saya FarmerBot          │
│                                  │
│    Mau tanya apa hari ini?       │
│                                  │
│  [Tanaman saya kuning]           │  ← Quick reply langsung
│  [Ada hama di sawah]             │
│  [Kapan waktu pupuk?]            │
│                                  │
└──────────────────────────────────┘
```

**Prinsip:** Setiap layar kosong harus punya **1 ajakan** yang jelas. Jangan pernah cuma teks "Belum ada data".

---

### 3.4 Konfirmasi Sebelum Scan (Preview)

**Saat ini:** "Preview foto → konfirmasi → kirim". Tapi tidak ada detail UI-nya.

**Tambahkan preview screen yang jelas:**
```
┌──────────────────────────────────┐
│  ← Preview                       │
│                                  │
│  ┌──────────────────────────────┐│
│  │                              ││
│  │      [Foto yang diambil]     ││
│  │                              ││
│  │                              ││
│  └──────────────────────────────┘│
│                                  │
│  Foto sudah jelas?               │
│                                  │
│  ┌──────────────────────────────┐│
│  │   ✅  YA, ANALISIS          ││  ← Tombol hijau besar
│  └──────────────────────────────┘│
│  ┌──────────────────────────────┐│
│  │   📷  FOTO ULANG            ││  ← Tombol putih
│  └──────────────────────────────┘│
│                                  │
└──────────────────────────────────┘
```

2 tombol. Jelas. Besar. Tidak ada kebingungan.

---

### 3.5 Error Screen yang Tidak Menakutkan

**Saat ini:** "Error handling UI (no internet, 500 error, timeout)" — tapi tidak ada detail.

**Jangan pernah tampilkan:**
- ❌ "Error 500: Internal Server Error"
- ❌ "Connection timed out"
- ❌ Layar putih/blank

**Tampilkan ini:**
```
Tidak ada internet:
┌──────────────────────────────────┐
│                                  │
│          📡                      │
│                                  │
│   Tidak ada jaringan internet    │
│                                  │
│   Pastikan WiFi atau data        │
│   seluler Anda menyala           │
│                                  │
│  ┌────────────────────────────┐  │
│  │   🔄  Coba Lagi            │  │
│  └────────────────────────────┘  │
└──────────────────────────────────┘

Scan gagal / timeout:
┌──────────────────────────────────┐
│                                  │
│          😕                      │
│                                  │
│   Maaf, analisis gagal           │
│                                  │
│   Coba lagi atau hubungi         │
│   FarmerBot untuk bantuan        │
│                                  │
│  ┌────────────────────────────┐  │
│  │   🔄  Coba Lagi            │  │
│  └────────────────────────────┘  │
│  ┌────────────────────────────┐  │
│  │   💬  Tanya FarmerBot      │  │
│  └────────────────────────────┘  │
└──────────────────────────────────┘
```

**Prinsip:**
- Bahasa manusia, bukan kode error
- Selalu ada tombol aksi (coba lagi / alternatif)
- Emoji besar sebagai ikon (loading cepat, tidak perlu download gambar)

---

### 3.6 Loading State yang Informatif

**Saat ini:** "Loading screen dengan progress indicator" — terlalu vague.

**Scan loading harus seperti ini:**
```
┌──────────────────────────────────┐
│                                  │
│                                  │
│          🔍                      │
│                                  │
│   Sedang menganalisis            │
│   tanaman Anda...                │
│                                  │
│   ████████░░░░░░░░  50%          │  ← Progress bar (fake tapi reassuring)
│                                  │
│   💡 Tahukah Anda?              │
│   "Padi butuh 2000-3000 liter   │
│    air untuk hasilkan 1 kg       │
│    beras"                        │
│                                  │
│                                  │
└──────────────────────────────────┘
```

**Kenapa penting:**
- Progress bar (bahkan kalau fake/indeterminate) membuat user merasa sesuatu sedang terjadi
- Tips random menghibur dan mendidik selama menunggu
- Tanpa ini, petani akan pencet tombol back karena mengira app hang

---

## 4. 🗑️ Hal yang Perlu Dihapus / Disederhanakan

### 4.1 Hapus Tab "History" dari Bottom Navigation

**Masalah:** MVP punya 4 tab: Home, Scan, Chat, Profil. Tapi ada juga screen History. Dimana History ini di navigasi?

**Solusi:** History **jangan jadi tab sendiri**. Masukkan ke Home screen sebagai section "Scan Terakhir" (seperti wireframe Home di atas). Kalau mau lihat semua → ada link "Lihat Semua →" yang buka full list.

```
BOTTOM NAV FINAL (4 tab):
├── 🏠 Home      → Dashboard + scan terakhir + tips
├── 📷 Scan      → Langsung buka kamera
├── 💬 Chat      → FarmerBot
└── 👤 Profil    → Info akun + riwayat lengkap + settings
```

Riwayat lengkap masuk ke **Profil screen** sebagai menu item.

---

### 4.2 Hilangkan "Confidence %" dari Tampilan Utama

**Masalah:** Petani tidak paham "Confidence 85%". Mereka akan bingung: "85% apa? Tanaman saya 85% sakit?"

**Solusi:**
```
JANGAN TAMPILKAN:
"Confidence: 85%"

GANTI DENGAN:
"Keyakinan: ████████░░ Cukup Yakin"    (≥70%)
"Keyakinan: █████░░░░░ Kurang Yakin"   (40-69%)
"Keyakinan: ██░░░░░░░░ Perlu Foto Ulang" (<40%)
```

Atau lebih simpel lagi: **jangan tampilkan confidence sama sekali** di layer utama. Cuma tampilkan di "Lihat Detail" buat yang penasaran.

---

### 4.3 Simplify Profil Screen

**Saat ini:** "Profil screen (info user)". Terlalu vague. Petani tidak butuh profil yang ribet.

**Profil screen yang cukup:**
```
┌──────────────────────────────────┐
│  Profil Saya                     │
│                                  │
│  ┌─────┐                        │
│  │ 👤  │  Pak Harto             │
│  └─────┘  0812-3456-7890        │
│            [Edit Nama]           │
│                                  │
│  ──────────────────────────────  │
│                                  │
│  📋 Riwayat Scan          [→]  │
│  ──────────────────────────────  │
│  ℹ️  Tentang Agrotani      [→]  │
│  ──────────────────────────────  │
│  🚪 Keluar                [→]  │
│                                  │
│                                  │
│  Versi 1.0.0                     │
│                                  │
├──────────────────────────────────┤
│  🏠    📷    💬    👤           │
└──────────────────────────────────┘
```

3 menu item. Tidak lebih. Untuk MVP ini cukup.

---

### 4.4 Jangan Multi-Session di Chat (untuk MVP)

**Masalah:** MVP punya `GET /chat/sessions → list sesi chat`. Ini artinya petani harus kelola multiple sesi chat. Terlalu ribet.

**Solusi untuk MVP:**
- 1 user = 1 sesi chat aktif. Titik.
- Buka tab Chat → langsung masuk percakapan. Tidak ada list sesi.
- History chat scrollable ke atas.
- Kalau mau "chat baru" → tombol di atas: "🔄 Mulai Obrolan Baru" (clear history, buat sesi baru)

Ini menghilangkan 1 screen (chat session list) dan menyederhanakan flow.

---

## 5. 📱 Wireframe per Screen — Revisi

### Flow Lengkap (Urutan Screen)

```
FIRST TIME USER:
Splash → Onboarding (2 slide) → Login (nama + no HP) → Home

RETURNING USER:
Splash → Home (auto-login dari saved token)

SCAN FLOW:
Home → [Tap "Scan Tanaman"] → Camera (+ guide) → Preview → Loading → Hasil Diagnosis

CHAT FLOW:
Home → [Tap "Tanya FarmerBot"] → Chat Screen

DARI DIAGNOSIS KE CHAT:
Hasil Diagnosis → [Tap "Tanya FarmerBot"] → Chat (auto-inject konteks diagnosis)
```

### Jumlah Screen Total

```
SCREEN LIST (12 screen):
├── 1. Splash Screen
├── 2. Onboarding (2 slide, 1 PageView)
├── 3. Login Screen
├── 4. Home Screen
├── 5. Scan Camera Screen (+ guide overlay)
├── 6. Scan Preview Screen
├── 7. Scan Loading Screen
├── 8. Scan Result Screen (Diagnosis + Rekomendasi)
├── 9. Chat Screen (FarmerBot)
├── 10. History Screen (list semua scan)
├── 11. Profile Screen
└── 12. Error Screen (reusable)

Widget Reusable:
├── DiagnosisCard
├── RecommendationCard
├── ChatBubble (user + bot variant)
├── QuickReplyChip
├── ScanHistoryTile
├── SeverityBar (progress bar keparahan)
├── LoadingOverlay
└── EmptyState
```

---

## 6. 🎨 Design System yang Diperbarui

### Warna (Revisi)

```
PRIMARY
├── #1B5E20  Hijau Sangat Tua (header, top bar)
├── #2E7D32  Hijau Tua (tombol utama, CTA)
├── #4CAF50  Hijau Medium (icon aktif, sukses)
├── #E8F5E9  Hijau Sangat Muda (background card)

SEVERITY (Keparahan)
├── #4CAF50  Hijau  → Sehat / Ringan
├── #FF9800  Oranye → Sedang
├── #F44336  Merah  → Parah

ACCENT
├── #FF8F00  Amber → highlight, badge
├── #FFF8E1  Amber muda → background tips

NEUTRAL
├── #FFFFFF  Putih (background utama)
├── #F5F5F5  Abu muda (background secondary)
├── #9E9E9E  Abu (teks secondary, hint)
├── #212121  Hitam (teks utama)

SYSTEM
├── #2196F3  Biru (link, info)
├── #F44336  Merah (error, bahaya)
```

**Perubahan dari MVP:**
- Background diganti dari #FAFAFA ke **#FFFFFF** (putih bersih). Lebih terang dan mudah dilihat di siang hari
- Ditambahkan warna severity yang spesifik (hijau-oranye-merah)
- Ditambahkan warna card background (#E8F5E9) agar tidak flat

---

### Typography (Revisi)

```
FONT: Roboto (default Flutter — tidak perlu download, hemat ukuran app)

SCALE:
├── Display   : 28sp / Bold     → Nama penyakit di hasil scan
├── Headline  : 24sp / Bold     → Judul section, judul screen
├── Title     : 20sp / SemiBold → Sub-header, nama item
├── Body      : 18sp / Regular  → Semua body text (NAIK dari 16sp)
├── Label     : 16sp / Medium   → Tombol text, chip
├── Caption   : 14sp / Regular  → Tanggal, info sekunder
└── Overline  : 12sp / Medium   → Badge, tag kecil (JARANG dipakai)

ATURAN:
├── Semua teks harus kontras minimum 4.5:1 (WCAG AA)
├── Bold hanya untuk judul dan nama penyakit
├── Italic TIDAK digunakan (susah dibaca di layar kecil)
└── ALL CAPS hanya untuk badge/label (SEDANG, PARAH)
```

---

### Spacing & Layout

```
SPACING SYSTEM (kelipatan 8):
├── 4dp   → padding internal kecil (di dalam chip)
├── 8dp   → gap antar teks
├── 12dp  → gap antar elemen kecil
├── 16dp  → padding horizontal card
├── 20dp  → padding horizontal screen
├── 24dp  → gap antar section
├── 32dp  → gap besar antar blok

CARD:
├── Border radius: 16dp (rounded, terasa friendly)
├── Elevation/Shadow: 1dp (subtle, tidak mencolok)
├── Padding: 16dp semua sisi
├── Margin antar card: 12dp

SCREEN:
├── Padding horizontal: 20dp kiri-kanan
├── Padding top: 16dp (di bawah app bar)
├── Safe area bottom: aman dari bottom nav
```

---

### Ikon

```
ICON SET: Material Icons (built-in Flutter)
SIZE: 28dp (default), 32dp (di bottom nav), 48dp (di empty state)

PEMETAAN IKON:
├── Home      : Icons.home_rounded
├── Scan      : Icons.camera_alt_rounded
├── Chat      : Icons.chat_bubble_rounded
├── Profil    : Icons.person_rounded
├── Riwayat   : Icons.history_rounded
├── Kembali   : Icons.arrow_back_rounded
├── Kirim     : Icons.send_rounded
├── Foto      : Icons.photo_camera_rounded
├── Galeri    : Icons.photo_library_rounded
├── Sukses    : Icons.check_circle_rounded
├── Warning   : Icons.warning_rounded
├── Error     : Icons.error_rounded
├── Info      : Icons.info_rounded
└── Tips      : Icons.lightbulb_rounded
```

---

## 7. 📝 Panduan Copywriting — Bahasa di App

Ini bagian yang **paling sering diabaikan developer** tapi **paling menentukan** apakah petani paham.

### Aturan Bahasa

```
✅ BAIK (pakai ini):              ❌ JANGAN (hindari ini):
──────────────────────            ──────────────────────
Foto tanaman yang sakit           Upload gambar untuk diagnosis
Hasil scan                        Hasil analisis citra
Tanaman Bapak kena penyakit...    Terdeteksi infeksi patogen...
Semprot obat ini                  Aplikasikan fungisida
Kurangi pupuk                     Reduksi dosis nutrisi
Masih bingung?                    Butuh informasi lebih lanjut?
Tanya FarmerBot                   Konsultasikan ke AI assistant
Coba lagi                         Retry request
Tidak ada internet                Connection failed
Foto kurang jelas                 Low image quality detected
```

### Template Kalimat per Screen

```
LOGIN:
├── Title: "Selamat datang di Agrotani"
├── Subtitle: "Masukkan nama dan nomor HP Anda"
├── Button: "Masuk"
├── Error: "Nomor HP sudah terdaftar" / "Nama harus diisi"

HOME:
├── Greeting: "Halo, Pak {nama}! 👋"
├── Subtitle: "Apa kabar tanaman hari ini?"
├── CTA scan: "Scan Tanaman" + "Foto tanaman yang sakit →"
├── CTA chat: "Tanya FarmerBot" + "Mau tanya soal pertanian →"
├── Section: "Scan Terakhir"
├── Section: "💡 Tips Hari Ini"

SCAN:
├── Title: "Scan Tanaman"
├── Guide: "Arahkan kamera ke bagian yang bermasalah"
├── Tip: "Pastikan cahaya cukup ☀️"
├── Preview: "Foto sudah jelas?"
├── Buttons: "Ya, Analisis" / "Foto Ulang"

LOADING:
├── Title: "Sedang menganalisis tanaman Anda..."
├── Tip: random dari list 10-20 tips pertanian

HASIL:
├── Title: "Hasil Scan"
├── Disease: "{nama penyakit}" (BESAR)
├── Severity: "Keparahan: SEDANG"
├── Explain: "Tanaman Bapak kena penyakit {x}. {penjelasan singkat}."
├── Action header: "💊 Yang Harus Dilakukan"
├── Steps: "1. ... 2. ... 3. ..."
├── Escape: "Masih bingung? Tanya FarmerBot →"
├── Feedback: "Diagnosis ini membantu?" [👍 Ya] [👎 Tidak]

CHAT:
├── Bot greeting: "Halo Pak {nama}! 👋 Saya FarmerBot. Mau tanya apa?"
├── Quick replies: ["Tanaman saya kuning", "Ada hama di sawah", "Kapan waktu pupuk?"]
├── Input hint: "Ketik pertanyaan..."
├── Typing indicator: "FarmerBot sedang mengetik..."

ERROR:
├── No internet: "Tidak ada jaringan internet. Pastikan data seluler menyala."
├── Scan fail: "Maaf, analisis gagal. Coba lagi ya."
├── Server error: "Ada gangguan. Coba beberapa saat lagi."
├── Bad photo: "Foto kurang jelas. Coba foto dari jarak lebih dekat."
```

---

## 8. ✅ Checklist Design Final

### Sebelum Coding

```
HARUS SELESAI SEBELUM NGODING:
├── [ ] Tentukan auth pakai nomor HP (bukan email)
├── [ ] Buat design system: warna, font size, spacing (dari doc ini)
├── [ ] Buat wireframe low-fidelity di kertas/Figma untuk 12 screen
├── [ ] Tulis semua copy/teks yang akan muncul di app
├── [ ] Tentukan semua empty state dan error state
```

### Per Screen (Checklist saat Build)

```
SETIAP SCREEN HARUS PUNYA:
├── [ ] Judul/header yang jelas
├── [ ] Font body minimal 18sp
├── [ ] Tombol minimal 56dp tinggi
├── [ ] Loading state (apa yang tampil saat data belum ada)
├── [ ] Empty state (apa yang tampil kalau datanya kosong)
├── [ ] Error state (apa yang tampil kalau gagal)
├── [ ] Satu CTA yang jelas (tombol utama)
├── [ ] Warna konsisten dari design system
├── [ ] Test di HP layar 5.5" (minimum) — apakah masih nyaman?
└── [ ] Test di luar ruangan siang hari — apakah masih terbaca?
```

### Sebelum Demo

```
FINAL CHECK:
├── [ ] App bisa dipakai oleh orang yang TIDAK pernah lihat app ini
├── [ ] Dari buka app sampai dapat diagnosis: ≤ 5 tap
├── [ ] Semua teks dalam Bahasa Indonesia (tidak ada bahasa Inggris bocor)
├── [ ] Tidak ada layar blank/putih kosong di kondisi apapun
├── [ ] Tombol "Tanya FarmerBot" ada di hasil diagnosis
├── [ ] Feedback thumbs up/down ada di hasil diagnosis
├── [ ] Quick reply buttons ada di chat
├── [ ] Camera guide ada di scan screen
└── [ ] Test sama 1 orang non-teknis: bisa pakai tanpa diajari?
```

---

## 📌 Rangkuman: Yang Harus Berubah di MVP.md

| # | Apa | Dari | Ke |
|---|-----|------|-----|
| 1 | **Auth** | Email + Password | **Nomor HP saja** |
| 2 | **Font minimum** | 16sp | **18sp** |
| 3 | **Touch target** | 48dp | **56dp** |
| 4 | **Camera** | Kamera polos | **+ guide overlay + tips** |
| 5 | **Hasil scan** | Card flat | **Hierarki visual: penyakit besar → bar keparahan → langkah aksi** |
| 6 | **Home screen** | Generic dashboard | **2 CTA besar + scan terakhir + tips** |
| 7 | **Chat session** | Multi session | **1 sesi aktif saja** |
| 8 | **Confidence** | Tampil angka % | **Sembunyikan / ganti teks** |
| 9 | **History** | Screen sendiri | **Masuk ke Home + Profil** |
| 10 | **Splash + Onboarding** | Tidak ada | **Tambahkan** |
| 11 | **Empty & error state** | Disebutkan | **Detail wireframe + copy** |
| 12 | **Bahasa** | Belum diatur | **Panduan copywriting lengkap** |

---

> **Pesan terakhir sebagai designer:**
>
> Satu tes paling simpel untuk menilai UI kamu:
> **Kasih HP-nya ke bapak/ibu kamu. Jangan ajari apa-apa. Lihat mereka bisa scan tanaman tidak.**
>
> Kalau bisa → UI kamu berhasil.
> Kalau bingung → perbaiki sampai bisa.
>
> Itu standarnya. Bukan standar developer. Standar petani.
