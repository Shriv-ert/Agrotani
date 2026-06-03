import { GoogleGenerativeAI, Part } from '@google/generative-ai';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class GeminiService {
    private genAI : GoogleGenerativeAI;
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
        // fungsi dari this.config.get<string>('GEMINI_API_KEY') memiliki 2 tipe return antara string dan undefined
        // maka perlu dilakukan pengecekan apakah nilai kembalian dari fungsi tersebut adalah string
        const apiKey = this.config.get<string>('GEMINI_API_KEY');
        if(!apiKey){ // jika nilai kembalian dari fungsi this.config.get<string>('GEMINI_API_KEY') adalah undefined
            throw new Error('GEMINI_API_KEY is not defined');
        }
        // parameter dari fungsi GoogleGenerativeAI() hanya menerima tipe data string
        // apabila langsung tanpa mengecek nilai kembaliannya apakah string atau undefined
        // maka akan muncul error 
        this.genAI = new GoogleGenerativeAI(apiKey);
    }

    async analyzeImage(imageBase64: string, mimeType: string){
        const model = this.genAI.getGenerativeModel({ 
            model: "gemini-2.5-flash",
            systemInstruction: this.SYSTEM_INSTRUCTION
        });

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
        // Ubah dari base64 menjadi format yang dipahami gemini
        // Pastikan prefix 'data:...;base64,' dibuang jika ada
        let cleanBase64 = imageBase64;
        if (cleanBase64.includes(',')) {
            cleanBase64 = cleanBase64.split(',')[1];
        }
        const imageParts: Part = {
            inlineData:{
                data:cleanBase64,
                mimeType:mimeType
            }
        } 
        const result = await model.generateContent([prompt,imageParts]);
        const responseText = result.response.text();
        return responseText;
    }

    async chat(message: string, history: any[], user?: { name: string, aboutMe: string | null } | null){
        let userContext = '';
        if (user) {
            userContext = `\nInformasi User:\n- Nama: ${user.name}\n- Tentang saya: ${user.aboutMe || 'Belum diisi'}\nSebut nama user jika relevan.`;
        }
        
        // Kita gabungkan Base Prompt + FarmerBot Prompt di sini
        const chatInstruction = `${this.SYSTEM_INSTRUCTION}\n\nKamu adalah FarmerBot, teman ngobrol petani yang ramah.${userContext}
Jawab pertanyaan tentang pertanian dengan bahasa sederhana.
Berikan jawaban yang praktis dan bisa langsung dilakukan.
Jika user kirim foto, analisis dan kasih diagnosis singkat.
Akhiri jawaban dengan 1-2 saran pertanyaan lanjutan.`;
        const model = this.genAI.getGenerativeModel({ 
            model: "gemini-2.5-flash", 
            systemInstruction: chatInstruction 
        });
        const chatSession = model.startChat({
            history: history,
        });
        const result = await chatSession.sendMessage(message);
        return result.response.text();
    }
}
