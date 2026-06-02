import { Test, TestingModule } from '@nestjs/testing';
import { AppController } from './app.controller';
import { GeminiService } from './gemini/gemini.service';

describe('AppController', () => {
  let appController: AppController;
  const geminiMock = {
    chat: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    const app: TestingModule = await Test.createTestingModule({
      controllers: [AppController],
      providers: [{ provide: GeminiService, useValue: geminiMock }],
    }).compile();

    appController = app.get<AppController>(AppController);
  });

  describe('testGemini', () => {
    it('should call GeminiService chat', async () => {
      geminiMock.chat.mockResolvedValue('Halo');

      await expect(appController.testGemini('Halo')).resolves.toBe('Halo');
      expect(geminiMock.chat).toHaveBeenCalledWith('Halo', []);
    });
  });
});
