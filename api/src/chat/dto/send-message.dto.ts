import { IsNotEmpty, IsOptional, IsString, IsUUID } from 'class-validator';

export class SendMessageDto {
  @IsUUID()
  @IsOptional()
  sessionId?: string;

  @IsString()
  @IsNotEmpty()
  message: string;

  @IsString()
  @IsOptional()
  imageUrl?: string; // URL gambar opsional (dari hasil scan, bisa dilampirkan ke chat)
}
