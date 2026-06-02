import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { GeminiService } from '../gemini/gemini.service';

@Injectable()
export class ChatService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly geminiService: GeminiService,
  ) {}

  async sendMessage(userId: string, dto: { sessionId?: string; message: string; imageUrl?: string }) {
    let sessionId = dto.sessionId;

    if (sessionId) {
      const session = await this.prisma.chatSessions.findUnique({
        where: { id: sessionId },
      });
      if (!session) {
        throw new NotFoundException('Chat session tidak ditemukan');
      }
      if (session.userId !== userId) {
        throw new ForbiddenException('Akses ditolak');
      }
    } else {
      const titleWords = dto.message.split(' ').slice(0, 5).join(' ');
      const session = await this.prisma.chatSessions.create({
        data: {
          userId,
          title: titleWords || 'Chat Baru',
        },
      });
      sessionId = session.id;
    }

    const history = await this.prisma.chatMessages.findMany({
      where: { sessionId },
      orderBy: { createdAt: 'asc' },
      take: 20,
    });

    const formattedHistory = history.map((msg) => ({
      role: msg.role === 'user' ? 'user' : 'model',
      parts: [{ text: msg.content }],
    }));

    await this.prisma.chatMessages.create({
      data: {
        sessionId,
        role: 'user',
        content: dto.message,
        imageUrl: dto.imageUrl ?? null, // ✅ FIX #4: simpan imageUrl jika ada
      },
    });

    const response = await this.geminiService.chat(
      dto.message,
      formattedHistory,
    );

    await this.prisma.chatMessages.create({
      data: {
        sessionId,
        role: 'bot',
        content: response,
      },
    });

    await this.prisma.chatSessions.update({
      where: { id: sessionId },
      data: { updatedAt: new Date() },
    });

    return {
      sessionId,
      reply: response,
    };
  }

  async getSessions(userId: string) {
    const sessions = await this.prisma.chatSessions.findMany({
      where: { userId },
      orderBy: { updatedAt: 'desc' },
      include: {
        messages: {
          orderBy: { createdAt: 'desc' },
          take: 1, // ✅ FIX #5: ambil pesan terakhir untuk preview di Flutter
        },
      },
    });

    // Ubah format agar Flutter bisa baca 'lastMessage' langsung
    return sessions.map((s) => ({
      id: s.id,
      title: s.title,
      createdAt: s.createdAt,
      updatedAt: s.updatedAt,
      lastMessage: s.messages[0] ?? null,
    }));
  }

  async getMessages(sessionId: string, userId: string) {
    const session = await this.prisma.chatSessions.findUnique({
      where: { id: sessionId },
    });
    if (!session) {
      throw new NotFoundException('Chat session tidak ditemukan');
    }
    if (session.userId !== userId) {
      throw new ForbiddenException('Akses ditolak');
    }

    return this.prisma.chatMessages.findMany({
      where: { sessionId },
      orderBy: { createdAt: 'asc' },
    });
  }
}
