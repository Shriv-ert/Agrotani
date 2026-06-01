import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { GeminiService } from '../gemini/gemini.service';

@Injectable()
export class ChatService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly geminiService: GeminiService,
  ) {}

  async createSession(userId: string) {
    return this.prisma.chatSessions.create({
      data: {
        userId,
        title: 'Chat Baru',
      },
    });
  }

  async sendMessage(sessionId: string, message: string) {

  console.log('SESSION:', sessionId);
  console.log('MESSAGE:', message);

  await this.prisma.chatMessages.create({
    data: {
      sessionId,
      role: 'user',
      content: message,
    },
  });
    const response = await this.geminiService.chat(
      message,
      [],
    );

    await this.prisma.chatMessages.create({
      data: {
        sessionId,
        role: 'assistant',
        content: response,
      },
    });

    return {
        sessionId,
        reply: response,
  };
}
}