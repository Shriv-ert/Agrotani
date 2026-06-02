import { Injectable, UnauthorizedException, ConflictException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';
import { UserLoginDto, UserRegistrationDto } from './dto/auth.dto';
import * as bcrypt from 'bcrypt';

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

            const accessToken = this.jwtService.sign({ id: user.id });
            return {
                message: "Login berhasil",
                accessToken  // ✅ FIX #1: key diubah dari 'token' ke 'accessToken' agar cocok dengan Flutter
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
                throw new ConflictException("Email sudah terdaftar"); 
            }

            // 2. Hash password
            const hashedPassword = await bcrypt.hash(data.password, 10);

            // 3. Simpan ke database — termasuk field baru dari Flutter ✅ FIX #2
            const user = await this.prisma.users.create({
                data: {
                    name: data.name,
                    email: data.email,
                    password: hashedPassword,
                    phone: data.phone,
                    address: data.address,
                    aboutMe: data.aboutMe,
                }
            });

            // Jangan kembalikan password ke client!
            const { password: _, ...userWithoutPassword } = user;
            return userWithoutPassword;
        } catch (error) {
            throw error
        }
    }

    getProfile(id: string){
        return this.prisma.users.findUnique({
            where: {id},
            select: {
                id: true,
                name: true,
                email: true,
                phone: true,    // ✅ FIX #3: tambah field profil lengkap
                address: true,
                aboutMe: true,
                createdAt: true,
                _count: {
                    select: {
                        scans: true,
                        chatSessions: true
                    }
                }
            }
        });
    }
}

