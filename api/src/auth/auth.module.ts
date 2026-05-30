import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { JwtModule } from '@nestjs/jwt';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { PassportModule } from '@nestjs/passport';
import { JwtStrategy } from './jwt.strategy';

@Module({
  imports: [JwtModule.registerAsync({
    imports: [ConfigModule],
    useFactory: async (config: ConfigService) => ({
      secret: config.get<string>('JWT_SECRET'),
      signOptions: { expiresIn: '1d' },
    }),
    inject: [ConfigService],
  }),
  PassportModule
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy],
  exports: [JwtStrategy, PassportModule]
})
export class AuthModule {}
