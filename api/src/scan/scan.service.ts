import { Injectable, NotFoundException } from '@nestjs/common';
import { GeminiService } from 'src/gemini/gemini.service';
import { PrismaService } from 'src/prisma/prisma.service';
import * as fs from 'fs'
@Injectable()
export class ScanService {
    constructor(
        private readonly prisma: PrismaService,
        private readonly geminiService: GeminiService,
    ){}

    async analyzeAndSave(file: Express.Multer.File, userId: string){
        // Baca gambar
        const imageBuffer = fs.readFileSync(file.path)
        const base64image = imageBuffer.toString('base64');
        const mimeType = file.mimetype;
        // panggil gemini
        const AIResponse = await this.geminiService.analyzeImage(base64image, mimeType);
        //parsing teks
        let diagnosis = AIResponse;
        let severity = "Tidak diketahui";
        let recommendation = "Tidak diketahui";
        let confidence = "Tidak diketahui";
        try {
            // Diagnosis: tangkap teks setelah **Diagnosis:** sampai newline
            const diagMatch = AIResponse.match(/\*{0,2}Diagnosis\*{0,2}[:\s]*([^\n]+)/i);
            if (diagMatch && diagMatch[1]) {
                diagnosis = diagMatch[1].replace(/\*/g, '').trim();
            }

            // Keparahan
            const sevMatch = AIResponse.match(/\*{0,2}Keparahan\*{0,2}[:\s]*([^\n]+)/i);
            if (sevMatch && sevMatch[1]) {
                let s = sevMatch[1].replace(/\*/g, '').toLowerCase();
                if (s.includes('ringan') || s.includes('rendah')) severity = 'Ringan';
                else if (s.includes('parah') || s.includes('tinggi') || s.includes('berat')) severity = 'Parah';
                else if (s.includes('sedang')) severity = 'Sedang';
                else severity = sevMatch[1].replace(/\*/g, '').trim();
            }

            // Keyakinan: cari angka persentase
            const confMatch = AIResponse.match(/\*{0,2}Keyakinan\*{0,2}[:\s]*.*?(\d+)\s*%/i);
            if (confMatch && confMatch[1]) {
                confidence = `${confMatch[1]}%`;
            } else {
                // Fallback cari persentase di baris yang sama atau dekat
                const confMatchFallback = AIResponse.match(/Keyakinan.*?(\d+)%/i);
                if (confMatchFallback && confMatchFallback[1]) confidence = `${confMatchFallback[1]}%`;
            }

            // Rekomendasi: dari keyword Rekomendasi sampai sebelum Catatan atau akhir teks
            const recMatch = AIResponse.match(/\*{0,2}Rekomendasi\*{0,2}[:\s]*([\s\S]*?)(?=\*{0,2}Catatan\*{0,2}[:\s]*|$)/i);
            if (recMatch && recMatch[1]) {
                recommendation = recMatch[1].trim();
            }
        } catch (e) {
            console.error("gagal parsing teks", e);
        }

        // Fallback jika tidak ada diagnosis yang ter-parse, simpan seluruh response
        if (diagnosis === AIResponse || diagnosis === "") {
            diagnosis = AIResponse.split('\n')[0].substring(0, 50); // Ambil cuplikan saja
        }
        // simpan hasil ke DB
        const result = await this.prisma.scans.create({
            data: {
                userId: userId,
                imageUrl: `${file.path}`,
                diagnosis: diagnosis,
                severity: severity,
                confidence: confidence,
                recommendation: recommendation,
                rawResponse: AIResponse
            }
        });
        return result;
    }

    async getUserScans(userId: string, limit: number){
        return this.prisma.scans.findMany({
            where: {
                userId: userId
            },
            take: limit,
            orderBy: {
                createdAt: 'desc'
            }
        })
    }

    async getScanById(scanId: string, userId: string){
        const scan = await this.prisma.scans.findUnique({
            where: {
                id: scanId
            }
        })
        if(!scan || scan.userId !== userId){
            throw new NotFoundException("Scan tidak ditemukan");
        }
        return scan;
    }

    async addFeedback(scanId: string, userId: string, feedback: string){
        await this.getScanById(scanId, userId);

        return this.prisma.scans.update({
            where: {
                id: scanId
            },
            data: {
                feedback: feedback
            }
        })
    }


}
