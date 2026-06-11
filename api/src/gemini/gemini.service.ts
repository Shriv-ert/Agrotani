import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { OpenAI } from 'openai';

@Injectable()
export class GeminiService {
    private openai: OpenAI;
    private readonly SYSTEM_INSTRUCTION = `
    Kamu adalah AgroAI, asisten pintar untuk petani Indonesia.

Tugasmu:
1. Menganalisis foto hama/penyakit tanaman
2. Memberikan diagnosis yang akurat
3. Memberikan rekomendasi pengobatan yang aman
4. Menjawab pertanyaan seputar pertanian

Aturan:
- Selalu jawab dalam Bahasa Indonesia yang sopan dan mudah dimengerti petani
- Gunakan emoji secara cerdas untuk menjelaskan
- Hindari istilah teknis yang rumit
- Jika tidak yakin, katakan "Saya kurang yakin, sebaiknya konsultasi dengan ahli" dan sarankan tindakan pencegahan umum
- Jangan pernah menyebut nama produk komersial atau merek obat tertentu
- Berikan rekomendasi yang bersifat umum dan alami sebisa mungkin
- Jika ada unsur bahaya pada foto (misal api, racun), berikan peringatan tegas
- Selalu sertakan disclaimer: "Hasil ini hanya perkiraan. Untuk kepastian, konsultasikan dengan penyuluh pertanian setempat"
- pesan tidak menggunakan format markdown, jangan gunakan # untuk title output pesan

Selalu jawab dalam format markdown berikut untuk analisis tanaman:
**Diagnosis:** [nama penyakit]
**Keparahan:** [Ringan/Sedang/Parah]
**Keyakinan:** [angka]%
**Rekomendasi:**
- [langkah 1]
- [langkah 2]
**Catatan:** [catatan penting]

Untuk obrolan biasa (chat), berikan jawaban langsung dalam teks biasa tanpa format khusus.
`;
    constructor(private readonly config: ConfigService) {
        const apiKey = this.config.get<string>('GEMINI_API_KEY');
        if(!apiKey){ 
            throw new Error('GEMINI_API_KEY is not defined');
        }
        
        // Initialize client with SumoPod AI using OpenAI SDK
        this.openai = new OpenAI({
            apiKey: apiKey,
            baseURL: 'https://ai.sumopod.com/v1'
        });
    }

    async analyzeImage(imageBase64: string, mimeType: string){
        const prompt = `
        Analisis foto tanaman ini. Berikan jawaban HANYA dalam format markdown berikut:
**Diagnosis:** [nama penyakit atau masalah yang terdeteksi]
**Keparahan:** [Ringan / Sedang / Parah]
**Keyakinan:** [angka keyakinan, misal 85%]
**Rekomendasi:**
- [Langkah pencegahan/pengobatan 1]
- [Langkah lanjutan 2]
**Catatan:** [Hal penting yang perlu diperhatikan]

Jika foto tidak jelas atau bukan tanaman, bilang bahwa foto perlu diambil ulang pada bagian Diagnosis, dan beri tingkat Keparahan: Tidak Diketahui, Keyakinan: 0%.
Konteks: Tanaman di Indonesia, iklim tropis.
        `;
        let cleanBase64 = imageBase64;
        if (cleanBase64.includes(',')) {
            cleanBase64 = cleanBase64.split(',')[1];
        }
        
        const response = await this.openai.chat.completions.create({
            model: "gemini/gemini-2.5-pro",
            messages: [
                { role: "system", content: this.SYSTEM_INSTRUCTION },
                {
                    role: "user",
                    content: [
                        { type: "text", text: prompt },
                        {
                            type: "image_url",
                            image_url: {
                                url: `data:${mimeType};base64,${cleanBase64}`
                            }
                        }
                    ]
                }
            ],
            max_tokens: 10000
        });

        return response.choices[0].message?.content || "Gagal menganalisis gambar.";
    }

    async chat(message: string, history: any[], user?: { name: string, aboutMe: string | null } | null){
        let userContext = '';
        if (user) {
            userContext = `\nInformasi User:\n- Nama: ${user.name}\n- Tentang saya: ${user.aboutMe || 'Belum diisi'}\nSelalu sebut nama user setiap kali berbicara`;
        }
        
        const chatInstruction = `${this.SYSTEM_INSTRUCTION}\n\nKamu adalah FarmerBot, teman ngobrol petani yang ramah.${userContext}
Jawab pertanyaan tentang pertanian dengan bahasa sederhana.
Berikan jawaban yang praktis dan bisa langsung dilakukan.
Jika user kirim foto, analisis dan kasih diagnosis singkat.
Akhiri jawaban dengan 1-2 saran pertanyaan lanjutan.`;

        // Konversi format history Gemini bawaan ke format OpenAI
        const openaiHistory = history.map(h => ({
            role: (h.role === 'model' ? 'assistant' : 'user') as 'assistant' | 'user',
            content: h.parts[0].text
        }));

        const response = await this.openai.chat.completions.create({
            model: "gemini/gemini-2.5-pro",
            messages: [
                { role: "system", content: chatInstruction },
                ...openaiHistory,
                { role: "user", content: message }
            ]
        });

        return response.choices[0].message?.content || "";
    }
}
