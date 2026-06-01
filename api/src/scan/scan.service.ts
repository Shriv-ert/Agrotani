import { Injectable } from '@nestjs/common';
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
        const base64image = `data:image/${file.mimetype.split('/')[1]};base64,`+ imageBuffer.toString('base64');
        const mimeType = file.mimetype;
        // panggil gemini
        const AIResponse = await this.geminiService.analyzeImage(base64image, mimeType);
        //parsing teks
        let diagnosis = AIResponse;
        let severity = "Tidak diketahui";
        let recommendation = "Tidak diketahui";
        let confidence = "Tidak diketahui";
        try {
            const lines = AIResponse.split('\n');
            // cari index key
            const diagIndex = lines.findIndex(l => l.includes('Diagnosis'));
            const sevIndex = lines.findIndex(l => l.includes('Tingkat keparahan'));
            const recIndex = lines.findIndex(l => l.includes('Rekomendasi'));
            const confIndex = lines.findIndex(l => l.includes('Tingkat keyakinan'));
            
            // Ambil teks setelah key
            if (diagIndex !== -1 && lines[diagIndex+1]){
                diagnosis = lines[diagIndex+1].trim();
            }
            if (sevIndex !== -1 && lines[sevIndex+1]){
                diagnosis = lines[sevIndex+1].trim();
            }
            if (recIndex !== -1 && lines[recIndex+1]){
                diagnosis = lines[recIndex+1].trim();
            }
            if (confIndex !== -1 && lines[confIndex+1]){
                diagnosis = lines[confIndex+1].trim();
            }
        } catch (e) {
            console.error("gagal parsing teks", e);
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
            throw new Error("Scan tidak ditemukan");
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
