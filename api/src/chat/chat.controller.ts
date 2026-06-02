import { Body, Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
import { ChatService } from './chat.service';
import { SendMessageDto } from './dto/send-message.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@Controller('chat')
@UseGuards(JwtAuthGuard)
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  @Post('send')
  sendMessage(
    @Body() dto: SendMessageDto,
    @CurrentUser() user: any,
  ) {
    return this.chatService.sendMessage(user.id, dto);
  }

  @Get('sessions')
  getSessions(@CurrentUser() user: any) {
    return this.chatService.getSessions(user.id);
  }

  @Get(':id/messages')
  getMessages(
    @Param('id') id: string,
    @CurrentUser() user: any,
  ) {
    return this.chatService.getMessages(id, user.id);
  }
}