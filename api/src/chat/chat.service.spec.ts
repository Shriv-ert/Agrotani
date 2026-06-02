import { Test, TestingModule } from '@nestjs/testing';
import { ChatService } from './chat.service';
import { PrismaService } from '../prisma/prisma.service';
import { GeminiService } from '../gemini/gemini.service';

describe('ChatService', () => {
  let service: ChatService;
  const prismaMock = {
    chatSessions: {
      findUnique: jest.fn(),
      create: jest.fn(),
    },
    chatMessages: {
      create: jest.fn(),
    },
  };
  const geminiMock = {
    chat: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ChatService,
        { provide: PrismaService, useValue: prismaMock },
        { provide: GeminiService, useValue: geminiMock },
      ],
    }).compile();

    service = module.get<ChatService>(ChatService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should reject missing chat session', async () => {
    prismaMock.chatSessions.findUnique.mockResolvedValue(null);

    await expect(
      service.sendMessage(
        '816219a1-1f06-4091-b7a7-bb256e0d4ef1',
        { message: 'Halo', sessionId: 'some-session-id' }, // fix: dto adalah object, bukan string
      ),
    ).rejects.toThrow('Chat session tidak ditemukan');
  });
});
