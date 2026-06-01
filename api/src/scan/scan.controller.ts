import { Controller, Post, Get, Param, Body, Query, UseGuards, UseInterceptors, UploadedFile, BadRequestException } from '@nestjs/common';
import { ScanService } from './scan.service';
import { FileInterceptor } from '@nestjs/platform-express';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { FeedbackDto } from './dto/feedback.dto';

@Controller('scan')
@UseGuards(JwtAuthGuard) // 🛡️ Lindungi semuanya!
export class ScanController {
    constructor(private readonly scanService: ScanService) {}

    // Rute Upload Foto
    @Post('analyze')
    @UseInterceptors(FileInterceptor('image', { dest: './uploads' })) // 📸 Multer akan otomatis simpan ke folder uploads
    async analyze(
        @UploadedFile() file: Express.Multer.File,
        @CurrentUser() user: any
    ) {
        if(!file) {
            throw new BadRequestException("Gambar tidak boleh kosong!");
        }
        return this.scanService.analyzeAndSave(file, user.id);
    }

    // Rute Lihat Riwayat
    @Get('history')
    async history(@CurrentUser() user: any, @Query('limit') limit = 10) {
        return this.scanService.getUserScans(user.id, Number(limit));
    }

    // Rute Lihat Detail Satu Scan
    @Get(':id')
    async detail(@Param('id') id: string, @CurrentUser() user: any) {
        return this.scanService.getScanById(id, user.id);
    }

    // Rute Kasih Feedback
    @Post(':id/feedback')
    async feedback(
        @Param('id') id: string,
        @Body() feedbackDto: FeedbackDto,
        @CurrentUser() user: any
    ) {
        return this.scanService.addFeedback(id, user.id, feedbackDto.feedback);
    }
}
