import { Controller, Get, Query } from '@nestjs/common';
import { GeminiService } from './gemini/gemini.service';

@Controller()
export class AppController {
  // Kita suntikkan GeminiService ke sini
  constructor(private readonly geminiService: GeminiService) {}

  @Get('test-gemini')
  async testGemini(@Query('pesan') pesan: string) {
    // Panggil fungsi chat dari GeminiService
    return this.geminiService.chat(pesan || 'Halo, kamu siapa?', []);
  }
}
