import { Injectable, UnauthorizedException, ConflictException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';
import { UserLoginDto, UserRegistrationDto } from './dto/auth.dto';
import * as bcrypt from 'bcrypt';
import { users } from '@prisma/client';

@Injectable()
export class AuthService {
    constructor(private readonly prisma : PrismaService, private readonly jwtService: JwtService){}

    async login(data: UserLoginDto){
        try {
            const user = await this.prisma.users.findUnique({
                where: {
                    email: data.email
                }
            });

            if(!user){
                throw new UnauthorizedException("Email atau password salah");
            }

            const isMatch = await bcrypt.compare(data.password, user.password);
            if(!isMatch){
                throw new UnauthorizedException("Email atau password salah");
            }

            const token = this.jwtService.sign({ id: user.id });
            return {
                message: "Login berhasil",
                token
            }
        } catch (error) {
            throw error
        }
    }
    async register(data: UserRegistrationDto){
        try {
            // 1. Cek apakah email sudah terdaftar
            const existingUser = await this.prisma.users.findUnique({
                where: { email: data.email }
            });
            if (existingUser) {
                // Return error jika email sudah ada
                throw new ConflictException("Email sudah terdaftar"); 
            }

            // 2. Hash password sebelum disimpan! JANGAN simpan plain text.
            const hashedPassword = await bcrypt.hash(data.password, 10);

            // 3. Simpan ke database
            const user = await this.prisma.users.create({
                data: {
                    name: data.name,
                    email: data.email,
                    password: hashedPassword
                }
            });
            return user;
        } catch (error) {
            throw error
        }
    }
    getProfile(id: string){
        return this.prisma.users.findUnique({
            where: {id},
            select: {
                name: true,
                email: true,
                createdAt: true
            }
        });
    }
}
