import { AuthService } from './auth.service';
import { Body, Controller, HttpCode, Post, Get, Patch, UseGuards } from '@nestjs/common';
import { UserRegistrationDto, UserLoginDto, UpdateProfileDto } from './dto/auth.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@Controller('auth')
export class AuthController {
    constructor(private readonly authService: AuthService) { }

    // Endpoint aslinya akan jadi /api/auth/register (otomatis oleh NestJS)
    @Post('register')
    @HttpCode(201) 
    async register(@Body() createUserDto: UserRegistrationDto): Promise<Record<string, any>> {
        return this.authService.register(createUserDto);
    }

    // Endpoint aslinya akan jadi /api/auth/login (otomatis oleh NestJS)
    @Post('login')
    @HttpCode(200)
    async login(@Body() userLoginDto: UserLoginDto): Promise<{ message: string, token?: string }> {
        return this.authService.login(userLoginDto);
    }

    // Endpoint GET profile
    @Get('profile')
    @UseGuards(JwtAuthGuard)
    async getProfile(@CurrentUser() user: any) {
        // user.id didapat dari JWT yang sudah dibongkar oleh JwtAuthGuard
        return this.authService.getProfile(user.id);
    }

    // Endpoint PATCH update profile (aboutMe)
    @Patch('profile')
    @UseGuards(JwtAuthGuard)
    async updateProfile(@CurrentUser() user: any, @Body() dto: UpdateProfileDto) {
        return this.authService.updateAboutMe(user.id, dto.aboutMe ?? '');
    }
}
