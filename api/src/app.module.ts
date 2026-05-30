import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { ConfigModule } from '@nestjs/config';

ConfigModule.forRoot({
  isGlobal: true,
})

@Module({
  imports: [PrismaModule],
  controllers: [AppController],
  providers: [AppService]
})
export class AppModule {}
