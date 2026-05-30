import { IsEmail, IsNotEmpty, MinLength } from "class-validator";

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
    name: string;

    @IsEmail()
    @IsNotEmpty()
    email: string;

    @IsNotEmpty()
    @MinLength(8)
    password: string;
}