import { Body, Controller, Get, Post } from '@nestjs/common';
import { ChatService } from './chat.service';
import { SendMessageDto } from './dto/send-message.dto';

@Controller('chat')
export class ChatController {
  constructor(
    private readonly chatService: ChatService,
  ) {}

  @Get()
  test() {
    return {
      message: 'Chat module works',
    };
  }

  @Get('session')
  createSession() {
    return this.chatService.createSession(
      '816219a1-1f06-4091-b7a7-bb256e0d4ef1',
    );
  }

  @Post('send')
  sendMessage(
    @Body() dto: SendMessageDto,
  ) {
    return this.chatService.sendMessage(
      dto.sessionId,
      dto.message,
    );
  }
}