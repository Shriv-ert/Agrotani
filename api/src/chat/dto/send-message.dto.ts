import { IsNotEmpty, IsOptional, IsString, IsUUID } from 'class-validator';

export class SendMessageDto {
  @IsUUID()
  @IsOptional()
  sessionId?: string;

  @IsString()
  @IsNotEmpty()
  message: string;
}
