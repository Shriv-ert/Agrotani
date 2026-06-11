import { IsEmail, IsNotEmpty, IsOptional, IsString, MinLength } from "class-validator";

export class UserLoginDto{

    @IsEmail()
    @IsNotEmpty()
    email: string;

    @IsNotEmpty()
    @MinLength(8)
    password: string;
}

export class UserRegistrationDto {
    @IsNotEmpty()
    @IsString()
    name: string;

    @IsEmail()
    @IsNotEmpty()
    email: string;

    @IsNotEmpty()
    @MinLength(8)
    password: string;

    @IsOptional()
    @IsString()
    phone?: string;

    @IsOptional()
    @IsString()
    address?: string;


    @IsOptional()
    @IsString()
    aboutMe?: string;
}

export class UpdateProfileDto {
    @IsOptional()
    @IsString()
    aboutMe?: string;
}